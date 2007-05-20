Return-Path: <linux-kernel-owner+w=401wt.eu-S1759573AbXETVN2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759573AbXETVN2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 May 2007 17:13:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756570AbXETVNW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 May 2007 17:13:22 -0400
Received: from ug-out-1314.google.com ([66.249.92.168]:52561 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756548AbXETVNV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 May 2007 17:13:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=o7J98sy6TZQZZDDDRJ37thkFsljDuNygUnqEQNAXLov1TsO7+CQFHIMCI1osGMa5BwuzQwptEv7/RK6oFFnP1YeeM0qT8BVqgv5SfM7MT7+vinpyFw28YLfR/28OA8RGF5RpaBVH8Z3Vdc0yGZsG+JVWcIIQwS1VGPBH7qe8h5o=
Message-ID: <4650B9E3.7070409@gmail.com>
Date: Sun, 20 May 2007 23:13:07 +0200
From: Robert de Rooy <robert.de.rooy@gmail.com>
User-Agent: Thunderbird 2.0.0.0 (Windows/20070326)
MIME-Version: 1.0
To: Tejun Heo <htejun@gmail.com>
CC: linux-kernel@vger.kernel.org, alan@redhat.com, bzolnier@gmail.com,
       jgarzik@pobox.com
Subject: Re: libata and legacy ide pcmcia failure
References: <464A0321.3080201@gmail.com> <464C1575.8070005@gmail.com> <464CB7C9.2080807@gmail.com> <46503192.1040300@gmail.com>
In-Reply-To: <46503192.1040300@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks for looking into this!

I tried the patches on 2.6.22rc1-git5. The second patch unfortunately 
did not resolve the issue, although it seems to get a bit further. Here 
are the logs.

** 2.6.22rc1-git5 + timing-debug.patch
May 20 22:40:49 localhost kernel: pccard: PCMCIA card inserted into slot 0
May 20 22:40:49 localhost kernel: cs: memory probe 
0xe8000000-0xefffffff: excluding 0xe8000000-0xefffffff
May 20 22:40:49 localhost kernel: cs: memory probe 
0xc0200000-0xcfffffff: excluding 0xc0200000-0xc11fffff 
0xc1a00000-0xc21fffff 0xc2a00000-0xc31fffff 0xc3a00000-0xcc1fffff 
0xcca00000-0xcd1fffff 0xcda00000-0xce1fffff 0xcea00000-0xcf1fffff 
0xcfa00000-0xd01fffff
May 20 22:40:49 localhost kernel: pcmcia: registering new device pcmcia0.0
May 20 22:40:49 localhost kernel: scsi3 : pata_pcmcia
May 20 22:40:49 localhost kernel: ata3: PATA max PIO0 cmd 0x00014100 ctl 
0x0001410e bmdma 0x00000000 irq 0
May 20 22:40:49 localhost kernel: ata3: soft resetting port
May 20 22:40:49 localhost kernel: ata3: reset complete
May 20 22:40:49 localhost kernel: ata3.00: issuing IDENTIFY
May 20 22:40:49 localhost kernel: ata3.00: IDENTIFY complete
May 20 22:40:49 localhost kernel: ata3.00: issuing DEV_INIT_PARAMS
May 20 22:41:19 localhost kernel: ata3.00: qc timeout (cmd 0x91)
May 20 22:41:19 localhost kernel: ata3.00: DEV_INIT_PARAMS complete
May 20 22:41:19 localhost kernel: ata3.00: failed to IDENTIFY 
(INIT_DEV_PARAMS failed, err_mask=0x4)
May 20 22:41:20 localhost kernel: ata3: soft resetting port
May 20 22:41:30 localhost kernel: ata3: SRST failed (errno=-16)
May 20 22:41:30 localhost kernel: ata3: soft resetting port
May 20 22:41:30 localhost kernel: ata3: reset complete
May 20 22:41:30 localhost kernel: ATA: abnormal status 0xB5 on port 
0x00014107
May 20 22:41:30 localhost kernel: ATA: abnormal status 0xB5 on port 
0x00014107
May 20 22:41:30 localhost kernel: ata3.00: issuing IDENTIFY
May 20 22:41:30 localhost kernel: ata3.00: IDENTIFY complete
May 20 22:41:30 localhost kernel: ata3.00: issuing DEV_INIT_PARAMS
May 20 22:42:00 localhost kernel: ata3.00: qc timeout (cmd 0x91)
May 20 22:42:00 localhost kernel: ata3.00: DEV_INIT_PARAMS complete
May 20 22:42:00 localhost kernel: ata3.00: failed to IDENTIFY 
(INIT_DEV_PARAMS failed, err_mask=0x4)
May 20 22:42:00 localhost kernel: ata3.00: limiting speed to UDMA7:PIO5
May 20 22:42:01 localhost kernel: ata3: soft resetting port
May 20 22:42:01 localhost kernel: ata3: reset complete
May 20 22:42:01 localhost kernel: ata3.00: issuing IDENTIFY
May 20 22:42:01 localhost kernel: ata3.00: IDENTIFY complete
May 20 22:42:01 localhost kernel: ata3.00: issuing DEV_INIT_PARAMS
May 20 22:42:31 localhost kernel: ata3.00: qc timeout (cmd 0x91)
May 20 22:42:31 localhost kernel: ata3.00: DEV_INIT_PARAMS complete
May 20 22:42:31 localhost kernel: ata3.00: failed to IDENTIFY 
(INIT_DEV_PARAMS failed, err_mask=0x4)
May 20 22:42:31 localhost kernel: ata3: soft resetting port
May 20 22:42:31 localhost kernel: ata3: reset complete
May 20 22:42:31 localhost kernel: ata3: EH complete
May 20 22:42:32 localhost udevd-event[2541]: udev_rules_apply_format: 
unknown format variable '$modalias'

** 2.6.22rc1-git5 + timing-debug.patch + disable-dev_init_params.patch
May 20 23:02:25 localhost kernel: pccard: PCMCIA card inserted into slot 0
May 20 23:02:25 localhost kernel: cs: memory probe 
0xe8000000-0xefffffff: excluding 0xe8000000-0xefffffff
May 20 23:02:25 localhost kernel: cs: memory probe 
0xc0200000-0xcfffffff: excluding 0xc0200000-0xc11fffff 
0xc1a00000-0xc21fffff 0xc2a00000-0xc31fffff 0xc3a00000-0xcc1fffff 
0xcca00000-0xcd1fffff 0xcda00000-0xce1fffff 0xcea00000-0xcf1fffff 
0xcfa00000-0xd01fffff
May 20 23:02:25 localhost kernel: pcmcia: registering new device pcmcia0.0
May 20 23:02:25 localhost kernel: scsi3 : pata_pcmcia
May 20 23:02:25 localhost kernel: ata3: PATA max PIO0 cmd 0x00014100 ctl 
0x0001410e bmdma 0x00000000 irq 0
May 20 23:02:25 localhost kernel: ata3: soft resetting port
May 20 23:02:25 localhost kernel: ata3: reset complete
May 20 23:02:25 localhost kernel: ata3.00: issuing IDENTIFY
May 20 23:02:26 localhost kernel: ata3.00: IDENTIFY complete
May 20 23:02:26 localhost kernel: ata3.00: CFA: Memory Card Adapter, 
20011212, max PIO1
May 20 23:02:26 localhost kernel: ata3.00: 253696 sectors, multi 0: LBA
May 20 23:02:56 localhost kernel: ata3.00: qc timeout (cmd 0xef)
May 20 23:02:56 localhost kernel: ata3.00: failed to set xfermode 
(err_mask=0x4)
May 20 23:02:56 localhost kernel: ata3: failed to recover some devices, 
retrying in 5 secs
May 20 23:03:01 localhost kernel: ata3: soft resetting port
May 20 23:03:11 localhost kernel: ata3: SRST failed (errno=-16)
May 20 23:03:11 localhost kernel: ata3: soft resetting port
May 20 23:03:11 localhost kernel: ata3: reset complete
May 20 23:03:11 localhost kernel: ata3.00: issuing IDENTIFY
May 20 23:03:11 localhost kernel: ata3.00: IDENTIFY complete
May 20 23:03:41 localhost kernel: ata3.00: qc timeout (cmd 0xef)
May 20 23:03:41 localhost kernel: ata3.00: failed to set xfermode 
(err_mask=0x4)
May 20 23:03:41 localhost kernel: ata3: failed to recover some devices, 
retrying in 5 secs
May 20 23:03:46 localhost kernel: ata3: soft resetting port
May 20 23:03:46 localhost kernel: ata3: reset complete
May 20 23:03:46 localhost kernel: ata3.00: issuing IDENTIFY
May 20 23:03:46 localhost kernel: ata3.00: IDENTIFY complete
May 20 23:04:16 localhost kernel: ata3.00: qc timeout (cmd 0xef)
May 20 23:04:16 localhost kernel: ata3.00: failed to set xfermode 
(err_mask=0x4)
May 20 23:04:16 localhost kernel: ata3.00: disabled
May 20 23:04:17 localhost kernel: ata3: EH complete
May 20 23:04:17 localhost udevd-event[2524]: udev_rules_apply_format: 
unknown format variable '$modalias'

Tejun Heo wrote:
> 1. Please apply timing-debug.patch on 2.6.22rc1-git5 or later and report
> the log with timestamp as before.  Let's see why the timeout has doubled.
>
> 2. Does the attached disable-dev_init_params.patch fix your problem?
>
>   

