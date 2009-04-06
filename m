Return-Path: <linux-kernel-owner+w=401wt.eu-S1759382AbZDFPnu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759382AbZDFPnu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Apr 2009 11:43:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758222AbZDFPid
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Apr 2009 11:38:33 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:37958 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758328AbZDFPib (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Apr 2009 11:38:31 -0400
Date: Mon, 6 Apr 2009 17:38:24 +0200 (CEST)
From: Julia Lawall <julia@diku.dk>
To: thomas@winischhofer.net, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: [PATCH] drivers/video/sis: use the constant InterlaceMode
Message-ID: <Pine.LNX.4.64.0904061737430.20450@pc-004.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

Use the constant InterlaceMode rather than the magic number 0x0080.

The semantic patch that makes this change is as follows:
(http://www.emn.fr/x-info/coccinelle/)

// <smpl>
@r@
type T;
T E;
identifier fld;
identifier c;
@@

E->fld & c

@s@
constant C;
identifier r.c;
@@

#define c C

@@
r.T E;
identifier r.fld;
identifier r.c;
constant s.C;
@@

 E->fld &
- C
+ c
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 drivers/video/sis/initextlfb.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -u -p a/drivers/video/sis/initextlfb.c b/drivers/video/sis/initextlfb.c
--- a/drivers/video/sis/initextlfb.c 2008-12-07 19:29:06.000000000 +0100
+++ b/drivers/video/sis/initextlfb.c 2009-04-06 16:55:38.000000000 +0200
@@ -143,7 +143,7 @@ sisfb_mode_rate_to_ddata(struct SiS_Priv
        var->sync |= FB_SYNC_HOR_HIGH_ACT;
 
     var->vmode = FB_VMODE_NONINTERLACED;
-    if(SiS_Pr->SiS_RefIndex[RRTI].Ext_InfoFlag & 0x0080)
+    if (SiS_Pr->SiS_RefIndex[RRTI].Ext_InfoFlag & InterlaceMode)
        var->vmode = FB_VMODE_INTERLACED;
     else {
        j = 0;
