Return-Path: <linux-kernel-owner+w=401wt.eu-S1758781AbXEMMNR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758781AbXEMMNR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 May 2007 08:13:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757448AbXEMMNJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 May 2007 08:13:09 -0400
Received: from 208.65.181.93.static.etheric.net ([208.65.181.93]:42910 "EHLO
	nicotine.truxton.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757188AbXEMMNI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 May 2007 08:13:08 -0400
From: Truxton Fulton <trux@truxton.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Lee Garrett <lee-in-berlin@web.de>, linux-kernel@vger.kernel.org,
       "bugme-daemon@kernel-bugs.osdl.org" 
	<bugme-daemon@bugzilla.kernel.org>
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
Date: Sun, 13 May 2007 05:13:04 -0700
Message-ID: <m2bqgorkfj.fsf@truxton.com>
User-Agent: Gnus/5.110004 (No Gnus v0.4) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote (at Sat, 12 May 2007 18:02:40 -0700) :
> 
> 
> On Sat, 12 May 2007 21:35:58 +0200 Lee Garrett <lee-in-berlin@web.de> wrote:
> 
>> Truxton Fulton wrote:
>> > Hi,
>> > 
>> > I verified on my IDEQ210M that performing the old reboot sequence
>> > followed by the new reboot sequence works for me, and I suspect that
>> > it will work for Lee also.  Like this :
>> > 
>> > 	/* old method, works on most machines */
>> >         for (i = 0; i < 100; i++) {
>> >                 kb_wait();
>> >                 udelay(50);
>> >                 outb(0xfe, 0x64);         /* pulse reset low */
>> >                 udelay(50);
>> >         }
>> > 
>> > 	/* new method, sets the "System flag" which when set,
>> > 	   indicates successful completion of the keyboard controller
>> > 	   self-test (Basic Assurance Test, BAT).  This is needed
>> > 	   for some machines with no keyboard plugged in */
>> >         for (i = 0; i < 100; i++) {
>> >                 kb_wait();
>> >                 udelay(50);
>> >                 outb(0x60, 0x64);         /* write Controller Command Byte */
>> >                 udelay(50);
>> >                 kb_wait();
>> >                 udelay(50);
>> >                 outb(0x14, 0x60);         /* set "System flag" */
>> >                 udelay(50);
>> >                 kb_wait();
>> >                 udelay(50);
>> >                 outb(0xfe, 0x64);         /* pulse reset low */
>> >                 udelay(50);
>> >         }
>> > 
>> > Thanks,
>> > 
>> > -Truxton
>> 
>> Hello everyone,
>> 
>> I compiled a 2.6.21.1 kernel with Truxton's suggestion mentioned 
>> above. My laptop reboots normally with it. For convenience I've 
>> diffed a patch, which is appended to this mail.
>> 
> 
> OK, thanks.
> 
> So that are we doing here?  We try the pre-Truxton code and if that didn't
> work we try the post-Truxton code?  Hard to see how that could go wrong.
> 
> Truxton, can you please test it for us?

Hi,

Segher suggested a better implementation that did a read-modify-write
sequence.  I tested a few different combinations of these rebooting
approaches, and found that each one individually correctly rebooted
my headless machine (Biostar iDEQ 210M with VIA PM800 + VT8237 chipset).

A = original "pulse reset low"
B = my patch that sets the system flag (with possibly bad assumptions about other flags)
C = Segher's read-modify-write to set only the system flag.

So, the bad news is that I no longer have a baseline test
(because A works for me now).  I updated the bios a while ago,
and this is a different physical machine than the others I
was testing last year (which are now in production and I
cannot use to test), although the model is the same.

So, if you want to revert my patch all together, that's fine.
I think a foolproof reboot sequence would be A followed by C.

So here is my recommendation, which I have verified works on
my current machine :

Thanks,

-Truxton


--- mach_reboot.h.orig  2007-05-13 05:04:43.000000000 -0700
+++ mach_reboot.h       2007-05-13 05:01:02.000000000 -0700
@@ -19,20 +19,42 @@
 static inline void mach_reboot(void)
 {
        int i;
-       for (i = 0; i < 100; i++) {
-               kb_wait();
-               udelay(50);
-               outb(0x60, 0x64);       /* write Controller Command Byte */
-               udelay(50);
-               kb_wait();
-               udelay(50);
-               outb(0x14, 0x60);       /* set "System flag" */
-               udelay(50);
-               kb_wait();
-               udelay(50);
-               outb(0xfe, 0x64);       /* pulse reset low */
-               udelay(50);
-       }
+       u8 cmd ;
+
+
+       /* old method, works on most machines */
+        for (i = 0; i < 100; i++) {
+         kb_wait();
+         udelay(50);
+         outb(0xfe, 0x64);         /* pulse reset low */
+         udelay(50);
+        }
+
+       /* new method, sets the "System flag" which when set,
+          indicates successful completion of the keyboard controller
+          self-test (Basic Assurance Test, BAT).  This is needed
+          for some machines with no keyboard plugged in.
+          This read-modify-write sequence sets only the system flag. */
+        for (i = 0; i < 100; i++) {
+         outb(0x20, 0x64);       /* read Controller Command Byte */
+         udelay(50);
+         kb_wait();
+         udelay(50);
+         cmd = inb(0x60);
+         udelay(50);
+         kb_wait();
+         udelay(50);
+         outb(0x60, 0x64);       /* write Controller Command Byte */
+         udelay(50);
+         kb_wait();
+         udelay(50);
+         outb(cmd | 0x04, 0x60); /* set "System flag" */
+         udelay(50);
+         kb_wait();
+         udelay(50);
+         outb(0xfe, 0x64);         /* pulse reset low */
+         udelay(50);
+        }
 }
 
 #endif /* !_MACH_REBOOT_H */
