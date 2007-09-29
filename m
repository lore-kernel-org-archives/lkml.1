Return-Path: <linux-kernel-owner+w=401wt.eu-S1757545AbXI2RjU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757545AbXI2RjU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Sep 2007 13:39:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755870AbXI2RjN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Sep 2007 13:39:13 -0400
Received: from sirius.lasnet.de ([62.75.240.18]:60770 "EHLO sirius.lasnet.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755713AbXI2RjM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Sep 2007 13:39:12 -0400
X-Greylist: delayed 3067 seconds by postgrey-1.27 at vger.kernel.org; Sat, 29 Sep 2007 13:39:12 EDT
From: Jan Luebbe <jluebbe@lasnet.de>
To: linux-kernel@vger.kernel.org
Cc: torvalds@linux-foundation.org
Content-Type: text/plain; charset=UTF-7
Date: Sat, 29 Sep 2007 18:47:51 +0200
Message-Id: <1191084471.24185.11.camel@polaris>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 
Content-Transfer-Encoding: 7bit
Subject: [PATCH] fix console change race exposed by CFS
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jan L+APw-bbe +ADw-jluebbe+AEA-lasnet.de+AD4

The new behaviour of CFS exposes a race which occurs if a switch is
requested when vt+AF8-mode.mode is VT+AF8-PROCESS.

The process with vc-+AD4-vt+AF8-pid is signaled before vc-+AD4-vt+AF8-newvt is set. This
causes the switch to fail when triggered by the monitoing process
because the target is still -1.

Signed-off-by: Jan L+APw-bbe +ADw-jluebbe+AEA-lasnet.de+AD4
---
Index: linux-2.6.22/drivers/char/vt+AF8-ioctl.c
+AD0APQA9AD0APQA9AD0APQA9AD0APQA9AD0APQA9AD0APQA9AD0APQA9AD0APQA9AD0APQA9AD0APQA9AD0APQA9AD0APQA9AD0APQA9AD0APQA9AD0APQA9AD0APQA9AD0APQA9AD0APQA9AD0APQA9AD0APQA9AD0APQA9AD0APQA9AD0
--- linux-2.6.22.orig/drivers/char/vt+AF8-ioctl.c
+-+-+- linux-2.6.22/drivers/char/vt+AF8-ioctl.c
+AEAAQA -1208,15 +-1208,18 +AEAAQA
 		/+ACo
 		 +ACo Send the signal as privileged - kill+AF8-pid() will
 		 +ACo tell us if the process has gone or something else
-		 +ACo is awry
+-		 +ACo is awry.
+-		 +ACo
+-		 +ACo We need to set vt+AF8-newvt +ACo-before+ACo sending the signal or we
+-		 +ACo have a race.
 		 +ACo-/
+-		vc-+AD4-vt+AF8-newvt +AD0 new+AF8-vc-+AD4-vc+AF8-num+ADs
 		if (kill+AF8-pid(vc-+AD4-vt+AF8-pid, vc-+AD4-vt+AF8-mode.relsig, 1) +AD0APQ 0) +AHs
 			/+ACo
 			 +ACo It worked. Mark the vt to switch to and
 			 +ACo return. The process needs to send us a
 			 +ACo VT+AF8-RELDISP ioctl to complete the switch.
 			 +ACo-/
-			vc-+AD4-vt+AF8-newvt +AD0 new+AF8-vc-+AD4-vc+AF8-num+ADs
 			return+ADs
 		+AH0


