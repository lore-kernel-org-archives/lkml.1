Return-Path: <linux-kernel-owner+w=401wt.eu-S1762838AbYESTvG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762838AbYESTvG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 15:51:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756914AbYESTuv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 15:50:51 -0400
Received: from fg-out-1718.google.com ([72.14.220.155]:44238 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759330AbYESTuu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 15:50:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:references;
        b=lKoQizhGjH0JzXXNqAZG5PIgPVDxH/oqyMDc6nJcanfHpzjYJg8lu28Ue0XLgyALD6vKTcxjVOxeh6tkbNIH1H/j/gDZh7u+XZUwk8ewltF8nAW5xRsuGKMyFr3UCsZCU0phORcnvCl0GbwU/+Tp3cxleB/t6u+pxJ/OQP35yQI=
Message-ID: <5a4c581d0805191250r5d2ecd30x15e6bc6faafcb587@mail.gmail.com>
Date: Mon, 19 May 2008 21:50:47 +0200
From: "Alessandro Suardi" <alessandro.suardi@gmail.com>
To: "Robert Hancock" <hancockr@shaw.ca>
Subject: Re: SATA disk reports DRDY and goes to PIO0 eventually. noapic fixes it
Cc: "Jeff Garzik" <jgarzik@pobox.com>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <4830E112.9010602@shaw.ca>
MIME-Version: 1.0
Content-Type: multipart/mixed; 
	boundary="----=_Part_17264_8108522.1211226647740"
References: <fa.jF9ypkPPBXioKUr869XKpRZGAa4@ifi.uio.no>
	 <4830E112.9010602@shaw.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

------=_Part_17264_8108522.1211226647740
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Mon, May 19, 2008 at 4:08 AM, Robert Hancock <hancockr@shaw.ca> wrote:
> Alessandro Suardi wrote:
>>
>> Since some time I noticed my nephew's Fedora 8 box would have
>>  some noise in /var/log/messages with timeouts reported by the
>>  SATA layer, with the drive in DRDY state. Flux is like this (from
>>  the base Fedora 9 kernel installed today):
>>
>> May 17 17:18:39 rospo kernel: ata4.00: exception Emask 0x0 SAct 0x0
>> SErr 0x0 action 0x2 frozen
>> May 17 17:18:39 rospo kernel: ata4.00: cmd
>> a0/00:00:00:08:00/00:00:00:00:00/a0 tag 0 pio 16392 in
>> May 17 17:18:39 rospo kernel:          cdb 4a 01 00 00 10 00 00 00  08
>> 00 00 00 00 00 00 00
>> May 17 17:18:39 rospo kernel:          res
>> 40/00:03:00:00:00/00:00:00:00:00/a0 Emask 0x4 (timeout)
>> May 17 17:18:39 rospo kernel: ata4.00: status: { DRDY }
>> May 17 17:18:39 rospo kernel: ata4: soft resetting link
>> May 17 17:18:39 rospo kernel: ata4.00: configured for UDMA/33
>> May 17 17:18:39 rospo kernel: ata4: EH complete
>> May 17 17:18:40 rospo kernel: ALSA sound/usb/usbaudio.c:1353: setting
>> usb interface 1:1
>> May 17 17:18:40 rospo kernel: ALSA sound/usb/usbaudio.c:1353: setting
>> usb interface 1:1
>> May 17 17:18:46 rospo kernel: ata4.00: exception Emask 0x0 SAct 0x0
>> SErr 0x0 action 0x2 frozen
>> May 17 17:18:46 rospo kernel: ata4.00: cmd
>> a0/00:00:00:08:00/00:00:00:00:00/a0 tag 0 pio 16392 in
>> May 17 17:18:46 rospo kernel:          cdb 4a 01 00 00 10 00 00 00  08
>> 00 00 00 00 00 00 00
>> May 17 17:18:46 rospo kernel:          res
>> 40/00:03:00:00:00/00:00:00:00:00/a0 Emask 0x4 (timeout)
>> May 17 17:18:46 rospo kernel: ata4.00: status: { DRDY }
>> May 17 17:18:46 rospo kernel: ata4: soft resetting link
>> May 17 17:18:46 rospo kernel: ata4.00: configured for UDMA/33
>> May 17 17:18:46 rospo kernel: ata4: EH complete
>> May 17 17:18:53 rospo kernel: ata4.00: exception Emask 0x0 SAct 0x0
>> SErr 0x0 action 0x2 frozen
>> May 17 17:18:53 rospo kernel: ata4.00: cmd
>> a0/00:00:00:08:00/00:00:00:00:00/a0 tag 0 pio 16392 in
>> May 17 17:18:53 rospo kernel:          cdb 4a 01 00 00 10 00 00 00  08
>> 00 00 00 00 00 00 00
>> May 17 17:18:53 rospo kernel:          res
>> 40/00:03:00:00:00/00:00:00:00:00/a0 Emask 0x4 (timeout)
>> May 17 17:18:53 rospo kernel: ata4.00: status: { DRDY }
>> May 17 17:18:53 rospo kernel: ata4: soft resetting link
>> May 17 17:18:54 rospo kernel: ata4.00: configured for UDMA/33
>> May 17 17:18:54 rospo kernel: ata4: EH complete
>> May 17 17:19:01 rospo kernel: ata4.00: limiting speed to UDMA/25:PIO4
>> May 17 17:19:01 rospo kernel: ata4.00: exception Emask 0x0 SAct 0x0
>> SErr 0x0 action 0x2 frozen
>> May 17 17:19:01 rospo kernel: ata4.00: cmd
>> a0/00:00:00:08:00/00:00:00:00:00/a0 tag 0 pio 16392 in
>> May 17 17:19:01 rospo kernel:          cdb 4a 01 00 00 10 00 00 00  08
>> 00 00 00 00 00 00 00
>> May 17 17:19:01 rospo kernel:          res
>> 40/00:03:00:00:00/00:00:00:00:00/a0 Emask 0x4 (timeout)
>> May 17 17:19:01 rospo kernel: ata4.00: status: { DRDY }
>> May 17 17:19:01 rospo kernel: ata4: soft resetting link
>> May 17 17:19:01 rospo kernel: ata4.00: configured for UDMA/25
>> May 17 17:19:01 rospo kernel: ata4: EH complete
>> May 17 17:19:01 rospo kernel: sr0: CDROM (ioctl) error, command: Get
>> event status notification 4a 01 00 00 10 00 00 00 08 00
>> May 17 17:19:01 rospo kernel: sr: Sense Key : Aborted Command
>> [current] [descriptor]
>> May 17 17:19:01 rospo kernel: sr: Add. Sense: No additional sense
>> information
>> May 17 17:19:06 rospo kernel: ALSA sound/usb/usbaudio.c:1353: setting
>> usb interface 1:1
>> May 17 17:19:06 rospo kernel: ALSA sound/usb/usbaudio.c:1353: setting
>> usb interface 1:1
>> May 17 17:19:11 rospo kernel: ata4.00: exception Emask 0x0 SAct 0x0
>> SErr 0x0 action 0x2 frozen
>> May 17 17:19:11 rospo kernel: ata4.00: cmd
>> a0/00:00:00:00:00/00:00:00:00:00/a0 tag 0
>> May 17 17:19:11 rospo kernel:          cdb 1e 00 00 00 00 00 00 00  00
>> 00 00 00 00 00 00 00
>> May 17 17:19:11 rospo kernel:          res
>> 40/00:03:00:00:00/00:00:00:00:00/a0 Emask 0x4 (timeout)
>> May 17 17:19:11 rospo kernel: ata4.00: status: { DRDY }
>> May 17 17:19:11 rospo kernel: ata4: soft resetting link
>> May 17 17:19:12 rospo kernel: ata4.00: configured for UDMA/25
>> May 17 17:19:12 rospo kernel: ata4: EH complete
>> May 17 17:19:22 rospo kernel: ata4.00: limiting speed to PIO4
>> May 17 17:19:22 rospo kernel: ata4.00: exception Emask 0x0 SAct 0x0
>> SErr 0x0 action 0x2 frozen
>> May 17 17:19:22 rospo kernel: ata4.00: cmd
>> a0/00:00:00:00:00/00:00:00:00:00/a0 tag 0
>> May 17 17:19:22 rospo kernel:          cdb 1e 00 00 00 00 00 00 00  00
>> 00 00 00 00 00 00 00
>> May 17 17:19:22 rospo kernel:          res
>> 40/00:03:00:00:00/00:00:00:00:00/a0 Emask 0x4 (timeout)
>> May 17 17:19:22 rospo kernel: ata4.00: status: { DRDY }
>> May 17 17:19:22 rospo kernel: ata4: soft resetting link
>> May 17 17:19:22 rospo kernel: ata4.00: configured for PIO4
>> May 17 17:19:22 rospo kernel: ata4: EH complete
>> May 17 17:19:32 rospo kernel: ata4.00: limiting speed to PIO3
>> May 17 17:19:32 rospo kernel: ata4.00: exception Emask 0x0 SAct 0x0
>> SErr 0x0 action 0x2 frozen
>> May 17 17:19:32 rospo kernel: ata4.00: cmd
>> a0/00:00:00:00:00/00:00:00:00:00/a0 tag 0
>> May 17 17:19:32 rospo kernel:          cdb 1e 00 00 00 00 00 00 00  00
>> 00 00 00 00 00 00 00
>> May 17 17:19:32 rospo kernel:          res
>> 40/00:03:00:00:00/00:00:00:00:00/a0 Emask 0x4 (timeout)
>> May 17 17:19:32 rospo kernel: ata4.00: status: { DRDY }
>> May 17 17:19:32 rospo kernel: ata4: soft resetting link
>> May 17 17:19:33 rospo kernel: ata4.00: configured for PIO3
>> May 17 17:19:33 rospo kernel: ata4: EH complete
>> May 17 17:19:43 rospo kernel: ata4.00: limiting speed to PIO0
>> May 17 17:19:43 rospo kernel: ata4.00: exception Emask 0x0 SAct 0x0
>> SErr 0x0 action 0x2 frozen
>> May 17 17:19:43 rospo kernel: ata4.00: cmd
>> a0/00:00:00:00:00/00:00:00:00:00/a0 tag 0
>> May 17 17:19:43 rospo kernel:          cdb 1e 00 00 00 00 00 00 00  00
>> 00 00 00 00 00 00 00
>> May 17 17:19:43 rospo kernel:          res
>> 40/00:03:00:00:00/00:00:00:00:00/a0 Emask 0x4 (timeout)
>> May 17 17:19:43 rospo kernel: ata4.00: status: { DRDY }
>> May 17 17:19:43 rospo kernel: ata4: soft resetting link
>> May 17 17:19:43 rospo kernel: ata4.00: configured for PIO0
>> May 17 17:19:43 rospo kernel: ata4: EH complete
>> May 17 17:19:50 rospo kernel: ALSA sound/usb/usbaudio.c:1353: setting
>> usb interface 1:1
>> May 17 17:19:50 rospo kernel: ALSA sound/usb/usbaudio.c:1353: setting
>> usb interface 1:1
>> May 17 17:19:53 rospo kernel: ata4.00: exception Emask 0x0 SAct 0x0
>> SErr 0x0 action 0x2 frozen
>> May 17 17:19:53 rospo kernel: ata4.00: cmd
>> a0/00:00:00:00:00/00:00:00:00:00/a0 tag 0
>> May 17 17:19:53 rospo kernel:          cdb 1e 00 00 00 00 00 00 00  00
>> 00 00 00 00 00 00 00
>> May 17 17:19:53 rospo kernel:          res
>> 40/00:03:00:00:00/00:00:00:00:00/a0 Emask 0x4 (timeout)
>> May 17 17:19:53 rospo kernel: ata4.00: status: { DRDY }
>> May 17 17:19:53 rospo kernel: ata4: soft resetting link
>> May 17 17:19:54 rospo kernel: ata4.00: configured for PIO0
>> May 17 17:19:54 rospo kernel: ata4: EH complete
>> May 17 17:20:01 rospo kernel: ALSA sound/usb/usbaudio.c:1353: setting
>> usb interface 1:1
>> May 17 17:20:04 rospo kernel: ata4.00: exception Emask 0x0 SAct 0x0
>> SErr 0x0 action 0x2 frozen
>> May 17 17:20:04 rospo kernel: ata4.00: cmd
>> a0/00:00:00:00:00/00:00:00:00:00/a0 tag 0
>> May 17 17:20:04 rospo kernel:          cdb 1e 00 00 00 00 00 00 00  00
>> 00 00 00 00 00 00 00
>> May 17 17:20:04 rospo kernel:          res
>> 40/00:03:00:00:00/00:00:00:00:00/a0 Emask 0x4 (timeout)
>> May 17 17:20:04 rospo kernel: ata4.00: status: { DRDY }
>> May 17 17:20:04 rospo kernel: ata4: soft resetting link
>> May 17 17:20:04 rospo kernel: ata4.00: configured for PIO0
>> May 17 17:20:04 rospo kernel: ata4: EH complete
>> May 17 17:20:04 rospo kernel: sr 3:0:0:0: ioctl_internal_command
>> return code = 8000002
>> May 17 17:20:04 rospo kernel:    : Sense Key : Aborted Command
>> [current] [descriptor]
>> May 17 17:20:04 rospo kernel:    : Add. Sense: No additional sense
>> information
>> May 17 17:20:34 rospo kernel: ata4.00: exception Emask 0x0 SAct 0x0
>> SErr 0x0 action 0x2 frozen
>> May 17 17:20:34 rospo kernel: ata4.00: cmd
>> a0/00:00:00:00:00/00:00:00:00:00/a0 tag 0
>> May 17 17:20:34 rospo kernel:          cdb 00 00 00 00 00 00 00 00  00
>> 00 00 00 00 00 00 00
>> May 17 17:20:34 rospo kernel:          res
>> 40/00:03:00:00:00/00:00:00:00:00/a0 Emask 0x4 (timeout)
>> May 17 17:20:34 rospo kernel: ata4.00: status: { DRDY }
>> May 17 17:20:34 rospo kernel: ata4: soft resetting link
>> May 17 17:20:35 rospo kernel: ata4.00: configured for PIO0
>> May 17 17:20:35 rospo kernel: ata4: EH complete
>>
>> ..and on and on and on.
>>
>> Reading another report on lkml I turned to the ATA wiki @ kernel.org
>>  today, as even the newest Fedora 9 update (2.6.25.3-18) was still
>>  behaving the same way - pci=nomsi wasn't useful, acpi=off was
>>  also not useful, noapic did instead get rid of the messages, even
>>  under 'find /' (which would usually turn up the ATA resets in less
>>  than 10 seconds).
>>
>> Is there anything more useful than simply booting noapic that
>>  can be done here, or is that it ?
>
> Please post the full dmesg output from bootup. We can't see what controller
> type this is, etc.

Robert,

  thanks for replying. Of course now that I look a bit more into
  the messages file, I notice that ATA 4.00 is the DVD drive,
  not the disk <blush>

Funny as there is nothing in the DVD drive... oh well.

/var/log/messages attached as a .gz file since I'm not sure it's
 small enough to avoid being bounced by vger.

thanks a lot,

--alessandro

 "Give me love / Or give me hate
 Give me anything that's not just ok"

 (Sophia, 'Weightless')

------=_Part_17264_8108522.1211226647740
Content-Type: application/x-gzip; name=messages.gz
Content-Transfer-Encoding: base64
X-Attachment-Id: f_fgfh1vu60
Content-Disposition: attachment; filename=messages.gz

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
------=_Part_17264_8108522.1211226647740--
