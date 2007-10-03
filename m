Return-Path: <linux-kernel-owner+w=401wt.eu-S1757530AbXJCC5m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757530AbXJCC5m (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2007 22:57:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754310AbXJCC5f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Oct 2007 22:57:35 -0400
Received: from 208.65.181.93.static.etheric.net ([208.65.181.93]:60930 "EHLO
	nicotine.truxton.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753935AbXJCC5e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2007 22:57:34 -0400
X-Greylist: delayed 1625 seconds by postgrey-1.27 at vger.kernel.org; Tue, 02 Oct 2007 22:57:34 EDT
From: Truxton Fulton <trux@truxton.com>
To: Andrew Morton <akpm@linux-foundation.org>,
       "Hiroto Shibuya" <hiroto.shibuya@gmail.com>
Cc: Lee Garrett <lee-in-berlin@web.de>, linux-kernel@vger.kernel.org,
       "bugme-daemon@kernel-bugs.osdl.org" 
	<bugme-daemon@bugzilla.kernel.org>,
       ak@suse.de, torvalds@osdl.org
Subject: Re: [Bugme-new] [Bug 8378] New: Averatec 3156X laptop doesn't  reboot with kernels > 2.6.13.5 (responsible commit found)
In-Reply-To: <20070512180240.7a8923d5.akpm@linux-foundation.org> (Andrew
	Morton's message of "Sat, 12 May 2007 18:02:40 -0700")
References: <200704271742.l3RHgPTH019561@fire-2.osdl.org>
	<20070427144434.970de79f.akpm@linux-foundation.org>
	<m2k5vx6vce.fsf@truxton.com> <4646171E.7090609@web.de>
	<20070512180240.7a8923d5.akpm@linux-foundation.org>
X-Prognosticator: 42
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAElBMVEUSDgpyVTOTZDz
 JooRMMRkrIRJCKOHSAAACaklEQVR4nE1Twa7jIAxkpeZeU3J/GN79NeTdS2vu6Qr//6/smCT
 a0laVGOyZMYNzY02t11spWVU3d6zJvq9KMZVSFnWTuo9FnJIBpazb9rHfn1z2/VJ+PyouzyU
 x81HzPf0v4OQr+7PmcbKr3GINRLzvL+uxP2lNOUglOkr8QT89yQvWjY6KGA5vniK13oWtIhW
 mYCXbpJFzqG2ug+O+RPKDXiXgI+9eD/Is1E2qe9faQdFP7hjmL+ulOTSpIvXwsXAIX9UA9Gn
 Yj8ynqJYfaLbR39717TnxXpLD49vUXqTpdKmebRnEQauNC8fbBElYy+i2RAk24U314Trthwd
 NCEH/ON0EQKVz6KZ3fm3NXVRa09HpMFh4Yr061wRJGNTnJfrvvD0ww9ZVPMd5CDDM1/yYcB2
 QJQwlT3kykwRmyS/MRHtvOBs9BUrxLdFzjj9fbuvtYgBHIl/uwccbB57hXFTbLgoECypLEf8
 LjqaY+QmUIU78fXMKoH0CkCW1uVGx+4inda5JTJS+dTfoD+vpnuKEkfSmOgAIHZBf0y+mrip
 b340w30Yr5h8DWhtA8MdElsWvEUmHDRD5KGKdFksDZ0ykty6bAUSERODq73BiwDyA4T0SIyt
 MfENIYEIeEEB7GgCkFSm7OsHQobdbTMjMxLT+DWV2YkPEK5YjQMEvqMATQWj7FZigGaBYfQx
 AnAHWyv4QFa5PjhZx54KomccPSK2RYp4ly8PZI9vUmLS/PbRFuXZ5NWdJh2K068i9j0xtDoF
 WABjWBRWWIrA889xXqWWQ64SKJr1KothuaP4qzp5rt2sfK3CVNRvwD3ipzBvlIAzfAAAAAEl
 FTkSuQmCC
Date: Tue, 02 Oct 2007 19:30:27 -0700
Message-ID: <m2sl4tyloc.fsf@truxton.com>
User-Agent: Gnus/5.110004 (No Gnus v0.4) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote (at Sat, 12 May 2007 18:02:40 -0700) :
> 
> OK, thanks.
> 
> So that are we doing here?  We try the pre-Truxton code and if that didn't
> work we try the post-Truxton code?  Hard to see how that could go wrong.
> 
> Truxton, can you please test it for us?

Hi,

Hiroto Shibuya wrote to tell me that he has a VIA EPIA-EK10000
which suffers from the reboot problem when no keyboard is attached.
My first patch works for him :

  http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=59f4e7d572980a521b7bdba74ab71b21f5995538

But the latest patch does not work for him :

  http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=8b93789808756bcc1e5c90c99f1b1ef52f839a51

We found that it was necessary to also set the "disable keyboard"
flag in the command byte, as the first patch was doing.  The
second patch tries to minimally modify the command byte, but
it is not enough.

Please consider this simple one-line patch to help people with
low end VIA motherboards reboot when no keyboard is attached.
Hiroto Shibuya has verified that this works for him (as I
no longer have an afflicted machine) :

This patch is against linux-2.6.23-rc9/include/asm-i386/mach-default/mach_reboot.h

--- mach_reboot.h       Mon Oct  1 20:24:52 2007
+++ mach_reboot.h.new   Tue Oct  2 19:22:13 2007
@@ -49,7 +49,7 @@
                udelay(50);
                kb_wait();
                udelay(50);
-               outb(cmd | 0x04, 0x60); /* set "System flag" */
+               outb(cmd | 0x14, 0x60); /* set "System flag" and "Keyboard Disabled" */
                udelay(50);
                kb_wait();
                udelay(50);


Thanks,

-Truxton
