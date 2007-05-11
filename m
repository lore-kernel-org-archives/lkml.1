Return-Path: <linux-kernel-owner+w=401wt.eu-S1758546AbXEKD7u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758546AbXEKD7u (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 23:59:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753329AbXEKD7n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 23:59:43 -0400
Received: from static-71-162-243-5.phlapa.fios.verizon.net ([71.162.243.5]:45334
	"EHLO grelber.thyrsus.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752994AbXEKD7n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 23:59:43 -0400
From: Rob Landley <rob@landley.net>
To: linux-kernel@vger.kernel.org
Subject: 2.6.21 broke arm scsi on qemu -M volatilepb
Date: Thu, 10 May 2007 23:59:10 -0400
User-Agent: KMail/1.9.1
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705102359.11315.rob@landley.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Booting a 2.6.20 kernel under qemu works fine and gets me to a shell prompt, 
but booting a 2.6.21.1 kernel cycles endlessly on scsi, going:

Loading iSCSI transport class v2.0-724.
PCI: enabling device 0000:00:0c.0 (0140 -> 0143)
sym0: <895a> rev 0x0 at pci 0000:00:0c.0 irq 0
sym0: No NVRAM, ID 7, Fast-40, LVD, parity checking
sym0: SCSI BUS has been reset.
scsi0 : sym-2.2.3
scsi 0:0:0:0: ABORT operation started.
scsi 0:0:0:0: ABORT operation timed-out.
scsi 0:0:0:0: DEVICE RESET operation started.
scsi 0:0:0:0: DEVICE RESET operation timed-out.
scsi 0:0:0:0: BUS RESET operation started.
scsi 0:0:0:0: BUS RESET operation timed-out.
scsi 0:0:0:0: HOST RESET operation started.
sym0: SCSI BUS has been reset.
...
And so on.

If you're interested in reproducing this, download the most recent 
http://landley.net/hg/firmware snapshot (links up top), run "./build.sh 
armv4l", and when that's done "cd build" and "./run-armv4l.sh".

Is this a known issue?  A quick google for "arm scsi 2.6.21" didn't turn up 
anything relevant...

Rob
