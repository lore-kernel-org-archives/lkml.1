Return-Path: <linux-kernel-owner+w=401wt.eu-S933131AbZJFUbD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933131AbZJFUbD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 16:31:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756546AbZJFUbC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 16:31:02 -0400
Received: from ey-out-2122.google.com ([74.125.78.27]:41046 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755970AbZJFUbA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 16:31:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=cRFWfwuTrTktuikcVRMm4H8MEjycthNl25tMWCpSADOqK9pQehFjT+q/7giJu+yXdA
         Q/3Fscf5puN/wq5wDCfRxHrhCkvVMd5njPjz+nM0fcEBGCT7gHswGSBndpACs6pscQUN
         8w80LgumcbXC70g64CwR72EgL7+k13SyVvHj0=
Message-ID: <4ACBAACE.3050505@gmail.com>
Date: Tue, 06 Oct 2009 22:38:38 +0200
From: Roel Kluin <roel.kluin@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20090922 Fedora/3.0-2.7.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: Thomas Winischhofer <thomas@winischhofer.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] fbdev: TV_PALN bit set twice in sisfb_detect_VB_connect()
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The TV_PALN bit was tested twice, replace one by TV_PALM.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
diff --git a/drivers/video/sis/sis_main.c b/drivers/video/sis/sis_main.c
index a4e05e4..9d2b6bc 100644
--- a/drivers/video/sis/sis_main.c
+++ b/drivers/video/sis/sis_main.c
@@ -2115,7 +2115,7 @@ sisfb_detect_VB_connect(struct sis_video_info *ivideo)
 	   if( (!(ivideo->vbflags2 & VB2_SISBRIDGE)) &&
 	       (!((ivideo->sisvga_engine == SIS_315_VGA) &&
 			(ivideo->vbflags2 & VB2_CHRONTEL))) ) {
-	      if(ivideo->sisfb_tvstd & (TV_PALN | TV_PALN | TV_NTSCJ)) {
+	      if(ivideo->sisfb_tvstd & (TV_PALM | TV_PALN | TV_NTSCJ)) {
 		 ivideo->sisfb_tvstd = -1;
 		 printk(KERN_ERR "sisfb: PALM/PALN/NTSCJ not supported\n");
 	      }
