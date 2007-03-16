Return-Path: <linux-kernel-owner+w=401wt.eu-S965447AbXCPOfA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965447AbXCPOfA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2007 10:35:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965484AbXCPOfA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Mar 2007 10:35:00 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:49840 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965447AbXCPOe7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2007 10:34:59 -0400
From: Christian <christiand59@web.de>
To: linux-kernel@vger.kernel.org
Subject: Re: [BUG 2.6.21-rc3-git9] SATA NCQ failure with Samsum HD401LJ
Date: Fri, 16 Mar 2007 15:34:43 +0100
User-Agent: KMail/1.9.6
References: <20070316112002.GA6449@roonstrasse.net>
In-Reply-To: <20070316112002.GA6449@roonstrasse.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703161534.43679.christiand59@web.de>
X-Provags-ID: V01U2FsdGVkX19QzdPIAC5Kb9oGeWZLdXvhUXHEEi59MW8IzfQ
 rQWPAVyuhdjM2YhoXQGh7do7pLPIheJOOauklNrA5ciCkSlxY+
 9N9xMMmomNQU+kP2vSFSg==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 16 March 2007 12:20:02 Max Kellermann wrote:
> Hi,
>
> I have been trying to upgrade my 2.6.19 kernel for a while now,
> without success.  All kernel versions since 2.6.20 failed with a
> timeout while trying to write to my SATA hard disk.  After I wait for
> a while (during which all I/O to the hard disk blocks), the kernel
> message "NCQ disabled due to excessive errors" appears, and the system
> seems to work perfectly.
>
> My system is an Athlon64 X2 on an Asus A8N-Premium.  I'm using the
> sata_nv driver for the on-board SATA controller.  My only hard disk is
> a Samsum HD401LJ (400 GB).
>
> The kernel is build statically, and the only module is nvidia.ko.  If
> someone believes it may make a difference, I can try the kernel
> without the proprietary module.
>
> Please see the kernel config and dmesg attached to this email.
>
> I don't know the libata subsystem well, but I suspect my hard drive
> has to be added to the NCQ blacklist.
>
> Max

Hi,

I have the same HW ;-) And the same problem on 2.6.21-rc3-mm1.


[ 8212.682404] ata1: EH in ADMA mode, notifier 0x0 notifier_error 0x0 gen_ctl 
0x1501000 status 0x400 next cpb count 0x0 next cpb idx 0x0
[ 8212.682409] ata1: CPB 1: ctl_flags 0x1f, resp_flags 0x2
[ 8212.682411] ata1: CPB 2: ctl_flags 0x1f, resp_flags 0x2
[ 8212.682413] ata1: CPB 3: ctl_flags 0x1f, resp_flags 0x2
[ 8212.682416] ata1: EH in ADMA mode, notifier 0x0 notifier_error 0x0 gen_ctl 
0x1501000 status 0x400
[ 8212.682419] ata1: CPB 1: ctl_flags 0x1f, resp_flags 0x2
[ 8212.682420] ata1: CPB 2: ctl_flags 0x1f, resp_flags 0x2
[ 8212.682422] ata1: CPB 3: ctl_flags 0x1f, resp_flags 0x2
[ 8212.682427] ata1: timeout waiting for ADMA IDLE, stat=0x400
[ 8212.682432] ata1: timeout waiting for ADMA LEGACY, stat=0x400
[ 8212.682439] ata1.00: exception Emask 0x0 SAct 0xe SErr 0x200000 action 0x2 
frozen
[ 8212.682445] ata1.00: cmd 61/00:08:df:90:f7/02:00:02:00:00/40 tag 1 cdb 0x0 
data 262144 out
[ 8212.682446]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 
(timeout)
[ 8212.682451] ata1.00: cmd 61/00:10:df:92:f7/02:00:02:00:00/40 tag 2 cdb 0x0 
data 262144 out
[ 8212.682453]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 
(timeout)
[ 8212.682457] ata1.00: cmd 61/00:18:df:94:f7/02:00:02:00:00/40 tag 3 cdb 0x0 
data 262144 out
[ 8212.682459]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 
(timeout)
[ 8212.833749] ata1: soft resetting port
[ 8212.941187] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[ 8212.992763] ata1.00: configured for UDMA/133
[ 8212.992837] ata1: EH complete
[ 8212.992906] SCSI device sda: 781422768 512-byte hdwr sectors (400088 MB)
[ 8212.992936] sda: Write Protect is off
[ 8212.992938] sda: Mode Sense: 00 3a 00 00
[ 8212.993048] SCSI device sda: write cache: enabled, read cache: enabled, 
doesn't support DPO or FUA
[ 8227.981905] ata1: EH in ADMA mode, notifier 0x0 notifier_error 0x0 gen_ctl 
0x1501000 status 0x400 next cpb count 0x2 next cpb idx 0x0
[ 8227.981910] ata1: CPB 0: ctl_flags 0x1f, resp_flags 0x0
[ 8227.981912] ata1: CPB 1: ctl_flags 0x1f, resp_flags 0x0
[ 8227.981914] ata1: CPB 2: ctl_flags 0x1f, resp_flags 0x0
[ 8227.981917] ata1: EH in ADMA mode, notifier 0x0 notifier_error 0x0 gen_ctl 
0x1501000 status 0x400
[ 8227.981919] ata1: CPB 0: ctl_flags 0x1f, resp_flags 0x0
[ 8227.981921] ata1: CPB 1: ctl_flags 0x1f, resp_flags 0x0
[ 8227.981923] ata1: CPB 2: ctl_flags 0x1f, resp_flags 0x0
[ 8227.981928] ata1: timeout waiting for ADMA IDLE, stat=0x400
[ 8227.981933] ata1: timeout waiting for ADMA LEGACY, stat=0x400
[ 8227.981940] ata1.00: exception Emask 0x0 SAct 0x7 SErr 0x0 action 0x2 
frozen
[ 8227.981945] ata1.00: cmd 61/00:00:df:94:f7/02:00:02:00:00/40 tag 0 cdb 0x0 
data 262144 out
[ 8227.981947]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 
(timeout)
[ 8227.981952] ata1.00: cmd 61/00:08:df:92:f7/02:00:02:00:00/40 tag 1 cdb 0x0 
data 262144 out
[ 8227.981953]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 
(timeout)
[ 8227.981958] ata1.00: cmd 61/00:10:df:90:f7/02:00:02:00:00/40 tag 2 cdb 0x0 
data 262144 out
[ 8227.981959]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 
(timeout)
[ 8228.133306] ata1: soft resetting port
[ 8228.208763] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[ 8228.258729] ata1.00: configured for UDMA/133
[ 8228.258824] ata1: EH complete
[ 8228.258926] SCSI device sda: 781422768 512-byte hdwr sectors (400088 MB)
[ 8228.259021] sda: Write Protect is off
[ 8228.259023] sda: Mode Sense: 00 3a 00 00
[ 8228.259132] SCSI device sda: write cache: enabled, read cache: enabled, 
doesn't support DPO or FUA
[ 8243.247980] ata1: EH in ADMA mode, notifier 0x0 notifier_error 0x0 gen_ctl 
0x1501000 status 0x400 next cpb count 0x2 next cpb idx 0x0
[ 8243.247985] ata1: CPB 0: ctl_flags 0x1f, resp_flags 0x0
[ 8243.247987] ata1: CPB 1: ctl_flags 0x1f, resp_flags 0x0
[ 8243.247989] ata1: CPB 2: ctl_flags 0x1f, resp_flags 0x0
[ 8243.247992] ata1: EH in ADMA mode, notifier 0x0 notifier_error 0x0 gen_ctl 
0x1501000 status 0x400
[ 8243.247994] ata1: CPB 0: ctl_flags 0x1f, resp_flags 0x0
[ 8243.247996] ata1: CPB 1: ctl_flags 0x1f, resp_flags 0x0
[ 8243.247998] ata1: CPB 2: ctl_flags 0x1f, resp_flags 0x0
[ 8243.248002] ata1: timeout waiting for ADMA IDLE, stat=0x400
[ 8243.248007] ata1: timeout waiting for ADMA LEGACY, stat=0x400
[ 8243.248014] ata1.00: exception Emask 0x0 SAct 0x7 SErr 0x0 action 0x2 
frozen
[ 8243.248019] ata1.00: cmd 61/00:00:df:90:f7/02:00:02:00:00/40 tag 0 cdb 0x0 
data 262144 out
[ 8243.248021]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 
(timeout)
[ 8243.248026] ata1.00: cmd 61/00:08:df:92:f7/02:00:02:00:00/40 tag 1 cdb 0x0 
data 262144 out
[ 8243.248027]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 
(timeout)
[ 8243.248032] ata1.00: cmd 61/00:10:df:94:f7/02:00:02:00:00/40 tag 2 cdb 0x0 
data 262144 out
[ 8243.248033]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 
(timeout)
[ 8243.399381] ata1: soft resetting port
[ 8243.474841] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[ 8243.525947] ata1.00: configured for UDMA/133
[ 8243.526036] ata1: EH complete
[ 8243.526110] SCSI device sda: 781422768 512-byte hdwr sectors (400088 MB)
[ 8243.526140] sda: Write Protect is off
[ 8243.526142] sda: Mode Sense: 00 3a 00 00
[ 8243.526170] SCSI device sda: write cache: enabled, read cache: enabled, 
doesn't support DPO or FUA
[ 8258.515058] ata1: EH in ADMA mode, notifier 0x0 notifier_error 0x0 gen_ctl 
0x1501000 status 0x400 next cpb count 0x2 next cpb idx 0x0
[ 8258.515063] ata1: CPB 0: ctl_flags 0x1f, resp_flags 0x0
[ 8258.515065] ata1: CPB 1: ctl_flags 0x1f, resp_flags 0x0
[ 8258.515067] ata1: CPB 2: ctl_flags 0x1f, resp_flags 0x0
[ 8258.515070] ata1: EH in ADMA mode, notifier 0x0 notifier_error 0x0 gen_ctl 
0x1501000 status 0x400
[ 8258.515072] ata1: CPB 0: ctl_flags 0x1f, resp_flags 0x0
[ 8258.515074] ata1: CPB 1: ctl_flags 0x1f, resp_flags 0x0
[ 8258.515076] ata1: CPB 2: ctl_flags 0x1f, resp_flags 0x0
[ 8258.515081] ata1: timeout waiting for ADMA IDLE, stat=0x400
[ 8258.515085] ata1: timeout waiting for ADMA LEGACY, stat=0x400
[ 8258.515091] ata1.00: NCQ disabled due to excessive errors
[ 8258.515094] ata1.00: exception Emask 0x0 SAct 0x7 SErr 0x0 action 0x2 
frozen
[ 8258.515099] ata1.00: cmd 61/00:00:df:94:f7/02:00:02:00:00/40 tag 0 cdb 0x0 
data 262144 out
[ 8258.515101]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 
(timeout)
[ 8258.515106] ata1.00: cmd 61/00:08:df:92:f7/02:00:02:00:00/40 tag 1 cdb 0x0 
data 262144 out
[ 8258.515107]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 
(timeout)
[ 8258.515112] ata1.00: cmd 61/00:10:df:90:f7/02:00:02:00:00/40 tag 2 cdb 0x0 
data 262144 out
[ 8258.515113]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 
(timeout)
[ 8258.666460] ata1: soft resetting port
[ 8258.741917] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[ 8258.792757] ata1.00: configured for UDMA/133
[ 8258.792816] ata1: EH complete
[ 8258.794272] SCSI device sda: 781422768 512-byte hdwr sectors (400088 MB)
[ 8258.794345] sda: Write Protect is off
[ 8258.794347] sda: Mode Sense: 00 3a 00 00
[ 8258.794437] SCSI device sda: write cache: enabled, read cache: enabled, 
doesn't support DPO or FUA

-Christian
