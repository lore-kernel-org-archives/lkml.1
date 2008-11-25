Return-Path: <linux-kernel-owner+w=401wt.eu-S1752606AbYKYOoH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752606AbYKYOoH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2008 09:44:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751387AbYKYOny
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Nov 2008 09:43:54 -0500
Received: from aun.it.uu.se ([130.238.12.36]:64485 "EHLO aun.it.uu.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750909AbYKYOnx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2008 09:43:53 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18732.3809.720247.329641@harpo.it.uu.se>
Date: Tue, 25 Nov 2008 15:42:41 +0100
From: Mikael Pettersson <mikpe@it.uu.se>
To: "David Ellingsworth" <david@identd.dyndns.org>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Promise PDC20376
In-Reply-To: <30353c3d0811250616o733fb7f9ob4af96dd604f78ea@mail.gmail.com>
References: <30353c3d0810240704n7476cc50y28b3eb8a5f326626@mail.gmail.com>
	<30353c3d0811250616o733fb7f9ob4af96dd604f78ea@mail.gmail.com>
X-Mailer: VM 7.17 under Emacs 20.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Ellingsworth writes:
 > On Fri, Oct 24, 2008 at 9:04 AM, David Ellingsworth
 > <david@identd.dyndns.org> wrote:
 > > I recently purchased a Seagate 1.5 TB drive to attach to the Promise
 > > Fasttrak SATA 376 (PDC20376) controller on my Asus A7V8X motherboard.
 > > After installing the drive, I went into the FastTrak setup and
 > > configured a simple array which consisted only of this drive. At this
 > > point I noticed the FastTrak setup could not identify the drive's
 > > size, none the less it reported the array as functional upon reboot
 > > and showed what appeared to be the Cylinder/Sectors/Head count for the
 > > array. Next, I proceeded to install a rather recent copy of Kbuntu
 > > with kernel version 2.6.20. The Kbuntu installer found the array and
 > > installed without incident. However upon trying to boot into the newly
 > > installed copy of Linux, Grub stopped at stage 1.5 with an error code
 > > of 17. I've read that this error code is usually the result of Grub
 > > not being able to identify the type of file system or that Grub's
 > > drive mapping didn't match the one used by the bios. As I only have
 > > the one drive in the system, it seems unlikely that Grub was
 > > misconfigured.
 > >
 > > Upon having little success installing Linux, I attempted to install
 > > Windows XP to see if it's boot loader suffered from the same problem.
 > > To my surprise, the Windows boot loader also halted with an error. The
 > > error was "A drive read error has occurred. Please press Ctrl+Alt+Del
 > > to restart." As a result of both Linux and Windows failing to boot, I
 > > believe this problem may be a result of firmware/bios used for the
 > > on-board Promise SATA controller, which unfortunately is embedded in
 > > the system bios.
 > >
 > > Asus's technical support indicated that even if this is the case they
 > > will _not_ release an updated bios for this board. In any event, there
 > > are a few things I have yet to try. Like (1) trying the latest kernel
 > > version and sata_promise driver during install, (2) using a newer
 > > version of Grub, and (3) attempting to boot the drive using another
 > > SATA controller. If neither 1 nor 2 correct the issue and the drive
 > > operates fine under 3 then my only option is to update the
 > > firmware/bios for the on-board controller to see if it resolves the
 > > issue.
 > >
 > > The current firmware/bios version of the controller as reported by
 > > FastTrak is 1.00.0.21 which is provided with the latest Asus bios
 > > release for this motherboard. After a lot of searching I have been
 > > unable to find a firmware/bios revision newer than the one I currently
 > > have for this chip. However, I did see that Promise has a 1.00.0.37
 > > bios/firmware for their FastTrak S150 TX2plus card. This card uses
 > > their PDC20371 chip and the features it provides seem fairly similar
 > > to those of the PDC20376, but it's unknown if its firmware/bios would
 > > be compatible with the PDC20376.
 > >
 > > I'm therefore left wondering what differences exist between these two
 > > chips and whether or not using the firmware/bios for the PDC20371 with
 > > the PDC20376 could cause any major damage. Can anyone familiar with
 > > these chips foresee any issues or problems with doing something like
 > > this?
 > 
 > Since I put this out there, I felt it was important to follow-up on so
 > others could benefit from my experiences. After extensive testing, the
 > cause of the problems I've experienced are a result of a bug in the
 > Fasttrak bios for the Promise 376 controller. Specifically speaking,
 > bios interrupt 13h, AH=42 fails to read the requested sector from the
 > drive despite the fact that bios interrupt 13h, AH=41, BX=0x55AA
 > indicates the drive supports LBA extensions. The only known
 > work-around at this time is to limit the size of the primary boot
 > partition to 8GB or less and place it below the 8GB boundary where LBA
 > extensions are not required to read the drive. I have contacted
 > Promise concerning this issue and will provide more updates if
 > anything metabolizes. Until then any users experiencing similar issues
 > should use the work-around I've described above to boot the operating
 > system of their choice.

For booting with grub only /boot needs to be accessible by the BIOS,
so it's common to make /boot a separate partition early on the disk
with / and other partitions higher up.

This is the first I've heard of any Promise SATA controller having
such lame limitations.
