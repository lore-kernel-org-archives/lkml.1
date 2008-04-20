Return-Path: <linux-kernel-owner+w=401wt.eu-S1757867AbYDTB2R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757867AbYDTB2R (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Apr 2008 21:28:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751984AbYDTB2E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Apr 2008 21:28:04 -0400
Received: from smtp-out2.blueyonder.co.uk ([195.188.213.5]:49227 "EHLO
	smtp-out2.blueyonder.co.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751365AbYDTB2D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Apr 2008 21:28:03 -0400
Message-ID: <480A9C1E.8050505@blueyonder.co.uk>
Date: Sun, 20 Apr 2008 02:27:58 +0100
From: Sid Boyce <g3vbv@blueyonder.co.uk>
Reply-To: g3vbv@blueyonder.co.uk
Organization: blueyonder.co.uk
User-Agent: Thunderbird 3.0a1pre (X11/2007120104)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: 2.6.25-git1/2 not seeing /dev/sda1 (XFS root) or /dev/sda2 (swap)
 partitions on a SATA drive
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.25 x86_64 boots fine as does -git1/2 boxes using reiserfs and ext3. 
With xfs it can't find these and drops into a shell.
/dev/disk/by-id/scsi-SATA_WDC_WD5000AAKS-_WD-WCAS85018679-part2 swap 
              swap       defaults              0 0
/dev/disk/by-id/scsi-SATA_WDC_WD5000AAKS-_WD-WCAS85018679-part1 / 
              xfs        defaults              1 1

 From my .config
CONFIG_XFS_FS=m
CONFIG_XFS_QUOTA=y
CONFIG_XFS_POSIX_ACL=y
CONFIG_XFS_RT=y

The other boxes are configure pretty much the same, but I can diff the 
.config's if required.
# l /lib/modules/2.6.25-git2-smp/kernel/drivers/ata/sata_sil.ko
-rw-r--r-- 1 root root 272240 2008-04-19 21:54 
/lib/modules/2.6.25-git2-smp/kernel/drivers/ata/sata_sil.ko

00:0c.0 IDE interface: nVidia Corporation MCP55 IDE (rev a1)
00:0d.0 IDE interface: nVidia Corporation MCP55 SATA Controller (rev a2)
00:0d.1 IDE interface: nVidia Corporation MCP55 SATA Controller (rev a2)
00:0d.2 IDE interface: nVidia Corporation MCP55 SATA Controller (rev a2)
03:00.0 Mass storage controller: Silicon Image, Inc. SiI 3132 Serial ATA 
Raid II Controller (rev 01)

 From working 2.6.25
# lsmod|grep sata
sata_nv                36872  2
sata_sil24             26692  0
libata                173664  3 pata_amd,sata_nv,sata_sil24

Regards
Sid.
-- 
Sid Boyce ... Hamradio License G3VBV, Licensed Private Pilot
Emeritus IBM/Amdahl Mainframes and Sun/Fujitsu Servers Tech Support 
Specialist, Cricket Coach
Microsoft Windows Free Zone - Linux used for all Computing Tasks

