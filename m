Return-Path: <linux-kernel-owner+w=401wt.eu-S1760065AbYGAPh4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760065AbYGAPh4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2008 11:37:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757342AbYGAPhf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jul 2008 11:37:35 -0400
Received: from smtp.eu.citrix.com ([62.200.22.115]:46944 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757058AbYGAPhe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2008 11:37:34 -0400
X-IronPort-AV: E=Sophos;i="4.27,732,1204502400"; 
   d="scan'208";a="836883"
Message-ID: <486A4F64.3050904@eu.citrix.com>
Date: Tue, 01 Jul 2008 16:38:12 +0100
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080505)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>
Subject: [PATCH 1 of 2] fbcon: bgcolor fix
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 01 Jul 2008 15:37:34.0220 (UTC) FILETIME=[61C604C0:01C8DB90]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The forth bit of the background color is the blink property bit, not the
intensity bit, as for the foreground color.
Therefore it shouldn't be included in the background color.

Signed-off-by: stefano.stabellini@eu.citrix.com

---
 drivers/video/console/fbcon.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/video/console/fbcon.h b/drivers/video/console/fbcon.h
index 0135e03..beb6a74 100644
--- a/drivers/video/console/fbcon.h
+++ b/drivers/video/console/fbcon.h
@@ -92,7 +92,7 @@ struct fbcon_ops {
 #define attr_fgcol(fgshift,s)    \
 	(((s) >> (fgshift)) & 0x0f)
 #define attr_bgcol(bgshift,s)    \
-	(((s) >> (bgshift)) & 0x0f)
+	(((s) >> (bgshift)) & 0x07)
 
 /* Monochrome */
 #define attr_bold(s) \
-- 
1.5.4.3
