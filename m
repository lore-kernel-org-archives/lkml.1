Return-Path: <linux-kernel-owner+w=401wt.eu-S1756136AbXKAQVU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756136AbXKAQVU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2007 12:21:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753160AbXKAQVI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Nov 2007 12:21:08 -0400
Received: from lobo.ruivo.org ([66.92.68.119]:38347 "EHLO lobo.ruivo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753243AbXKAQVH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2007 12:21:07 -0400
X-Greylist: delayed 1822 seconds by postgrey-1.27 at vger.kernel.org; Thu, 01 Nov 2007 12:21:06 EDT
Date: Thu, 1 Nov 2007 11:50:31 -0400
From: Aristeu Rozanski <aris@ruivo.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Truxton Fulton <trux@truxton.com>,
       Hiroto Shibuya <hiroto.shibuya@gmail.com>,
       Lee Garrett <lee-in-berlin@web.de>, linux-kernel@vger.kernel.org,
       "bugme-daemon@kernel-bugs.osdl.org" 
	<bugme-daemon@bugzilla.kernel.org>,
       ak@suse.de, torvalds@osdl.org
Subject: Re: [Bugme-new] [Bug 8378] New: Averatec 3156X laptop doesn't
	reboot with kernels > 2.6.13.5 (responsible commit found)
Message-ID: <20071101155031.GB8068@cathedrallabs.org>
References: <200704271742.l3RHgPTH019561@fire-2.osdl.org> <20070427144434.970de79f.akpm@linux-foundation.org> <m2k5vx6vce.fsf@truxton.com> <4646171E.7090609@web.de> <20070512180240.7a8923d5.akpm@linux-foundation.org> <m2sl4tyloc.fsf@truxton.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m2sl4tyloc.fsf@truxton.com>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,
> > OK, thanks.
> > 
> > So that are we doing here?  We try the pre-Truxton code and if that didn't
> > work we try the post-Truxton code?  Hard to see how that could go wrong.
> > 
> > Truxton, can you please test it for us?
> 
> Hiroto Shibuya wrote to tell me that he has a VIA EPIA-EK10000
> which suffers from the reboot problem when no keyboard is attached.
> My first patch works for him :
> 
>   http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=59f4e7d572980a521b7bdba74ab71b21f5995538
> 
> But the latest patch does not work for him :
> 
>   http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=8b93789808756bcc1e5c90c99f1b1ef52f839a51
> 
> We found that it was necessary to also set the "disable keyboard"
> flag in the command byte, as the first patch was doing.  The
> second patch tries to minimally modify the command byte, but
> it is not enough.
> 
> Please consider this simple one-line patch to help people with
> low end VIA motherboards reboot when no keyboard is attached.
> Hiroto Shibuya has verified that this works for him (as I
> no longer have an afflicted machine) :
> 
> This patch is against linux-2.6.23-rc9/include/asm-i386/mach-default/mach_reboot.h
> 
> --- mach_reboot.h       Mon Oct  1 20:24:52 2007
> +++ mach_reboot.h.new   Tue Oct  2 19:22:13 2007
> @@ -49,7 +49,7 @@
>                 udelay(50);
>                 kb_wait();
>                 udelay(50);
> -               outb(cmd | 0x04, 0x60); /* set "System flag" */
> +               outb(cmd | 0x14, 0x60); /* set "System flag" and "Keyboard Disabled" */
>                 udelay(50);
>                 kb_wait();
>                 udelay(50);
> 
> 
any chance to get this into next -mm?

-- 
Aristeu

