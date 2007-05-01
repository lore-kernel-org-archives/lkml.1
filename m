Return-Path: <linux-kernel-owner+w=401wt.eu-S1423810AbXEAFzk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423810AbXEAFzk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 01:55:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423811AbXEAFzk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 01:55:40 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:39265 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423810AbXEAFy7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 01:54:59 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Andi Kleen <ak@suse.de>
Cc: vgoyal@in.ibm.com, Kexec Mailing List <kexec@lists.infradead.org>,
       linux-kernel@vger.kernel.org, Jurriaan <thunder7@xs4all.nl>,
       Helge Hafting <helgehaf@aitel.hist.no>, Horms <horms@verge.net.au>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/2] x86_64: Reflect the relocatability of the kernel in the ELF header.
References: <m1slah6gm0.fsf@ebiederm.dsl.xmission.com>
	<200704301717.08230.ak@suse.de> <20070501035539.GA15472@in.ibm.com>
	<m14pmx18ey.fsf@ebiederm.dsl.xmission.com>
	<20070501050657.GA23111@in.ibm.com>
	<m1zm4pyuzp.fsf@ebiederm.dsl.xmission.com>
	<20070501062554.GT25929@bingen.suse.de>
Date: Mon, 30 Apr 2007 23:54:22 -0600
In-Reply-To: <20070501062554.GT25929@bingen.suse.de> (Andi Kleen's message of
	"Tue, 1 May 2007 08:25:55 +0200")
Message-ID: <m1r6q1ytpt.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen <ak@suse.de> writes:

> On Mon, Apr 30, 2007 at 11:26:50PM -0600, Eric W. Biederman wrote:
>> Vivek Goyal <vgoyal@in.ibm.com> writes:
>> 
>> 
>> >> At least without a core file it is working on with gdb 6.4.
>> >>
>> >
>> > This seems to be a problem with gdb 6.5. I transferred the dump to a
>> > different machine having GNU gdb 6.4, and it works fine there.
>> 
>> Ok.  The difference between those two symbols didn't seem to make
>> any sense, so a gdb bug makes sense.
>> 
>> Cool.  Then the patch is good. :)
>
> It would still make any gdb 6.5 users unhappy. If no workaround can be found
> I guess we'll need a CONFIG of some sort?

It is probably worth reproducing this bug with a PIE executable.
But it looks very much like gdb got it wrong, or else there is some
slight mismatch between our core dump and gdb.

Given that gdb 6.5 handles the vmlinux fine when it isn't in conjunction
with a core dump I would not say the problem is in vmlinux.

Rather there seems to be something messed up when gdb 6.5 tries to match
up the kernel core dump with the kernel.  The offset for the symbol
Vivek gave was 0x7fff70e9. ???  Although that is almost 2M...

Vivek could we see the program headers of your core file?

>From what I can tell what is left to figure out is do we have
a bug in gdb 6.5 or do we have a bug in our core file generation.

Right now I'm inclined to believe that the fedora core 6? gdb 6.5 got it
wrong.  I'm probably just burnt out with binutils problems whenever
I try and do something interesting.  But I'm just not inclined that
the bleeding edge tools are working properly while there kernel
core dump mechanism would mess up with a two byte field change.

It does make sense to root cause this if we can.  If it's a gdb
problem it should also apply to PIE executables, and should irritate
a few users.

Regardless last I heard it was crash that was the primary analysis
tool and not gdb anyway.  With gdb serving as the double check to make
certain that the kernel core dump was in a reasonably standard format.

Eric
