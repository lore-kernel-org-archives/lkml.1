Return-Path: <linux-kernel-owner+w=401wt.eu-S1751505AbZLTHKi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751505AbZLTHKi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Dec 2009 02:10:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751259AbZLTHKh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Dec 2009 02:10:37 -0500
Received: from mail.issp.bas.bg ([195.96.236.10]:57369 "EHLO mail.issp.bas.bg"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751224AbZLTHKg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Dec 2009 02:10:36 -0500
X-Greylist: delayed 368 seconds by postgrey-1.27 at vger.kernel.org; Sun, 20 Dec 2009 02:10:36 EST
From: Marin Mitov <mitov@issp.bas.bg>
Organization: Institute of Solid State Physics
To: David Airlie <airlied@linux.ie>
Subject: [PATCH]Silancing a false positive: "may be used uninitialized"
Date: Sun, 20 Dec 2009 09:03:27 +0200
User-Agent: KMail/1.11.4 (Linux/2.6.33-rc1; KDE/4.2.4; x86_64; ; )
Cc: Jesse Barnes <jesse.barnes@intel.com>, dri-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200912200903.28002.mitov@issp.bas.bg>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello all,

Silancing a false positive:
warning: 'width' may be used uninitialized in this function
drivers/gpu/drm/drm_edid.c

Signed-off-by: Marin Mitov <mitov@issp.bas.bg>
==========================================================================
--- a/drivers/gpu/drm/drm_edid.c	2009-12-20 07:43:57.000000000 +0200
+++ b/drivers/gpu/drm/drm_edid.c	2009-12-20 07:45:49.000000000 +0200
@@ -913,7 +913,7 @@
 	const int rates[] = { 60, 85, 75, 60, 50 };
 
 	for (i = 0; i < 4; i++) {
-		int width, height;
+		int uninitialized_var(width), height;
 		cvt = &(timing->data.other_data.data.cvt[i]);
 
 		height = (cvt->code[0] + ((cvt->code[1] & 0xf0) << 8) + 1) * 2;
