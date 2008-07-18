Return-Path: <linux-kernel-owner+w=401wt.eu-S1754013AbYGSKWA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754013AbYGSKWA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jul 2008 06:22:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752339AbYGSKVu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Jul 2008 06:21:50 -0400
Received: from hera.kernel.org ([140.211.167.34]:51382 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752103AbYGSKVt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jul 2008 06:21:49 -0400
Message-ID: <4880237A.7070002@kernel.org>
Date: Fri, 18 Jul 2008 14:00:42 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.12 (X11/20071114)
MIME-Version: 1.0
To: Jeroen Beerstra <jb@scorpion77.cjb.net>
CC: linux-kernel@vger.kernel.org,
       IDE/ATA development list <linux-ide@vger.kernel.org>
Subject: Re: non functional pata dvd drive under 2.6.25.6
References: <vi85j5-uig.ln1@scorpion77.cjb.net>
In-Reply-To: <vi85j5-uig.ln1@scorpion77.cjb.net>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sat, 19 Jul 2008 10:21:43 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Jeroen.

[cc'ing linux-ide]

Jeroen Beerstra wrote:
> hi there,
> 
> I've filed this as a bug with redhat bugzilla (12-6), https://
> bugzilla.redhat.com/show_bug.cgi?id=451081, but so far I've had no 
> response at all ... so here we go ;)
> 
> Basicly my ide dvd writer is non functional with Fedora 9 (kernel 
> 2.6.25.6). So far I've seen it functional only once when I booted with 
> media already inserted, but for the rest it's pretty much like this:
> 
> excerpt from dmesg
> 
> ata10.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2 frozen
> ata10.00: cmd a0/00:00:00:00:00/00:00:00:00:00/a0 tag 0
>          cdb 1e 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00
>          res 40/00:02:00:08:00/00:00:00:00:00/a0 Emask 0x4 (timeout)
> ata10.00: status: { DRDY }
> ata10: soft resetting link
> ata10: nv_mode_filter: 0x1&0x1f01f->0x1, BIOS=0x1f000 (0xc5000000) 
> ACPI=0x1f01f (30:600:0x13)
> ata10.00: configured for PIO0
> ata10: EH complete
> ata10.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2 frozen
> ata10.00: cmd a0/00:00:00:00:00/00:00:00:00:00/a0 tag 0
>          cdb 1e 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00
>          res 40/00:02:00:08:00/00:00:00:00:00/a0 Emask 0x4 (timeout)
> ata10.00: status: { DRDY }
> ata10: soft resetting link
> ata10: nv_mode_filter: 0x1&0x1f01f->0x1, BIOS=0x1f000 (0xc5000000) 
> ACPI=0x1f01f (30:600:0x13)
> ata10.00: configured for PIO0
> ata10: EH complete
> sr 10:0:0:0: ioctl_internal_command return code = 8000002
>    : Sense Key : Aborted Command [current] [descriptor]
>    : Add. Sense: No additional sense information
> ata10.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2 frozen
> ata10.00: cmd a0/00:00:00:00:00/00:00:00:00:00/a0 tag 0
>          cdb 00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00
>          res 40/00:02:00:08:00/00:00:00:00:00/a0 Emask 0x4 (timeout)
> ata10.00: status: { DRDY }
> ata10: soft resetting link
> ata10: nv_mode_filter: 0x1&0x1f01f->0x1, BIOS=0x1f000 (0xc5000000) 
> ACPI=0x1f01f (30:600:0x13)
> ata10.00: configured for PIO0
> ata10: EH complete
> 
> cat /sys/bus/scsi/devices/10:0:0:0/model 
> PATA 20X20X12X 
> 
> The drive is completely non functional.
> 
> System is a Nforce 780i SLI MB (Asus P5N-T Deluxe) with an Q9450 INtel 
> Core2 Quad CPU and 4 GB of ram.
> 
> With Windows XP/Vista there are no problems with this drive and also I 
> had no problems installing Fedora from this drive in the first place, so 
> I doubt if it is a hardware problem. 
> 
> I can live with the fact that I only have one writer available but not 
> with the fact that everything that tries to access the drive hangs with 
> status D for a very long time, hald-addon-storage for one....

Hmmm... the problem could be caused by hald polling for media presence.
 Does "hal-disable-polling /dev/srX" make any difference?
hal-disable-polling setting is persistent so if your drive goes bonkers
quickly after boot, you can disable polling, reboot and see whether
anything is different.  Also, please post the result of "lspci -nn" and
"hdparm -I /dev/srX" && please try 2.6.26.

Thanks.

-- 
tejun
