Return-Path: <linux-kernel-owner+w=401wt.eu-S1754499AbXEACfd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754499AbXEACfd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 22:35:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754504AbXEACfd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 22:35:33 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:53756 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754499AbXEACfJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 22:35:09 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Dave Jones <davej@redhat.com>, linux-kernel <linux-kernel@vger.kernel.org>,
       Andi Kleen <ak@suse.de>, Jeff Garzik <jeff@garzik.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Linus Torvalds <torvalds@osdl.org>
Subject: Re: arch/i386/boot rewrite, and all the hard-coded video cards
References: <463698D5.20102@zytor.com> <20070501015115.GJ26601@redhat.com>
	<4636A332.2070101@zytor.com>
Date: Mon, 30 Apr 2007 20:34:21 -0600
In-Reply-To: <4636A332.2070101@zytor.com> (H. Peter Anvin's message of "Mon,
	30 Apr 2007 19:17:22 -0700")
Message-ID: <m1odl51dci.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

"H. Peter Anvin" <hpa@zytor.com> writes:

> Dave Jones wrote:
>> 
>> I don't really care, but I wonder what the point is of rewriting something
>> that hardly ever gets notably changed, and is rarely (if ever?) a source
>> of bugs.  It might be crufty old assembly, but it's worked well for years.
>> 
>
> Well, it hardly gets notably changed because it is a nightmare to get it
> right, and when it is changed, it is likely to be a bug magnet.  The
> sheer number of bugs I have found in the process of figuring out what
> the current code is doing is pretty much evidence of that.  I'm
> surprised fewer bugs are actually manifest, but I guess that shows how
> little of the code is actually used.

This sounds plausible.  Although I don't recall seeing that many bugs.
Even if we don't merge your changes the knowledge of the code gained
should be invaluable for future maintenance purposes.  I reserve judgement
on the sanity of the rewrite until I see the patches.

> The "solution" that people have been employing has been to require the
> use of special bootloaders for different environments, which enter at
> code32_start instead.  Hardly an improvement.

This part is incorrect.  Every example I have seen of entering in at
a different entry point is because the environment does not support
16bit BIOS calls.  So the easiest way to skip the kernels BIOS calls
is to skip setup.S.

Not that the x86 BIOS is bad.  It is nearly a marvel in it's simplicity
and ubiquitousness, but it isn't everywhere, and it doesn't make
sense for it to be everywhere.

Eric
