Return-Path: <linux-kernel-owner+w=401wt.eu-S1760194AbXEOXAu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760194AbXEOXAu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2007 19:00:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758250AbXEOXAn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 May 2007 19:00:43 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:49561 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758271AbXEOXAn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2007 19:00:43 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Wed, 16 May 2007 01:00:35 +0200 (CEST)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH 1/3] ieee1394: raw1394: Fix read() for 32bit userland on 64bit
 kernel
To: Petr Vandrovec <petr@vandrovec.name>
cc: dan@dennedy.org, linux1394-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
In-Reply-To: <tkrat.a2f16b56bae46a1e@s5r6.in-berlin.de>
Message-ID: <tkrat.0e3c053d4bae6087@s5r6.in-berlin.de>
References: <20070507021447.GA22197@vana.vc.cvut.cz>
 <tkrat.a2f16b56bae46a1e@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Date: Mon, 7 May 2007 04:14:47 +0200
From: Petr Vandrovec <petr@vandrovec.name>

read() always failed with -EFAULT.  This was happening due to
raw1394_compat_read copying data to wrong location - access_ok always
failed as 'r' is kernel address, not user.  Whole function just tried to
copy data from 'r' to 'r', which is not good.

Signed-off-by: Petr Vandrovec <petr@vandrovec.name>
Acked-by: Dan Dennedy <dan@dennedy.org>
Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de> (split into 3 patches)
---
 drivers/ieee1394/raw1394.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6.22-rc1/drivers/ieee1394/raw1394.c
===================================================================
--- linux-2.6.22-rc1.orig/drivers/ieee1394/raw1394.c
+++ linux-2.6.22-rc1/drivers/ieee1394/raw1394.c
@@ -459,7 +459,7 @@ static const char __user *raw1394_compat
 static int
 raw1394_compat_read(const char __user *buf, struct raw1394_request *r)
 {
-	struct compat_raw1394_req __user *cr = (typeof(cr)) r;
+	struct compat_raw1394_req __user *cr = (typeof(cr)) buf;
 	if (!access_ok(VERIFY_WRITE, cr, sizeof(struct compat_raw1394_req)) ||
 	    P(type) ||
 	    P(error) ||

-- 
Stefan Richter
-=====-=-=== -=-= =----
http://arcgraph.de/sr/

