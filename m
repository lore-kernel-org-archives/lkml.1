Return-Path: <linux-kernel-owner+w=401wt.eu-S1762925AbZFKLsl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762925AbZFKLsl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jun 2009 07:48:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756722AbZFKLsc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Jun 2009 07:48:32 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:40984 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754058AbZFKLsc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jun 2009 07:48:32 -0400
Date: Thu, 11 Jun 2009 13:48:25 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Brian Swetland <swetland@google.com>
Cc: kernel list <linux-kernel@vger.kernel.org>,
       linux-arm-kernel <linux-arm-kernel@lists.arm.linux.org.uk>,
       ibm@android.com, san@android.com, rlove@google.com
Subject: Re: HTC Dream aka. t-mobile g1 support
Message-ID: <20090611114825.GD7523@elf.ucw.cz>
References: <20090610103131.GB13885@elf.ucw.cz> <a55d774e0906101043q580fc5e5iad25a79203dc52c@mail.gmail.com> <20090611081012.GD8592@elf.ucw.cz> <a55d774e0906110127k1633dd90x96863c3dd6f888cf@mail.gmail.com> <20090611110946.GA7523@elf.ucw.cz> <a55d774e0906110424q631c83d5l5a5ba8bc0a1093b8@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <a55d774e0906110424q631c83d5l5a5ba8bc0a1093b8@mail.gmail.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 2009-06-11 04:24:03, Brian Swetland wrote:
> On Thu, Jun 11, 2009 at 4:09 AM, Pavel Machek<pavel@ucw.cz> wrote:
> >
> > Anyway, now I have a tree, and yes it compiles. (After some
> > "interesting" questions; perhaps defconfig should be updated?)
> >
> > Unfortunately, upon fastboot boot uImage, it hangs with black screen
> > and backlight on.
> 
> You'll need to fastboot boot arch/arm/boot/zImage ramdisk.img

Aha, fastboot implies that ramdisk is optional.. apparently it is not.

> Extracting the ramdisk.img from the boot.img in the boot partition on
> an existing device is a pain.  If you happen to have a cupcake
> userspace built from source that ramdisk.img should be suitable.  If
> not, I'll try to dig up a suitable ramdisk image tomorrow -- it's just
> init, init.rc, and adb, but it is necessary to boot.

I tried using ramdisk.img from sdk:

root@amd:/data/l/android# ./fastboot boot
/data/l/linux-msm/arch/arm/boot/uImage
/data/l/android/sdk/platforms/android-1.5/images/ramdisk.img
creating boot image...
creating boot image - 1884160 bytes
downloading 'boot.img'... OKAY
booting... OKAY
root@amd:/data/l/android# ls -al
/data/l/android/sdk/platforms/android-1.5/images/ramdisk.img
-rw-rw-rw- 1 pavel pavel 145785 May 15 03:13
/data/l/android/sdk/platforms/android-1.5/images/ramdisk.img

...no luck :-(.

> > I _think_ I got config right, most "interesting"
> > question was
> >
> > AMSS modem firmware version
> >  1. 6.2.10 (MSM_AMSS_VERSION_6210)
> >  2. 6.2.20 (MSM_AMSS_VERSION_6220)
> >> 3. 6.2.20 + New ADSP (MSM_AMSS_VERSION_6225)
> >  4. 6.3.50 (MSM_AMSS_VERSION_6350) (NEW)
> >
> > ...and I just selected "3" being default. No help available :-(. I
> > have cupcake installed, and I believe I installed radio update
> > required for cupcake. Can someone help? (And write Kconfig help text?
> > :-).
> 
> This is correct.  The shipping dream/sapphire devices are using AMSS
> 6.2.20+patches, which is option 3.
> 
> I'll look over the Kconfig text and see what we can do here.  The
> problem is that the baseband firmware (AMSS) changes some of the rpc
> interfaces incompatibly between versions, and different generations of
> the same hardware could be shipping with somewhat different baseband
> firmware.  6210 and 6220 are completely obsolete (never used in
> anything in production) and we should drop them to avoid confusion.

Or at least add (obsolete) to kconfig help or something.

> >> > Ok, could we get the boards renamed? g1 is known as dream, having
> >> > trout+dream+g1+adp1 names for same piece of hardware is unnice.
> >>
> >> It's hard to have a single name since carriers tend to use different
> >> names in different markets.  We often start work on kernel support
> >> long before a product is announced, so we've been using the fish names
> >> to allow us to register board names with the ARM machine registry
> >> early on and not use bogus internal-only machine IDs.
> >
> > I know naming stuff is hard. But dream/g1/adp1 are both recognized by
> > outside people. I don't think "trout" has similar level of
> > recognition.
> 
> Would better descriptions in Kconfig help here?  That's a lot easier
> and less disruptive than renaming the machine types (and the userspace
> android world, for good or ill uses the machine name to identify the
> hardware version for some hardware specific configuration stuff at
> runtime).

Better Kconfig description would certainly be nice. Renaming
board-trout* to board-dream* would be also nice (and should be doable
without any intrusive changes...?)
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
