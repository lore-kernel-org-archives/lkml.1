Return-Path: <linux-kernel-owner+w=401wt.eu-S1755057AbZBQXG0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755057AbZBQXG0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Feb 2009 18:06:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751008AbZBQXGP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Feb 2009 18:06:15 -0500
Received: from mx1.aecom.yu.edu ([129.98.1.51]:40831 "EHLO mx1.aecom.yu.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751717AbZBQXGO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Feb 2009 18:06:14 -0500
X-AuditID: 816201a0-a549cbb000001567-eb-499b42e4dcde
Mime-Version: 1.0
Message-Id: <a06240406c5c0e7c3d7fa@[129.98.90.227]>
Date: Tue, 17 Feb 2009 18:06:09 -0500
To: Eric.Moore@lsi.com
From: Maurice Volaski <mvolaski@aecom.yu.edu>
Subject: mpt fusion driver crashes with LSI22320SE installed and BIOS ACPI
 turned off
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii" ; format="flowed"
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I emailed about this earlier and here's some new info: the crash 
occurs when ACPI is turned off. It appears that your driver is 
expecting information from ACPI and if it doesn't get it, it will 
crash. (This has been posted as bug 
http://bugzilla.kernel.org/show_bug.cgi?id=12733)

On a system with a Supermicro X7DWN+ with ACPI turned off, and an 
LSI22320SE card installed, the mptdriver will crash. Here is the 
relevant log:

Oct  5 21:19:54 localhost kernel: Fusion MPT SPI Host driver 3.04.07
Oct  5 21:19:54 localhost kernel: mptbase: ioc0: Initiating bringup
Oct  5 21:19:54 localhost kernel: [drm] Initialized radeon 1.29.0 
20080528 on minor 0
Oct  5 21:19:54 localhost kernel: ioc0: LSI53C1030 C0: 
Capabilities={Initiator,Target}
Oct  5 21:19:54 localhost kernel: scsi2 : ioc0: LSI53C1030 C0, 
FwRev=01033400h, Ports=1, MaxQ=255, IRQ=52
Oct  5 21:19:54 localhost kernel: mptbase: ioc1: Initiating bringup
Oct  5 21:19:54 localhost kernel: ioc1: LSI53C1030 C0: 
Capabilities={Initiator,Target}
Oct  5 21:19:54 localhost kernel: scsi3 : ioc1: LSI53C1030 C0, 
FwRev=01033400h, Ports=1, MaxQ=255, IRQ=52
Oct  5 21:19:54 localhost kernel: device-mapper: multipath: version 
1.0.5 loaded
Oct  5 21:19:54 localhost kernel: EXT3 FS on dm-0, internal journal
Oct  5 21:19:54 localhost kernel: mptscsih: ioc1: attempting task 
abort! (sc=f5aca500)
Oct  5 21:19:54 localhost kernel: scsi 3:0:4:0: CDB: Inquiry: 12 00 00 00 24 00
Oct  5 21:19:54 localhost kernel: mptbase: ioc1: Initiating recovery
Oct  5 21:19:54 localhost kernel: scsi 3:0:4:0: mptscsih: ioc1: 
completing cmds: fw_channel 0, fw_id 4, sc=f5aca500, mf = f48e3160, 
idx=19
Oct  5 21:19:54 localhost kernel: mptscsih: ioc1: Issue of TaskMgmt failed!
Oct  5 21:19:54 localhost kernel: mptscsih: ioc1: task abort: FAILED 
(sc=f5aca500)
Oct  5 21:19:54 localhost kernel: mptscsih: ioc1: attempting target 
reset! (sc=f5aca500)
Oct  5 21:19:54 localhost kernel: scsi 3:0:4:0: CDB: Inquiry: 12 00 00 00 24 00
Oct  5 21:19:54 localhost kernel: mptbase: ioc1: Initiating recovery
Oct  5 21:19:54 localhost kernel: mptscsih: ioc1: Issue of TaskMgmt failed!
Oct  5 21:19:54 localhost kernel: mptscsih: ioc1: target reset: 
FAILED (sc=f5aca500)
Oct  5 21:19:54 localhost kernel: mptscsih: ioc1: attempting bus 
reset! (sc=f5aca500)
Oct  5 21:19:54 localhost kernel: scsi 3:0:4:0: CDB: Inquiry: 12 00 00 00 24 00
Oct  5 21:19:54 localhost kernel: scsi target3:0:4: mptspi: ioc1: 
mpt_config failed
Oct  5 21:19:54 localhost kernel: scsi target3:0:4: FAST-5 WIDE SCSI 
3.4 MB/s ST QAS RDSTRM WRFLOW (572 ns, offset 133)
Oct  5 21:19:54 localhost kernel: mptbase: ioc1: Initiating recovery

and

Oct  5 21:19:54 localhost kernel: mptscsih: ioc1: Issue of TaskMgmt failed!
Oct  5 21:19:54 localhost kernel: mptscsih: ioc1: bus reset: FAILED 
(sc=f5aca500)
Oct  5 21:19:54 localhost kernel: mptscsih: ioc1: attempting host 
reset! (sc=f5aca500)
Oct  5 21:19:54 localhost kernel: mptbase: ioc1: Initiating recovery
Oct  5 21:19:54 localhost kernel: scsi target3:0:4: mptspi: ioc1: 
mpt_config failed
Oct  5 21:19:54 localhost kernel: scsi target3:0:4: mptspi: ioc1: 
mpt_config failed
Oct  5 21:19:54 localhost kernel: scsi target3:0:4: FAST-5 WIDE SCSI 
3.4 MB/s ST QAS RDSTRM WRFLOW (572 ns, offset 133)
Oct  5 21:19:54 localhost kernel: scsi target3:0:4: mptspi: ioc1: 
mpt_config failed
Oct  5 21:19:54 localhost kernel: scsi target3:0:4: mptspi: ioc1: 
mpt_config failed
Oct  5 21:19:54 localhost kernel: scsi target3:0:4: FAST-5 WIDE SCSI 
3.4 MB/s ST QAS RDSTRM WRFLOW (572 ns, offset 133)
Oct  5 21:19:54 localhost kernel: scsi target3:0:4: mptspi: ioc1: 
mpt_config failed
-- 

Maurice Volaski, mvolaski@aecom.yu.edu
Computing Support, Rose F. Kennedy Center
Albert Einstein College of Medicine of Yeshiva University
