Return-Path: <linux-kernel-owner+w=401wt.eu-S1758895AbZAXSnk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758895AbZAXSnk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Jan 2009 13:43:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759080AbZAXSnW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Jan 2009 13:43:22 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:57561 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758216AbZAXSnV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Jan 2009 13:43:21 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Sat, 24 Jan 2009 19:43:13 +0100 (CET)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH 3/7] ieee1394: sbp2: fix payload limit at S1600 and S3200
To: linux1394-devel@lists.sourceforge.net
cc: linux-kernel@vger.kernel.org
In-Reply-To: <tkrat.6fe4fe5b72231863@s5r6.in-berlin.de>
Message-ID: <tkrat.20255ef8a2eef9ab@s5r6.in-berlin.de>
References: <tkrat.6fe4fe5b72231863@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

1394-2008 clause 16.3.4.1 (1394b-2002 clause 16.3.1.1) defines tighter
limits than 1394-2008 clause 6.2.2.3 (1394a-2000 clause 6.2.2.3).

Our previously too large limit doesn't matter though if the controller
reports its max_receive correctly.

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 drivers/ieee1394/sbp2.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux/drivers/ieee1394/sbp2.c
===================================================================
--- linux.orig/drivers/ieee1394/sbp2.c
+++ linux/drivers/ieee1394/sbp2.c
@@ -256,7 +256,7 @@ static int sbp2_set_busy_timeout(struct 
 static int sbp2_max_speed_and_size(struct sbp2_lu *);
 
 
-static const u8 sbp2_speedto_max_payload[] = { 0x7, 0x8, 0x9, 0xA, 0xB, 0xC };
+static const u8 sbp2_speedto_max_payload[] = { 0x7, 0x8, 0x9, 0xa, 0xa, 0xa };
 
 static DEFINE_RWLOCK(sbp2_hi_logical_units_lock);
 

-- 
Stefan Richter
-=====-==--= ---= ==---
http://arcgraph.de/sr/

