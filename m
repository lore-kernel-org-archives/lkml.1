Return-Path: <linux-kernel-owner+w=401wt.eu-S1161875AbXEDS5F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161875AbXEDS5F (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2007 14:57:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161886AbXEDS5E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 May 2007 14:57:04 -0400
Received: from terminus.zytor.com ([192.83.249.54]:58909 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161875AbXEDS5B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2007 14:57:01 -0400
Message-ID: <463B81BC.1030504@zytor.com>
Date: Fri, 04 May 2007 11:55:56 -0700
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
References: <1178283582.23670.67.camel@localhost.localdomain>	<m1zm4ksn5o.fsf@ebiederm.dsl.xmission.com>	<1178288329.23670.86.camel@localhost.localdomain>	<m1tzussm4z.fsf@ebiederm.dsl.xmission.com>	<463B56A0.7090805@zytor.com>	<m1mz0kr0ux.fsf@ebiederm.dsl.xmission.com>	<463B69AB.2030706@zytor.com> <m1vef8phjy.fsf@ebiederm.dsl.xmission.com>
In-Reply-To: <m1vef8phjy.fsf@ebiederm.dsl.xmission.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Eric W. Biederman wrote:
> 
> You should be able to just include linux/screen_info.h instead of duplicating
> it inline.
> 

I'm working on it!!!!!

> I like the use of struct header in the middle of boot_params that
> seems like a nice maintenance device, although I'm not quite certain about
> 
> However you haven't documented the old swap_dev field in struct header.
> At least rdev still knows about it, so it is probably inappropriate to
> merge it with syssize.  Not that syssize is actually useful for anything
> in a modern system.

Actually, ROM bootloaders care about it, which is why it was expanded
out in boot loader protocol 2.04; see the documentation.

> So I just looked at what /sbin/kexec does so we know what to expect.
> If I have a bzImage I just grab the first setup_sects (i.e. setup.S) and make
> it the initial linux boot parameters, placing the command line immediately
> afterwards.
> 
> If I just have a vmlinux so I have to fake it I memset x86_linux_faked_param_header
> to zero, before placing in the values I care about.  And the size.  4K aka 1 page.
> Although I due put the command line at 2K, I think that is actually the historical
> kernel usage of the zero page.

Oh flippin' hell.  *STABBITY STAB STAB STAB*.

All of which is just evil.  So much for "oh, the definition of the
zeropage never changes, so it doesn't matter."

> elilo does something similar but starts with a 16K pages and then backs up
> 2K for the command line.
> 
> Gujin does something similar but also seems to place a command line at 2K.
> 
> So short of the first 2K we can reasonably expect new parameters to be zero
> initialized.  Past that we need to be a little more careful.

Oh flippin' hell.

> And 4K seems to be our maximum size for backwards compatibility.  Although
> we use it in a fairly sparse way, so we should be ok.

Sort of.  It's pretty full.

	-hpa
