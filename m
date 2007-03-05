Return-Path: <linux-kernel-owner+w=401wt.eu-S1752615AbXCEDxE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752615AbXCEDxE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Mar 2007 22:53:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752618AbXCEDxE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Mar 2007 22:53:04 -0500
Received: from smtp.bulldogdsl.com ([212.158.248.8]:4886 "EHLO
	mcr-smtp-002.bulldogdsl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752615AbXCEDxB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Mar 2007 22:53:01 -0500
X-Spam-Abuse: Please report all spam/abuse matters to abuse@bulldogdsl.com
From: Alistair John Strachan <s0348365@sms.ed.ac.uk>
To: Robert Hancock <hancockr@shaw.ca>
Subject: Re: CK804 SATA Errors (still got them)
Date: Mon, 5 Mar 2007 03:52:56 +0000
User-Agent: KMail/1.9.5
Cc: Jeff Garzik <jeff@garzik.org>, linux-kernel@vger.kernel.org
References: <200703011339.52895.s0348365@sms.ed.ac.uk> <200703021547.09121.s0348365@sms.ed.ac.uk> <45EB555C.9050606@shaw.ca>
In-Reply-To: <45EB555C.9050606@shaw.ca>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703050352.56451.s0348365@sms.ed.ac.uk>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 04 March 2007 23:25, Robert Hancock wrote:
> Alistair John Strachan wrote:
> >> Can you try reverting commit 721449bf0d51213fe3abf0ac3e3561ef9ea7827a
> >> (link below) and see what effect that has?
> >>
> >> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commi
> >>t;h =721449bf0d51213fe3abf0ac3e3561ef9ea7827a
> >
> > Obviously, I'll let you know if it happens again, but I've reverted this
> > commit and transferred 22.5GB over 45 minutes onto a RAID5 with 4 HDs on
> > an NVIDIA sata controller, and this error hasn't appeared.
> >
> > So I'm inclined to (very unscientifically) say that this brings it back
> > to 2.6.20's level of stability.
>
> Interesting. Can you try un-reverting that patch, and applying this one?
>
> The reading of the status register is something that was part of the
> original NVidia code, which I'm not really sure why is there. Given that
> reading the status register clears the drive's interrupt status, that might
> be causing some wierd interaction with the ADMA controller. Also, I added
> in a printk for cases where notifiers are triggered but the command doesn't
> indicate completion - if you still get problems, let me know if you see
> that message.

Didn't take long to observe the problem again, so I'm guessing that this isn't
it. I was definitely using a kernel compiled with your patch:

alistair@damocles:~$ uname -v
#1 SMP Sun Mar 4 23:39:56 GMT 2007

I got the following in dmesg:

ata1: EH in ADMA mode, notifier 0x0 notifier_error 0x0 gen_ctl 0x1501000 status 0x500 next cpb count 0x0 next cpb idx 0x0
ata1: CPB 0: ctl_flags 0xd, resp_flags 0x1
ata1.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2 frozen
ata1.00: cmd c8/00:08:37:77:61/00:00:00:00:00/e0 tag 0 cdb 0x0 data 4096 in
         res 40/00:00:01:4f:c2/00:00:00:00:00/00 Emask 0x4 (timeout)
ata1: soft resetting port
ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
ata1.00: configured for UDMA/133
ata1: EH complete
SCSI device sda: 488397168 512-byte hdwr sectors (250059 MB)
sda: Write Protect is off
sda: Mode Sense: 00 3a 00 00
SCSI device sda: write cache: enabled, read cache: enabled, doesn't support DPO or FUA

Your debugging message did not appear in dmesg, however.

-- 
Cheers,
Alistair.

Final year Computer Science undergraduate.
1F2 55 South Clerk Street, Edinburgh, UK.
