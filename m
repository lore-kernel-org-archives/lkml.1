Return-Path: <linux-kernel-owner+w=401wt.eu-S1756528AbZBMLzH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756528AbZBMLzH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Feb 2009 06:55:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751818AbZBMLyz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Feb 2009 06:54:55 -0500
Received: from wine.ocn.ne.jp ([122.1.235.145]:52507 "EHLO smtp.wine.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751001AbZBMLyy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Feb 2009 06:54:54 -0500
To: frederik.deweerdt@xprog.eu, rjw@sisk.pl
Cc: linux-kernel@vger.kernel.org, kernel-testers@vger.kernel.org
Subject: Re: [Bug #12409] NULL pointer dereference at get_stats()
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <KTnguC9mFUC.A.VNB.TJRdJB@chimera>
	<cX2gZ6Cy9nC.A.N0B.pJRdJB@chimera>
	<20090121161828.GA2739@gambetta>
	<200902071133.AJJ09378.MOHLFFtOSOVQFJ@I-love.SAKURA.ne.jp>
In-Reply-To: <200902071133.AJJ09378.MOHLFFtOSOVQFJ@I-love.SAKURA.ne.jp>
Message-Id: <200902132054.HBF52153.QtLFVOJHSMOFOF@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.50 PL2]
X-Accept-Language: ja,en
Date: Fri, 13 Feb 2009 20:54:50 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Tetsuo Handa wrote:
> I think this bug will happen in native environment too.
> http://lkml.org/lkml/2009/1/4/349
> But due to driver initialization failure caused by "nolapic" option,
> I can't reach /sbin/init on native ThinkPad X60 environment.

I don't encounter NULL pointer dereference at get_stats() on native
environment, but I encounter another problem on native environment;
initialization of SATA device fails if "nolapic" is given.
I don't have specific reasons to give "nolapic" option. This problem was
found when I was trying to reproduce [Bug #12409] on native ThinkPad X60
environment.

 scsi0 : ahci
 scsi1 : ahci
 scsi2 : ahci
 scsi3 : ahci
 ata1: SATA max UDMA/133 abar m1024@0xee444400 port 0xee444500 irq 1275
 ata2: DUMMY
 ata3: DUMMY
 ata4: DUMMY
 Marking TSC unstable due to TSC halts in idle
 usb 3-6: new high speed USB device using ehci_hcd and address 2
 usb 3-6: configuration #1 chosen from 1 choice
 hub 3-6:1.0: USB hub found
 hub 3-6:1.0: 4 ports detected
 firewire_core: created device fw0: GUID 000ae40600522014, S400
 ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
 ata1.00: qc timeout (cmd 0xec)
 ata1.00: failed to IDENTIFY (I/O error, err_mask=0x4)
 ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
 ata1.00: qc timeout (cmd 0xec)
 ata1.00: failed to IDENTIFY (I/O error, err_mask=0x4)
 ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
 ata1.00: qc timeout (cmd 0xec)
 ata1.00: failed to IDENTIFY (I/O error, err_mask=0x4)
 ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)

Full log for 2.6.28.5 without "nolapic" option:
  http://I-love.SAKURA.ne.jp/tmp/dmesg-2.6.28.5-native.txt
Full log for 2.6.28.5 with "nolapic" option:
  http://I-love.SAKURA.ne.jp/tmp/dmesg-2.6.28.5-native-nolapic.txt

Full log for 2.6.27.16 without "nolapic" option:
  http://I-love.SAKURA.ne.jp/tmp/dmesg-2.6.27.16-native.txt
Full log for 2.6.27.16 with "nolapic" option:
  http://I-love.SAKURA.ne.jp/tmp/dmesg-2.6.27.16-native-nolapic.txt

Full log for 2.6.26.8 without "nolapic" option:
  http://I-love.SAKURA.ne.jp/tmp/dmesg-2.6.26.8-native.txt
Full log for 2.6.26.8 with "nolapic" option:
  http://I-love.SAKURA.ne.jp/tmp/dmesg-2.6.26.8-native-nolapic.txt

Config:
  http://I-love.SAKURA.ne.jp/tmp/config-2.6.27.16
  http://I-love.SAKURA.ne.jp/tmp/config-2.6.28.5

2.6.27.16 and 2.6.28.5 fail with this problem.
2.6.26.8 does not fail with this problem.

Regards.
