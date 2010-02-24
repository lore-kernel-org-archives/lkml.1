Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758174Ab0BXVW3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Feb 2010 16:22:29 -0500
Received: from mail1-out1.atlantis.sk ([80.94.52.55]:42530 "EHLO
	mail.atlantis.sk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758157Ab0BXVW1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Feb 2010 16:22:27 -0500
From: Ondrej Zary <linux@rainbow-software.org>
To: Matthew Dharm <mdharm-kernel@one-eyed-alien.net>
Subject: Re: [usb-storage] [PATCH] [resend] unusual_devs.h: Fix capacity for SL11R-IDE 2.6c
Date: Wed, 24 Feb 2010 22:22:18 +0100
User-Agent: KMail/1.9.10
Cc: phil@ipom.com, usb-storage@lists.one-eyed-alien.net,
       linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
References: <201002241141.10103.linux@rainbow-software.org> <20100224192959.GJ20232@one-eyed-alien.net>
In-Reply-To: <20100224192959.GJ20232@one-eyed-alien.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201002242222.21008.linux@rainbow-software.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 24 February 2010 20:29:59 Matthew Dharm wrote:
> On Wed, Feb 24, 2010 at 11:41:08AM +0100, Ondrej Zary wrote:
> > SL11R-IDE 2.6c (at least) reports wrong capacity (one sector more).
> > Reading that last sector causes the device not to work anymore (and looks
> > like HAL or something does that automatically after plugging in):
> > sd 5:0:0:0: [sdc] Device not ready
> > sd 5:0:0:0: [sdc] Result: hostbyte=0x00 driverbyte=0x08
> > sd 5:0:0:0: [sdc] Sense Key : 0x2 [current]
> > sd 5:0:0:0: [sdc] ASC=0x0 ASCQ=0x0
> > sd 5:0:0:0: [sdc] CDB: cdb[0]=0x28: 28 00 04 a8 b5 70 00 00 01 00
> >
> > Add unusual_devs entry to fix the capacity.
>
> Why not just adjust the version range of the entry above where you added a
> new one?

Because that entry fixes IDENTIFY. My version does not seem to have any 
problems with IDENTIFY. Or maybe it has but kernel can now handle it 
automatically:
usb 1-1: new full speed USB device using uhci_hcd and address 4
usb 1-1: configuration #1 chosen from 1 choice
scsi5 : SCSI emulation for USB Mass Storage devices
usb-storage: device found at 4
usb-storage: waiting for device to settle before scanning
scsi scan: INQUIRY result too short (5), using 36
scsi 5:0:0:0: Direct-Access     WDC WD40 0BB-00AUA1       18.2 PQ: 0 ANSI: 1
sd 5:0:0:0: Attached scsi generic sg3 type 0


> If you just expand the upper version of the previous entry, it should cover
> both devices.
>
> Matt



-- 
Ondrej Zary
