Return-Path: <linux-kernel-owner+w=401wt.eu-S1161024AbXEDROQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161024AbXEDROQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2007 13:14:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031443AbXEDROQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 May 2007 13:14:16 -0400
Received: from terminus.zytor.com ([192.83.249.54]:46035 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031440AbXEDROP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2007 13:14:15 -0400
Message-ID: <463B69AB.2030706@zytor.com>
Date: Fri, 04 May 2007 10:13:15 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: Rusty Russell <rusty@rustcorp.com.au>, Andi Kleen <ak@suse.de>,
       Chris Wright <chrisw@sous-sol.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>, Zachary Amsden <zach@vmware.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH 1/3] Replace paravirt_probe with "platform type" boot
 header field
References: <1178283582.23670.67.camel@localhost.localdomain>	<m1zm4ksn5o.fsf@ebiederm.dsl.xmission.com>	<1178288329.23670.86.camel@localhost.localdomain>	<m1tzussm4z.fsf@ebiederm.dsl.xmission.com>	<463B56A0.7090805@zytor.com> <m1mz0kr0ux.fsf@ebiederm.dsl.xmission.com>
In-Reply-To: <m1mz0kr0ux.fsf@ebiederm.dsl.xmission.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Eric W. Biederman wrote:
> "H. Peter Anvin" <hpa@zytor.com> writes:
> 
>> Eric W. Biederman wrote:
>>> Unlikely.  Unless we expect that this offset will come in non-zero.
>>>
>> You might have to worry about that.  Historically, the "zero-page" was
>> really just the setup code overwritten, and it's still true for a big
>> chunk of it.
>>
>> One of the major changes in my setup code rewrite is to start out with
>> an all-zero chunk of memory for this.
> 
> Well as long as we are in sync with setup.S we are fine.  The issue
> is people generating the real-mode data from scratch, when using the
> 32bit entry point.

Point.  I'd like that interface to specify that any undefined fields
should be zero, or we have a hopeless situation on our hands.

By the way, see the following for the structure definition; prepare to barf:

http://git.kernel.org/?p=linux/kernel/git/hpa/linux-2.6-newsetup.git;a=blob;f=arch/i386/boot/boot.h;h=41a16f96ac3476cbd969aabe5e6a792ffe8c64a0;hb=HEAD

[I intend to move this into include/asm-i386/boot.h, but haven't gotten
that far yet.  I just yesterday got the code booting on both i386 and
x86-64, but haven't committed all the include/asm-* mods that went a
long with that yet.  I'm also waiting for a Kbuild fix so that the boot
directory can be shared between i386 and x86-64 without requiring a
symlink in the source tarball.]

	-hpa
