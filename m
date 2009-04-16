Return-Path: <linux-kernel-owner+w=401wt.eu-S1753966AbZDPCji@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753966AbZDPCji (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Apr 2009 22:39:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752168AbZDPCjZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Apr 2009 22:39:25 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42593 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751014AbZDPCjY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Apr 2009 22:39:24 -0400
Date: Wed, 15 Apr 2009 19:34:40 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Rusty Russell <rusty@rustcorp.com.au>
cc: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Dave Jones <davej@redhat.com>
Subject: Re: Fix quilt merge error in acpi-cpufreq.c
In-Reply-To: <200904161130.28129.rusty@rustcorp.com.au>
Message-ID: <alpine.LFD.2.00.0904151922220.4042@localhost.localdomain>
References: <200904140159.n3E1x1K1014705@hera.kernel.org> <alpine.LFD.2.00.0904151013260.4132@localhost.localdomain> <49E62BD5.6090508@zytor.com> <200904161130.28129.rusty@rustcorp.com.au>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 16 Apr 2009, Rusty Russell wrote:
> 
> Side note: I really prefer to see the compile error output in this case: great
> for googling.  It annoys me when people skip this.

I do agree that that's generally a good idea, although I will tend to edit 
it down when people send in 20 lines of compile errors. Nobody cares at 
that point, and it doesn't add value. Give the first few errors, not a 
whole log-ful of them.

I also ask that people edit away the irrelevant site-specific parts. I do 
that editing myself when I notice, but in case it goes through somebody 
who doesn't, or in case I don't notice, look which one is more readable 
and informative:

    Fix the following warning:
    
    fs/fuse/file.c: In function 'fuse_direct_io':
    fs/fuse/file.c:1002: warning: passing argument 3 of 'fuse_get_user_pages' from incompatible pointer type

or

    Fix staging/rt28x0 printk format warnings:
    
    linux-next-20090209/drivers/staging/rt2860/common/spectrum.c:1599: warning: format '%d' expects type 'int', but argument 3 has type
    linux-next-20090209/drivers/staging/rt2860/rt_linux.c:857: warning: format '%d' expects type 'int', but argument 3 has type 'long u

and realize that the "linux-next-20090209/" part doesn't help (and that's 
a pretty _mild_ example of this particular issue, we have tons of examples 
of absolute pathname prefixes like "/home/jeremy/hg/xen/paravirt/linux/", 
so if you look at the log in even a 100-character wide window, you hardly 
see any of the actual _warning_ at all, it's mostly all just pathnames ;)

> Let's get concrete.  Here's the top 3 non-merge commits in gitk:
> 
>     ALSA: hda - Fix the cmd cache keys for amp verbs
>     
>     Fix the key value generation for get/set amp verbs.  The upper bits of
>     the parameter have to be combined with the verb value to be unique for
>     each direction/index of amp access.
>     
>     This fixes the resume problem on some hardwares like Macbook after
>     the channel mode is changed.
> 
> I have no idea what this patch does.  It seems to be a fix; what are the
> symptoms of the problem, and how long has it been there? 

Oh, I'm absolutely not going to claim that we should not improve on 
changelogs in general. But if you actually look at that commit, I would 
argue that the commit message together with the patch is likely not that 
bad to understand for somebody who understands the hardware well enough 
for the code to make sense in the first place!

So could it be improved? I suspect _every_ commit message can be improved. 
But do you really think that an "Impact" statment would be the big deal? 
Or, in fact, any kind of "fixed message format".

>     ALSA: add missing definitions(letters) to HD-Audio.txt
>     
>     impact: Add missing definitions(letters).

And here, the "impact:" part certainly in no way improves anything. 

>     ALSA: sound/pci: use memdup_user()
>     
>     Remove open-coded memdup_user().
> 
> Again, the body seems gratuitous.

And yes, I agree that in many cases you don't need a body at all. If the 
patch is trivial, and the subject tells it all, then why bother with a 
body? We've got a fair number of those.

That said, I'd rather have a few redundant (but still readable) bodies. 
And as mentioned, I don't think a "perfect" changelog exists. Some people 
will always want more, others will think it's unnecessary. And even if a 
perfect changelog existed, we'll never have the perfect people who write 
them.

But machine-readability should be the _last_ thing we look for.

			Linus
