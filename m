Return-Path: <linux-kernel-owner+w=401wt.eu-S1755086AbXHZUPu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755086AbXHZUPu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Aug 2007 16:15:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752776AbXHZUPm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Aug 2007 16:15:42 -0400
Received: from mx2.rz.ruhr-uni-bochum.de ([134.147.64.30]:39502 "HELO
	mx2.rz.ruhr-uni-bochum.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752660AbXHZUPl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Aug 2007 16:15:41 -0400
X-Greylist: delayed 401 seconds by postgrey-1.27 at vger.kernel.org; Sun, 26 Aug 2007 16:15:40 EDT
Subject: Problems with disc-performance and libata
From: Oliver Janscheidt <oliver.janscheidt@rub.de>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain
Date: Sun, 26 Aug 2007 22:08:57 +0200
Message-Id: <1188158937.6896.4.camel@WG4>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I'm using a Lenovo Thinkpad with TOSHIBA MK1234GS HD and MATSHITA
DVD-RAM UJ-850 on 82801GBM/GHM (ICH7 Family) Serial ATA Storage
Controller IDE. The Kernel is a 2.6.22.1 from Kernel.org (with 2.6.23-rc1- 
and hdaps-queue-freezing-patch).

sudo hdparm -t /dev/scd0 gives 

Timing buffered disk reads:    2 MB in  4.47 seconds = 457.75 kB/sec

sudo hdparm -t /dev/sda gives

Timing buffered disk reads:  102 MB in  3.04 seconds =  33.51 MB/sec

which is a quite poor performance and makes any streaming impossible.
Obviously UDMA is working correctly as dmesg | grep UDMA says:

[   43.636590] ata1: SATA max UDMA/133 cmd 0xffffc20004612500 ctl
0x0000000000000000 bmdma 0x0000000000000000 irq 314
[   43.636595] ata2: SATA max UDMA/133 cmd 0xffffc20004612580 ctl
0x0000000000000000 bmdma 0x0000000000000000 irq 314
[   43.636599] ata3: SATA max UDMA/133 cmd 0xffffc20004612600 ctl
0x0000000000000000 bmdma 0x0000000000000000 irq 314
[   43.636603] ata4: SATA max UDMA/133 cmd 0xffffc20004612680 ctl
0x0000000000000000 bmdma 0x0000000000000000 irq 314
[   44.177980] ata1.00: ATA-7: TOSHIBA MK1234GSX, AH002E, max UDMA/100
[   44.179192] ata1.00: configured for UDMA/100
[   44.326918] ata5: PATA max UDMA/133 cmd 0x00000000000101f0 ctl
0x00000000000103f6 bmdma 0x0000000000011880 irq 14
[   44.326922] ata6: PATA max UDMA/133 cmd 0x0000000000010170 ctl
0x0000000000010376 bmdma 0x0000000000011888 irq 15
[   44.571970] ata5.00: ATAPI: MATSHITADVD-RAM UJ-850, RB01, max UDMA/33
[   44.738552] ata5.00: configured for UDMA/33
[    0.610332] ata5.00: configured for UDMA/33
[    0.750296] ata1.00: configured for UDMA/100

Is there any solution for that problem or at least a workaround?

I also tried to recompile the kernel as recommended in the official
libata-faq ( http://linux-ata.org/faq.html ) but the system stuck when
booting the root-partition. Booting with combined_mode=libata or
combined_mode=ide didn't affect the performance, too.  

Thanks in advance,

Oli

