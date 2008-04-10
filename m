Return-Path: <linux-kernel-owner+w=401wt.eu-S1755907AbYDJMXl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755907AbYDJMXl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2008 08:23:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756756AbYDJMXZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Apr 2008 08:23:25 -0400
Received: from spirit.analogic.com ([204.178.40.4]:1571 "EHLO
	spirit.analogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756332AbYDJMXY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2008 08:23:24 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-MimeOLE: Produced By Microsoft Exchange V6.5
X-OriginalArrivalTime: 10 Apr 2008 12:22:49.0001 (UTC) FILETIME=[96F79990:01C89B05]
Content-class: urn:content-classes:message
Subject: Re: Disk geometry from /sys
Date: Thu, 10 Apr 2008 08:22:48 -0400
Message-ID: <Pine.LNX.4.61.0804100804260.25651@chaos.analogic.com>
In-Reply-To: <38b2ab8a0804091353h3725ce29s196e27e8b4f1ff56@mail.gmail.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: Disk geometry from /sys
thread-index: AcibBZb+NbjHpIipR1e3YsfvNHaz/g==
References: <38b2ab8a0804091353h3725ce29s196e27e8b4f1ff56@mail.gmail.com>
From: "linux-os (Dick Johnson)" <linux-os@analogic.com>
To: "Francis Moreau" <francis.moro@gmail.com>
Cc: <linux-kernel@vger.kernel.org>
Reply-To: "linux-os (Dick Johnson)" <linux-os@analogic.com>
X-TM-AS-Product-Ver: SMEX-8.0.0.1259-5.000.1023-15840.007
X-TM-AS-Result: No--14.897000-8.000000-31
X-TM-AS-User-Approved-Sender: No
X-TM-AS-User-Blocked-Sender: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 9 Apr 2008, Francis Moreau wrote:

> Hi,
>
> I'm trying to know the geometry of my hard disk from a bash script
> and that's the reason I'm looking in /sys. The reason is that I'd like
> to figure out the size of a cylinder without doing a
> ioctl(bdev, HDIO_GETGEO, &geo)
>
> Unfortunately I can't find anything useful and this is certainly a sign
> that I'm doing something wrong.
>
> Or maybe can I simply assume from my script that the geometry
> is always heads=255 and the number of sectors per track is 63 for all
> disks.
>
> Looking at parted(8) source code, I  can find this:
>
> /* The GETGEO ioctl is no longer useful (as of linux 2.6.x).  We could
> * still use it in 2.4.x, but this is contentious.  Perhaps we should
> * move to EDD. */
>
> Could anybody give me some advices ?
> -- 
> Francis
> --

It becomes, as you say contentious, because with disk drives
manufactured during the past ten or so years, anything about
the physical geometry is fictitious. The PC BIOS continues to
calculate C/H/S because that's what BIOS interrupt 0x13 uses
to boot the machine. The boot code needs to know what the
BIOS claims or else it may fail to boot. However, once Linux
is up, there are no C/H/S unless they were invented --and
hopefully, the same as what the BIOS claims.

In the BIOS interrupt 0x13 code, the maximum number of heads
that will fit in the register is 255. The maximum number of
sectors that will fit in the partial register scheme is 63.
That leaves the cylinders as the only remaining variable for
large media. However, the BIOS only needs to boot the machine.
There may be many more cylinders than your initial guess and
the BIOS can only use 10 bits of the cylinder number. If you
are writing boot code, perhaps making the next GRUB or whatever
then you can use the numbers you suggested. However if not, you
have no need to learn the actual disk geometry and it is not
even shown in many disk-drive data sheets because the number
of sectors on the outside tracks is now greater than the ones
on the inside tracks to maintain the same areal bit density and
maximize the storage capacity.

Cheers,
Dick Johnson
Penguin : Linux version 2.6.22.1 on an i686 machine (5588.28 BogoMips).
My book : http://www.AbominableFirebug.com/
_


****************************************************************
The information transmitted in this message is confidential and may be privileged.  Any review, retransmission, dissemination, or other use of this information by persons or entities other than the intended recipient is prohibited.  If you are not the intended recipient, please notify Analogic Corporation immediately - by replying to this message or by sending an email to DeliveryErrors@analogic.com - and destroy all copies of this information, including any attachments, without reading or disclosing them.

Thank you.
