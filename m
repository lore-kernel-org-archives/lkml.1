Return-Path: <linux-kernel-owner+w=401wt.eu-S1756419AbYESCKj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756419AbYESCKj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 May 2008 22:10:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753211AbYESCK3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 May 2008 22:10:29 -0400
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:54924 "EHLO
	pd4mo2so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753160AbYESCK2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 May 2008 22:10:28 -0400
Date: Sun, 18 May 2008 20:08:18 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: SATA disk reports DRDY and goes to PIO0 eventually. noapic fixes it
In-reply-to: <fa.jF9ypkPPBXioKUr869XKpRZGAa4@ifi.uio.no>
To: Alessandro Suardi <alessandro.suardi@gmail.com>
Cc: Jeff Garzik <jgarzik@pobox.com>, LKML <linux-kernel@vger.kernel.org>
Message-id: <4830E112.9010602@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
References: <fa.jF9ypkPPBXioKUr869XKpRZGAa4@ifi.uio.no>
User-Agent: Thunderbird 2.0.0.14 (Windows/20080421)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alessandro Suardi wrote:
> Since some time I noticed my nephew's Fedora 8 box would have
>  some noise in /var/log/messages with timeouts reported by the
>  SATA layer, with the drive in DRDY state. Flux is like this (from
>  the base Fedora 9 kernel installed today):
> 
> May 17 17:18:39 rospo kernel: ata4.00: exception Emask 0x0 SAct 0x0
> SErr 0x0 action 0x2 frozen
> May 17 17:18:39 rospo kernel: ata4.00: cmd
> a0/00:00:00:08:00/00:00:00:00:00/a0 tag 0 pio 16392 in
> May 17 17:18:39 rospo kernel:          cdb 4a 01 00 00 10 00 00 00  08
> 00 00 00 00 00 00 00
> May 17 17:18:39 rospo kernel:          res
> 40/00:03:00:00:00/00:00:00:00:00/a0 Emask 0x4 (timeout)
> May 17 17:18:39 rospo kernel: ata4.00: status: { DRDY }
> May 17 17:18:39 rospo kernel: ata4: soft resetting link
> May 17 17:18:39 rospo kernel: ata4.00: configured for UDMA/33
> May 17 17:18:39 rospo kernel: ata4: EH complete
> May 17 17:18:40 rospo kernel: ALSA sound/usb/usbaudio.c:1353: setting
> usb interface 1:1
> May 17 17:18:40 rospo kernel: ALSA sound/usb/usbaudio.c:1353: setting
> usb interface 1:1
> May 17 17:18:46 rospo kernel: ata4.00: exception Emask 0x0 SAct 0x0
> SErr 0x0 action 0x2 frozen
> May 17 17:18:46 rospo kernel: ata4.00: cmd
> a0/00:00:00:08:00/00:00:00:00:00/a0 tag 0 pio 16392 in
> May 17 17:18:46 rospo kernel:          cdb 4a 01 00 00 10 00 00 00  08
> 00 00 00 00 00 00 00
> May 17 17:18:46 rospo kernel:          res
> 40/00:03:00:00:00/00:00:00:00:00/a0 Emask 0x4 (timeout)
> May 17 17:18:46 rospo kernel: ata4.00: status: { DRDY }
> May 17 17:18:46 rospo kernel: ata4: soft resetting link
> May 17 17:18:46 rospo kernel: ata4.00: configured for UDMA/33
> May 17 17:18:46 rospo kernel: ata4: EH complete
> May 17 17:18:53 rospo kernel: ata4.00: exception Emask 0x0 SAct 0x0
> SErr 0x0 action 0x2 frozen
> May 17 17:18:53 rospo kernel: ata4.00: cmd
> a0/00:00:00:08:00/00:00:00:00:00/a0 tag 0 pio 16392 in
> May 17 17:18:53 rospo kernel:          cdb 4a 01 00 00 10 00 00 00  08
> 00 00 00 00 00 00 00
> May 17 17:18:53 rospo kernel:          res
> 40/00:03:00:00:00/00:00:00:00:00/a0 Emask 0x4 (timeout)
> May 17 17:18:53 rospo kernel: ata4.00: status: { DRDY }
> May 17 17:18:53 rospo kernel: ata4: soft resetting link
> May 17 17:18:54 rospo kernel: ata4.00: configured for UDMA/33
> May 17 17:18:54 rospo kernel: ata4: EH complete
> May 17 17:19:01 rospo kernel: ata4.00: limiting speed to UDMA/25:PIO4
> May 17 17:19:01 rospo kernel: ata4.00: exception Emask 0x0 SAct 0x0
> SErr 0x0 action 0x2 frozen
> May 17 17:19:01 rospo kernel: ata4.00: cmd
> a0/00:00:00:08:00/00:00:00:00:00/a0 tag 0 pio 16392 in
> May 17 17:19:01 rospo kernel:          cdb 4a 01 00 00 10 00 00 00  08
> 00 00 00 00 00 00 00
> May 17 17:19:01 rospo kernel:          res
> 40/00:03:00:00:00/00:00:00:00:00/a0 Emask 0x4 (timeout)
> May 17 17:19:01 rospo kernel: ata4.00: status: { DRDY }
> May 17 17:19:01 rospo kernel: ata4: soft resetting link
> May 17 17:19:01 rospo kernel: ata4.00: configured for UDMA/25
> May 17 17:19:01 rospo kernel: ata4: EH complete
> May 17 17:19:01 rospo kernel: sr0: CDROM (ioctl) error, command: Get
> event status notification 4a 01 00 00 10 00 00 00 08 00
> May 17 17:19:01 rospo kernel: sr: Sense Key : Aborted Command
> [current] [descriptor]
> May 17 17:19:01 rospo kernel: sr: Add. Sense: No additional sense information
> May 17 17:19:06 rospo kernel: ALSA sound/usb/usbaudio.c:1353: setting
> usb interface 1:1
> May 17 17:19:06 rospo kernel: ALSA sound/usb/usbaudio.c:1353: setting
> usb interface 1:1
> May 17 17:19:11 rospo kernel: ata4.00: exception Emask 0x0 SAct 0x0
> SErr 0x0 action 0x2 frozen
> May 17 17:19:11 rospo kernel: ata4.00: cmd
> a0/00:00:00:00:00/00:00:00:00:00/a0 tag 0
> May 17 17:19:11 rospo kernel:          cdb 1e 00 00 00 00 00 00 00  00
> 00 00 00 00 00 00 00
> May 17 17:19:11 rospo kernel:          res
> 40/00:03:00:00:00/00:00:00:00:00/a0 Emask 0x4 (timeout)
> May 17 17:19:11 rospo kernel: ata4.00: status: { DRDY }
> May 17 17:19:11 rospo kernel: ata4: soft resetting link
> May 17 17:19:12 rospo kernel: ata4.00: configured for UDMA/25
> May 17 17:19:12 rospo kernel: ata4: EH complete
> May 17 17:19:22 rospo kernel: ata4.00: limiting speed to PIO4
> May 17 17:19:22 rospo kernel: ata4.00: exception Emask 0x0 SAct 0x0
> SErr 0x0 action 0x2 frozen
> May 17 17:19:22 rospo kernel: ata4.00: cmd
> a0/00:00:00:00:00/00:00:00:00:00/a0 tag 0
> May 17 17:19:22 rospo kernel:          cdb 1e 00 00 00 00 00 00 00  00
> 00 00 00 00 00 00 00
> May 17 17:19:22 rospo kernel:          res
> 40/00:03:00:00:00/00:00:00:00:00/a0 Emask 0x4 (timeout)
> May 17 17:19:22 rospo kernel: ata4.00: status: { DRDY }
> May 17 17:19:22 rospo kernel: ata4: soft resetting link
> May 17 17:19:22 rospo kernel: ata4.00: configured for PIO4
> May 17 17:19:22 rospo kernel: ata4: EH complete
> May 17 17:19:32 rospo kernel: ata4.00: limiting speed to PIO3
> May 17 17:19:32 rospo kernel: ata4.00: exception Emask 0x0 SAct 0x0
> SErr 0x0 action 0x2 frozen
> May 17 17:19:32 rospo kernel: ata4.00: cmd
> a0/00:00:00:00:00/00:00:00:00:00/a0 tag 0
> May 17 17:19:32 rospo kernel:          cdb 1e 00 00 00 00 00 00 00  00
> 00 00 00 00 00 00 00
> May 17 17:19:32 rospo kernel:          res
> 40/00:03:00:00:00/00:00:00:00:00/a0 Emask 0x4 (timeout)
> May 17 17:19:32 rospo kernel: ata4.00: status: { DRDY }
> May 17 17:19:32 rospo kernel: ata4: soft resetting link
> May 17 17:19:33 rospo kernel: ata4.00: configured for PIO3
> May 17 17:19:33 rospo kernel: ata4: EH complete
> May 17 17:19:43 rospo kernel: ata4.00: limiting speed to PIO0
> May 17 17:19:43 rospo kernel: ata4.00: exception Emask 0x0 SAct 0x0
> SErr 0x0 action 0x2 frozen
> May 17 17:19:43 rospo kernel: ata4.00: cmd
> a0/00:00:00:00:00/00:00:00:00:00/a0 tag 0
> May 17 17:19:43 rospo kernel:          cdb 1e 00 00 00 00 00 00 00  00
> 00 00 00 00 00 00 00
> May 17 17:19:43 rospo kernel:          res
> 40/00:03:00:00:00/00:00:00:00:00/a0 Emask 0x4 (timeout)
> May 17 17:19:43 rospo kernel: ata4.00: status: { DRDY }
> May 17 17:19:43 rospo kernel: ata4: soft resetting link
> May 17 17:19:43 rospo kernel: ata4.00: configured for PIO0
> May 17 17:19:43 rospo kernel: ata4: EH complete
> May 17 17:19:50 rospo kernel: ALSA sound/usb/usbaudio.c:1353: setting
> usb interface 1:1
> May 17 17:19:50 rospo kernel: ALSA sound/usb/usbaudio.c:1353: setting
> usb interface 1:1
> May 17 17:19:53 rospo kernel: ata4.00: exception Emask 0x0 SAct 0x0
> SErr 0x0 action 0x2 frozen
> May 17 17:19:53 rospo kernel: ata4.00: cmd
> a0/00:00:00:00:00/00:00:00:00:00/a0 tag 0
> May 17 17:19:53 rospo kernel:          cdb 1e 00 00 00 00 00 00 00  00
> 00 00 00 00 00 00 00
> May 17 17:19:53 rospo kernel:          res
> 40/00:03:00:00:00/00:00:00:00:00/a0 Emask 0x4 (timeout)
> May 17 17:19:53 rospo kernel: ata4.00: status: { DRDY }
> May 17 17:19:53 rospo kernel: ata4: soft resetting link
> May 17 17:19:54 rospo kernel: ata4.00: configured for PIO0
> May 17 17:19:54 rospo kernel: ata4: EH complete
> May 17 17:20:01 rospo kernel: ALSA sound/usb/usbaudio.c:1353: setting
> usb interface 1:1
> May 17 17:20:04 rospo kernel: ata4.00: exception Emask 0x0 SAct 0x0
> SErr 0x0 action 0x2 frozen
> May 17 17:20:04 rospo kernel: ata4.00: cmd
> a0/00:00:00:00:00/00:00:00:00:00/a0 tag 0
> May 17 17:20:04 rospo kernel:          cdb 1e 00 00 00 00 00 00 00  00
> 00 00 00 00 00 00 00
> May 17 17:20:04 rospo kernel:          res
> 40/00:03:00:00:00/00:00:00:00:00/a0 Emask 0x4 (timeout)
> May 17 17:20:04 rospo kernel: ata4.00: status: { DRDY }
> May 17 17:20:04 rospo kernel: ata4: soft resetting link
> May 17 17:20:04 rospo kernel: ata4.00: configured for PIO0
> May 17 17:20:04 rospo kernel: ata4: EH complete
> May 17 17:20:04 rospo kernel: sr 3:0:0:0: ioctl_internal_command
> return code = 8000002
> May 17 17:20:04 rospo kernel:    : Sense Key : Aborted Command
> [current] [descriptor]
> May 17 17:20:04 rospo kernel:    : Add. Sense: No additional sense information
> May 17 17:20:34 rospo kernel: ata4.00: exception Emask 0x0 SAct 0x0
> SErr 0x0 action 0x2 frozen
> May 17 17:20:34 rospo kernel: ata4.00: cmd
> a0/00:00:00:00:00/00:00:00:00:00/a0 tag 0
> May 17 17:20:34 rospo kernel:          cdb 00 00 00 00 00 00 00 00  00
> 00 00 00 00 00 00 00
> May 17 17:20:34 rospo kernel:          res
> 40/00:03:00:00:00/00:00:00:00:00/a0 Emask 0x4 (timeout)
> May 17 17:20:34 rospo kernel: ata4.00: status: { DRDY }
> May 17 17:20:34 rospo kernel: ata4: soft resetting link
> May 17 17:20:35 rospo kernel: ata4.00: configured for PIO0
> May 17 17:20:35 rospo kernel: ata4: EH complete
> 
> ..and on and on and on.
> 
> Reading another report on lkml I turned to the ATA wiki @ kernel.org
>  today, as even the newest Fedora 9 update (2.6.25.3-18) was still
>  behaving the same way - pci=nomsi wasn't useful, acpi=off was
>  also not useful, noapic did instead get rid of the messages, even
>  under 'find /' (which would usually turn up the ATA resets in less
>  than 10 seconds).
> 
> Is there anything more useful than simply booting noapic that
>  can be done here, or is that it ?

Please post the full dmesg output from bootup. We can't see what 
controller type this is, etc.
