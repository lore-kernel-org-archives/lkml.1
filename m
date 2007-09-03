Return-Path: <linux-kernel-owner+w=401wt.eu-S1756663AbXICH4X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756663AbXICH4X (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Sep 2007 03:56:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754646AbXICH4P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Sep 2007 03:56:15 -0400
Received: from smtp27.orange.fr ([80.12.242.96]:30160 "EHLO smtp27.orange.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754517AbXICH4O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Sep 2007 03:56:14 -0400
X-ME-UUID: 20070903075612746.B65631C00088@mwinf2727.orange.fr
Subject: very very strange simultaneous RAID resync on sep 2, 01:06 CEST
	(+2)
From: Xavier Bestel <xavier.bestel@free.fr>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Mon, 03 Sep 2007 09:56:10 +0200
Message-Id: <1188806170.1131.479.camel@frg-rhel40-em64t-04>
Mime-Version: 1.0
X-Mailer: Evolution 2.0.2 (2.0.2-27) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I have a server running with RAID5 disks, under debian/stable, kernel
2.6.18-5-686. Yesterday the RAID resync'd for no apparent reason,
without even mdamd sending a mail to warn about that:

Sep  2 01:06:01 awak kernel: md: syncing RAID array md0
Sep  2 01:06:01 awak kernel: md: minimum _guaranteed_ reconstruction speed: 1000 KB/sec/disc.
Sep  2 01:06:01 awak kernel: md: using maximum available idle IO bandwidth (but not more than 200000 KB/sec) for reconstruction.
Sep  2 01:06:01 awak kernel: md: using 128k window, over a total of 48064 blocks.
Sep  2 01:06:01 awak kernel: md: delaying resync of md1 until md0 has finished resync (they share one or more physical units)
Sep  2 01:06:01 awak kernel: md: delaying resync of md2 until md0 has finished resync (they share one or more physical units)
Sep  2 01:06:05 awak kernel: md: md0: sync done.
Sep  2 01:06:05 awak kernel: RAID1 conf printout:
Sep  2 01:06:05 awak kernel:  --- wd:3 rd:3
Sep  2 01:06:05 awak kernel:  disk 0, wo:0, o:1, dev:hda1
Sep  2 01:06:05 awak kernel:  disk 1, wo:0, o:1, dev:hde1
Sep  2 01:06:05 awak kernel:  disk 2, wo:0, o:1, dev:hdc1
Sep  2 01:06:05 awak kernel: md: delaying resync of md2 until md1 has finished resync (they share one or more physical units)
Sep  2 01:06:05 awak kernel: md: syncing RAID array md1
Sep  2 01:06:05 awak kernel: md: minimum _guaranteed_ reconstruction speed: 1000 KB/sec/disc.
Sep  2 01:06:05 awak kernel: md: using maximum available idle IO bandwidth (but not more than 200000 KB/sec) for reconstruction.
Sep  2 01:06:05 awak kernel: md: using 128k window, over a total of 10000384 blocks.

In itself, this event is already strange. But what's even stranger is
that another guy had the same resync exactely at the same time (all
times are CEST (+0200)):

Sep  2 01:06:01 in22 kernel: md: syncing RAID array md0
Sep  2 01:06:01 in22 kernel: md: minimum _guaranteed_ reconstruction speed: 1000 KB/sec/disc.
Sep  2 01:06:01 in22 kernel: md: using maximum available idle IO bandwidth (but not more than 200000 KB/sec) for reconstruction.
Sep  2 01:06:01 in22 kernel: md: using 128k window, over a total of 1003904 blocks.
Sep  2 01:06:01 in22 kernel: md: delaying resync of md1 until md0 has finished resync (they share one or more physical units)
Sep  2 01:06:01 in22 kernel: md: delaying resync of md2 until md0 has finished resync (they share one or more physical units)
Sep  2 01:06:01 in22 kernel: md: delaying resync of md1 until md0 has finished resync (they share one or more physical units)
Sep  2 01:06:01 in22 kernel: md: delaying resync of md3 until md0 has finished resync (they share one or more physical units)
Sep  2 01:06:01 in22 kernel: md: delaying resync of md1 until md0 has finished resync (they share one or more physical units)
Sep  2 01:06:01 in22 kernel: md: delaying resync of md2 until md3 has finished resync (they share one or more physical units)
Sep  2 01:06:39 in22 kernel: md: md0: sync done.
Sep  2 01:06:39 in22 kernel: md: delaying resync of md2 until md3 has finished resync (they share one or more physical units)
Sep  2 01:06:39 in22 kernel: md: syncing RAID array md1
Sep  2 01:06:39 in22 kernel: md: minimum _guaranteed_ reconstruction speed: 1000 KB/sec/disc.
Sep  2 01:06:39 in22 kernel: md: using maximum available idle IO bandwidth (but not more than 200000 KB/sec) for reconstruction.
Sep  2 01:06:39 in22 kernel: md: using 128k window, over a total of 7004224 blocks.
Sep  2 01:06:39 in22 kernel: md: delaying resync of md3 until md1 has finished resync (they share one or more physical units)
Sep  2 01:06:39 in22 kernel: RAID1 conf printout:
Sep  2 01:06:39 in22 kernel:  --- wd:2 rd:2
Sep  2 01:06:39 in22 kernel:  disk 0, wo:0, o:1, dev:hda1
Sep  2 01:06:39 in22 kernel:  disk 1, wo:0, o:1, dev:hdb1
(reboot)

I'm still gathering informations (no idea what his disks are, etc.), but
does anyone have the same problem ? Does anyone know where it can come
from (debian trouble, md bug, drive firmware problem, rootkit, ..) and
how I can pinpoint that ?

Thanks,
	Xav


