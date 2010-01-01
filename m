Return-Path: <linux-kernel-owner+w=401wt.eu-S1751932Ab0AAR2k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751932Ab0AAR2k (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jan 2010 12:28:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751515Ab0AAR2j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jan 2010 12:28:39 -0500
Received: from astoria.ccjclearline.com ([64.235.106.9]:35969 "EHLO
	astoria.ccjclearline.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751468Ab0AAR2i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jan 2010 12:28:38 -0500
Date: Fri, 1 Jan 2010 12:28:03 -0500 (EST)
From: "Robert P. J. Day" <rpjday@crashcourse.ca>
X-X-Sender: rpjday@localhost
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH] HVSI: Fix apparently backwards args to time_before() in
 hvsi.c
Message-ID: <alpine.LFD.2.00.1001011226020.24958@localhost>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - astoria.ccjclearline.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - crashcourse.ca
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Robert P. J. Day <rpjday@crashcourse.ca>

---

  no appropriate subsystem maintainer listed in MAINTAINERS.

diff --git a/drivers/char/hvsi.c b/drivers/char/hvsi.c
index 793b236..71c0fcd 100644
--- a/drivers/char/hvsi.c
+++ b/drivers/char/hvsi.c
@@ -711,7 +711,7 @@ static void hvsi_drain_input(struct hvsi_struct *hp)
 	uint8_t buf[HVSI_MAX_READ] __ALIGNED__;
 	unsigned long end_jiffies = jiffies + HVSI_TIMEOUT;

-	while (time_before(end_jiffies, jiffies))
+	while (time_before(jiffies, end_jiffies))
 		if (0 == hvsi_read(hp, buf, HVSI_MAX_READ))
 			break;
 }

rday
--

========================================================================
Robert P. J. Day                               Waterloo, Ontario, CANADA

            Linux Consulting, Training and Kernel Pedantry.

Web page:                                          http://crashcourse.ca
Twitter:                                       http://twitter.com/rpjday
========================================================================
