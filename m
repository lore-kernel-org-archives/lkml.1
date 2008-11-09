Return-Path: <linux-kernel-owner+w=401wt.eu-S1754884AbYKIJSa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754884AbYKIJSa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Nov 2008 04:18:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752470AbYKIJSN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Nov 2008 04:18:13 -0500
Received: from ey-out-2122.google.com ([74.125.78.25]:20445 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752397AbYKIJSG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Nov 2008 04:18:06 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=AqYIc8mn1/hWnGiIfqd44J+W/j2UeYgl5v+q7ZPqZHPaLYSakXhdnBVKMSoyBWU5u5
         xf25lbVvxnaa8Jr4izZgwK9zzzsTz31LJvqHY5tkzljStC5ixtniz9CA2hnWJcHsgddR
         Y5EMAmebiDBbzDpExUOfuLK9o+UdbcqTdlqEo=
Message-ID: <db0ad2ed0811090118m10cb755pe92cd1a000b6611d@mail.gmail.com>
Date: Sun, 9 Nov 2008 04:18:03 -0500
From: "Corey Bertram" <qr7atgwu@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: exception Emask 0x0 SAct 0x1 SErr 0x0 action 0x6 frozen
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Forgive me if this isn't proper for this list but throughout sept-oct
there was thread 'exception Emask 0x0 SAct 0x1 / SErr 0x0 action 0x2
frozen'. Discussion continued till mid October and then died off.
It touched on issues with people seeing the following on disk
intensive transactions I believe.
[11285.918535] ata9.00: exception Emask 0x0 SAct 0x1 SErr 0x0 action 0x6 frozen
[11285.918567] ata9.00: cmd 61/03:00:49:00:00/00:00:00:00:00/40 tag 0
ncq 1536 out
[11285.918568] res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
[11285.918619] ata9.00: status: { DRDY }
[11285.918635] ata9: hard resetting link

As of today I'm running:
Linux isis 2.6.27-7-server #1 SMP Tue Nov 4 20:16:57 UTC 2008 x86_64 GNU/Linux

I'm running a 7 disk software raid 5 on a SuperMicro AOC-SAT2-MV8:
SCSI storage controller: Marvell Technology Group Ltd. MV88SX6081
8-port SATAII PCI-X Controller (rev 09)

As far as the drives go, they're 500GB's each:
4 are Seagate ST3500630AS (7200.10)
3 are WDC WD5000AAKS-00YGA0 (yes i know, the dreaded AAKS)
*The errors appear to happen on all of the drives; I've changed the
ordering (because the logs make it appear that 3 drives are the ones
with issues, and it just changes which drives report the errors).

The filesystem is XFS.

These problems manifested when i moved from CentOS 2.6.18 32bit to
Ubuntu 2.6.27.2.2 64Bit. The drives and controller where rock solid. I
reinstalled due to a mobo/cpu change so i cant with certainty say its
not hardware related, but giving other peoples findings i would rule
out the changed hardware. I even replaced the controller and cables
with no change in results.

I initially reported this to the ubuntu bugtracker late august and
just walked away from the system until today when i attempted to
upgrade (to ubuntu 8.10) and try again.
Typical behavior: Upon transferring after about 20GB's or so it took
out my raid and caused all the disks to desync. I managed to get all
but one disk to resync but i _wont_ be stressing the raid (including a
rebuild) until this issue is fixed so i'm not sure what more i can
provide as far as logs go.

Bug behavior: On large transfers (I've honestly only tried 4-12GB
transfers), the transfers seem to work at first, then stalls for ~30
seconds, recovers, transfer for 60 seconds or so, then stall again,
constantly repeating this cycle.

Does _anyone_ have any update on this issue?
Original bug i created:
https://bugs.launchpad.net/ubuntu/+source/linux/+bug/263160/
similar posting it would seem:
https://bugzilla.redhat.com/show_bug.cgi?id=462425

*NOTE* yes these logs are 'old' but the current ones looked exactly
the same. I didn't dump any recent ones due to that fact. I cant
reproduce this anymore because i cant risk loosing the data in the
raid.
dmesg:
[11285.918535] ata9.00: exception Emask 0x0 SAct 0x1 SErr 0x0 action 0x6 frozen
[11285.918567] ata9.00: cmd 61/03:00:49:00:00/00:00:00:00:00/40 tag 0
ncq 1536 out
[11285.918568] res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
[11285.918619] ata9.00: status: { DRDY }
[11285.918635] ata9: hard resetting link
[11286.420039] ata9: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[11286.460065] ata9.00: max_sectors limited to 256 for NCQ
[11286.520054] ata9.00: max_sectors limited to 256 for NCQ
[11286.520059] ata9.00: configured for UDMA/133
[11286.520077] ata9: EH complete
[11286.520119] sd 8:0:0:0: [sdd] 976773168 512-byte hardware sectors (500108 MB)
[11286.520132] sd 8:0:0:0: [sdd] Write Protect is off
[11286.520134] sd 8:0:0:0: [sdd] Mode Sense: 00 3a 00 00
[11286.520154] sd 8:0:0:0: [sdd] Write cache: enabled, read cache:
enabled, doesn't support DPO or FUA
[11326.988529] ata8.00: exception Emask 0x0 SAct 0x1 SErr 0x0 action 0x6 frozen
[11326.988554] ata8.00: cmd 61/03:00:49:00:00/00:00:00:00:00/40 tag 0
ncq 1536 out
[11326.988555] res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
[11326.988606] ata8.00: status: { DRDY }
[11326.988623] ata8: hard resetting link
[11327.500037] ata8: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[11327.580053] ata8.00: max_sectors limited to 256 for NCQ
[11327.657199] ata8.00: max_sectors limited to 256 for NCQ
[11327.657202] ata8.00: configured for UDMA/133
[11327.657207] ata8: EH complete
[11327.657257] sd 7:0:0:0: [sdc] 976773168 512-byte hardware sectors (500108 MB)
[11327.657272] sd 7:0:0:0: [sdc] Write Protect is off
[11327.657273] sd 7:0:0:0: [sdc] Mode Sense: 00 3a 00 00
[11327.657296] sd 7:0:0:0: [sdc] Write cache: enabled, read cache:
enabled, doesn't support DPO or FUA
[11377.938532] ata7.00: exception Emask 0x0 SAct 0x1 SErr 0x0 action 0x6 frozen
[11377.938557] ata7.00: cmd 61/03:00:49:00:00/00:00:00:00:00/40 tag 0
ncq 1536 out
[11377.938558] res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
[11377.938608] ata7.00: status: { DRDY }
[11377.938624] ata7: hard resetting link
[11378.440037] ata7: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[11378.520056] ata7.00: max_sectors limited to 256 for NCQ
[11378.600065] ata7.00: max_sectors limited to 256 for NCQ
[11378.600068] ata7.00: configured for UDMA/133
[11378.600073] ata7: EH complete
[11378.600120] sd 6:0:0:0: [sdb] 976773168 512-byte hardware sectors (500108 MB)
[11378.600133] sd 6:0:0:0: [sdb] Write Protect is off
[11378.600135] sd 6:0:0:0: [sdb] Mode Sense: 00 3a 00 00
[11378.600155] sd 6:0:0:0: [sdb] Write cache: enabled, read cache:
enabled, doesn't support DPO or FUA
[11711.718523] ata9.00: exception Emask 0x0 SAct 0x1 SErr 0x0 action 0x6 frozen
[11711.718548] ata9.00: cmd 61/03:00:49:00:00/00:00:00:00:00/40 tag 0
ncq 1536 out
[11711.718549] res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
[11711.718600] ata9.00: status: { DRDY }
[11711.718616] ata9: hard resetting link
[11712.220041] ata9: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[11712.260058] ata9.00: max_sectors limited to 256 for NCQ
[11712.320057] ata9.00: max_sectors limited to 256 for NCQ
[11712.320066] ata9.00: configured for UDMA/133
[11712.320072] ata9: EH complete
[11712.320112] sd 8:0:0:0: [sdd] 976773168 512-byte hardware sectors (500108 MB)
[11712.320125] sd 8:0:0:0: [sdd] Write Protect is off
[11712.320127] sd 8:0:0:0: [sdd] Mode Sense: 00 3a 00 00
[11712.320148] sd 8:0:0:0: [sdd] Write cache: enabled, read cache:
enabled, doesn't support DPO or FUA
[11849.328524] ata7.00: exception Emask 0x0 SAct 0x1 SErr 0x0 action 0x6 frozen
[11849.328549] ata7.00: cmd 61/03:00:49:00:00/00:00:00:00:00/40 tag 0
ncq 1536 out
[11849.328549] res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
[11849.328600] ata7.00: status: { DRDY }
[11849.328617] ata7: hard resetting link
[11849.830037] ata7: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[11849.910070] ata7.00: max_sectors limited to 256 for NCQ
[11849.990053] ata7.00: max_sectors limited to 256 for NCQ
[11849.990057] ata7.00: configured for UDMA/133
[11849.990069] ata7: EH complete
[11849.990109] sd 6:0:0:0: [sdb] 976773168 512-byte hardware sectors (500108 MB)
[11849.990123] sd 6:0:0:0: [sdb] Write Protect is off
[11849.990125] sd 6:0:0:0: [sdb] Mode Sense: 00 3a 00 00
[11849.990147] sd 6:0:0:0: [sdb] Write cache: enabled, read cache:
enabled, doesn't support DPO or FUA
[11909.629773] ata9.00: exception Emask 0x0 SAct 0x1 SErr 0x0 action 0x6 frozen
[11909.629797] ata9.00: cmd 61/03:00:49:00:00/00:00:00:00:00/40 tag 0
ncq 1536 out
[11909.629798] res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
[11909.629849] ata9.00: status: { DRDY }
[11909.629865] ata9: hard resetting link
[11910.131295] ata9: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[11910.180068] ata9.00: max_sectors limited to 256 for NCQ
[11910.231316] ata9.00: max_sectors limited to 256 for NCQ
[11910.231319] ata9.00: configured for UDMA/133
[11910.231327] ata9: EH complete
[11910.231381] sd 8:0:0:0: [sdd] 976773168 512-byte hardware sectors (500108 MB)
[11910.231394] sd 8:0:0:0: [sdd] Write Protect is off
[11910.231396] sd 8:0:0:0: [sdd] Mode Sense: 00 3a 00 00
[11910.231417] sd 8:0:0:0: [sdd] Write cache: enabled, read cache:
enabled, doesn't support DPO or FUA
[11996.729773] ata7.00: exception Emask 0x0 SAct 0x1 SErr 0x0 action 0x6 frozen
[11996.729797] ata7.00: cmd 61/03:00:49:00:00/00:00:00:00:00/40 tag 0
ncq 1536 out
[11996.729798] res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
[11996.729848] ata7.00: status: { DRDY }
[11996.729865] ata7: hard resetting link
[11997.231291] ata7: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[11997.311308] ata7.00: max_sectors limited to 256 for NCQ
[11997.391306] ata7.00: max_sectors limited to 256 for NCQ
[11997.391316] ata7.00: configured for UDMA/133
[11997.391322] ata7: EH complete
[11997.391366] sd 6:0:0:0: [sdb] 976773168 512-byte hardware sectors (500108 MB)
[11997.391378] sd 6:0:0:0: [sdb] Write Protect is off
[11997.391380] sd 6:0:0:0: [sdb] Mode Sense: 00 3a 00 00
[11997.391400] sd 6:0:0:0: [sdb] Write cache: enabled, read cache:
enabled, doesn't support DPO or FU

/var/log/messages:
Aug 30 20:12:43 isis kernel: [11285.918635] ata9: hard resetting link
Aug 30 20:12:43 isis kernel: [11286.420039] ata9: SATA link up 3.0
Gbps (SStatus 123 SControl 300)
Aug 30 20:12:43 isis kernel: [11286.460065] ata9.00: max_sectors
limited to 256 for NCQ
Aug 30 20:12:43 isis kernel: [11286.520054] ata9.00: max_sectors
limited to 256 for NCQ
Aug 30 20:12:43 isis kernel: [11286.520059] ata9.00: configured for UDMA/133
Aug 30 20:12:43 isis kernel: [11286.520077] ata9: EH complete
Aug 30 20:12:43 isis kernel: [11286.520119] sd 8:0:0:0: [sdd]
976773168 512-byte hardware sectors (500108 MB)
Aug 30 20:12:43 isis kernel: [11286.520132] sd 8:0:0:0: [sdd] Write
Protect is off
Aug 30 20:12:43 isis kernel: [11286.520154] sd 8:0:0:0: [sdd] Write
cache: enabled, read cache: enabled, doesn't support DPO or FUA
Aug 30 20:13:24 isis kernel: [11326.988623] ata8: hard resetting link
Aug 30 20:13:24 isis kernel: [11327.500037] ata8: SATA link up 3.0
Gbps (SStatus 123 SControl 300)
Aug 30 20:13:24 isis kernel: [11327.580053] ata8.00: max_sectors
limited to 256 for NCQ
Aug 30 20:13:24 isis kernel: [11327.657199] ata8.00: max_sectors
limited to 256 for NCQ
Aug 30 20:13:24 isis kernel: [11327.657202] ata8.00: configured for UDMA/133
Aug 30 20:13:24 isis kernel: [11327.657207] ata8: EH complete
Aug 30 20:13:24 isis kernel: [11327.657257] sd 7:0:0:0: [sdc]
976773168 512-byte hardware sectors (500108 MB)
Aug 30 20:13:24 isis kernel: [11327.657272] sd 7:0:0:0: [sdc] Write
Protect is off
Aug 30 20:13:24 isis kernel: [11327.657296] sd 7:0:0:0: [sdc] Write
cache: enabled, read cache: enabled, doesn't support DPO or FUA
Aug 30 20:14:15 isis kernel: [11377.938624] ata7: hard resetting link
Aug 30 20:14:15 isis kernel: [11378.440037] ata7: SATA link up 3.0
Gbps (SStatus 123 SControl 300)
Aug 30 20:14:15 isis kernel: [11378.520056] ata7.00: max_sectors
limited to 256 for NCQ
Aug 30 20:14:15 isis kernel: [11378.600065] ata7.00: max_sectors
limited to 256 for NCQ
Aug 30 20:14:15 isis kernel: [11378.600068] ata7.00: configured for UDMA/133
Aug 30 20:14:15 isis kernel: [11378.600073] ata7: EH complete
Aug 30 20:14:15 isis kernel: [11378.600120] sd 6:0:0:0: [sdb]
976773168 512-byte hardware sectors (500108 MB)
Aug 30 20:14:15 isis kernel: [11378.600133] sd 6:0:0:0: [sdb] Write
Protect is off
Aug 30 20:14:15 isis kernel: [11378.600155] sd 6:0:0:0: [sdb] Write
cache: enabled, read cache: enabled, doesn't support DPO or FUA
Aug 30 20:19:48 isis kernel: [11711.718616] ata9: hard resetting link
Aug 30 20:19:49 isis kernel: [11712.220041] ata9: SATA link up 3.0
Gbps (SStatus 123 SControl 300)
Aug 30 20:19:49 isis kernel: [11712.260058] ata9.00: max_sectors
limited to 256 for NCQ
Aug 30 20:19:49 isis kernel: [11712.320057] ata9.00: max_sectors
limited to 256 for NCQ
Aug 30 20:19:49 isis kernel: [11712.320066] ata9.00: configured for UDMA/133
Aug 30 20:19:49 isis kernel: [11712.320072] ata9: EH complete
Aug 30 20:19:49 isis kernel: [11712.320112] sd 8:0:0:0: [sdd]
976773168 512-byte hardware sectors (500108 MB)
Aug 30 20:19:49 isis kernel: [11712.320125] sd 8:0:0:0: [sdd] Write
Protect is off
Aug 30 20:19:49 isis kernel: [11712.320148] sd 8:0:0:0: [sdd] Write
cache: enabled, read cache: enabled, doesn't support DPO or FUA
Aug 30 20:22:06 isis kernel: [11849.328617] ata7: hard resetting link
Aug 30 20:22:06 isis kernel: [11849.830037] ata7: SATA link up 3.0
Gbps (SStatus 123 SControl 300)
Aug 30 20:22:06 isis kernel: [11849.910070] ata7.00: max_sectors
limited to 256 for NCQ
Aug 30 20:22:07 isis kernel: [11849.990053] ata7.00: max_sectors
limited to 256 for NCQ
Aug 30 20:22:07 isis kernel: [11849.990057] ata7.00: configured for UDMA/133
Aug 30 20:22:07 isis kernel: [11849.990069] ata7: EH complete
Aug 30 20:22:07 isis kernel: [11849.990109] sd 6:0:0:0: [sdb]
976773168 512-byte hardware sectors (500108 MB)
Aug 30 20:22:07 isis kernel: [11849.990123] sd 6:0:0:0: [sdb] Write
Protect is off
Aug 30 20:22:07 isis kernel: [11849.990147] sd 6:0:0:0: [sdb] Write
cache: enabled, read cache: enabled, doesn't support DPO or FUA
Aug 30 20:23:06 isis kernel: [11909.629865] ata9: hard resetting link
Aug 30 20:23:07 isis kernel: [11910.131295] ata9: SATA link up 3.0
Gbps (SStatus 123 SControl 300)
Aug 30 20:23:07 isis kernel: [11910.180068] ata9.00: max_sectors
limited to 256 for NCQ
Aug 30 20:23:07 isis kernel: [11910.231316] ata9.00: max_sectors
limited to 256 for NCQ
Aug 30 20:23:07 isis kernel: [11910.231319] ata9.00: configured for UDMA/133
Aug 30 20:23:07 isis kernel: [11910.231327] ata9: EH complete
Aug 30 20:23:07 isis kernel: [11910.231381] sd 8:0:0:0: [sdd]
976773168 512-byte hardware sectors (500108 MB)
Aug 30 20:23:07 isis kernel: [11910.231394] sd 8:0:0:0: [sdd] Write
Protect is off
Aug 30 20:23:07 isis kernel: [11910.231417] sd 8:0:0:0: [sdd] Write
cache: enabled, read cache: enabled, doesn't support DPO or FUA
Aug 30 20:24:33 isis kernel: [11996.729865] ata7: hard resetting link
Aug 30 20:24:34 isis kernel: [11997.231291] ata7: SATA link up 3.0
Gbps (SStatus 123 SControl 300)
Aug 30 20:24:34 isis kernel: [11997.311308] ata7.00: max_sectors
limited to 256 for NCQ
Aug 30 20:24:34 isis kernel: [11997.391306] ata7.00: max_sectors
limited to 256 for NCQ
Aug 30 20:24:34 isis kernel: [11997.391316] ata7.00: configured for UDMA/133
Aug 30 20:24:34 isis kernel: [11997.391322] ata7: EH complete
Aug 30 20:24:34 isis kernel: [11997.391366] sd 6:0:0:0: [sdb]
976773168 512-byte hardware sectors (500108 MB)
Aug 30 20:24:34 isis kernel: [11997.391378] sd 6:0:0:0: [sdb] Write
Protect is off
Aug 30 20:24:34 isis kernel: [11997.391400] sd 6:0:0:0: [sdb] Write
cache: enabled, read cache: enabled, doesn't support DPO or FUA
