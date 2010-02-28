Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030341Ab0B1QOR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Feb 2010 11:14:17 -0500
Received: from gw1.transmode.se ([213.115.205.20]:46705 "EHLO gw1.transmode.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754422Ab0B1QOP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Feb 2010 11:14:15 -0500
From: Joakim Tjernlund <Joakim.Tjernlund@transmode.se>
To: Andrew Morton <akpm@osdl.org>, linux-kernel@vger.kernel.org
Cc: Joakim Tjernlund <Joakim.Tjernlund@transmode.se>
Subject: [PATCH 1/2] inflate_fast: sout is already a short so ptr arith was off by one.
Date: Sun, 28 Feb 2010 17:06:02 +0100
Message-Id: <1267373163-10841-1-git-send-email-Joakim.Tjernlund@transmode.se>
X-Mailer: git-send-email 1.6.4.4
X-MIMETrack: Itemize by SMTP Server on sesr04/Transmode(Release 8.5.1|September 28, 2009) at
 2010-02-28 17:06:07,
	Serialize by Router on sesr04/Transmode(Release 8.5.1|September 28, 2009) at
 2010-02-28 17:06:07,
	Serialize complete at 2010-02-28 17:06:07
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This won't change anything for current code, but post increment
will break without this fix, should anyone want to try that.

Signed-off-by: Joakim Tjernlund <Joakim.Tjernlund@transmode.se>
---
 lib/zlib_inflate/inffast.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/lib/zlib_inflate/inffast.c b/lib/zlib_inflate/inffast.c
index fa62fc7..2c13ecc 100644
--- a/lib/zlib_inflate/inffast.c
+++ b/lib/zlib_inflate/inffast.c
@@ -286,7 +286,7 @@ void inflate_fast(z_streamp strm, unsigned start)
 		    } else { /* dist == 1 or dist == 2 */
 			unsigned short pat16;
 
-			pat16 = *(sout-2+2*OFF);
+			pat16 = *(sout-1+OFF);
 			if (dist == 1) {
 				union uu mm;
 				/* copy one char pattern to both bytes */
-- 
1.6.4.4

