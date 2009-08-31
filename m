Return-Path: <linux-kernel-owner+w=401wt.eu-S1754067AbZHaTe0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754067AbZHaTe0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Aug 2009 15:34:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753902AbZHaTe0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Aug 2009 15:34:26 -0400
Received: from mgw1.diku.dk ([130.225.96.91]:60154 "EHLO mgw1.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753301AbZHaTeZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Aug 2009 15:34:25 -0400
Date: Mon, 31 Aug 2009 21:34:25 +0200 (CEST)
From: Julia Lawall <julia@diku.dk>
To: Greg Kroah-Hartman <gregkh@suse.de>, devel@driverdev.osuosl.org,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH] drivers/staging/rtl8192e: Drop unnecessary NULL test
Message-ID: <Pine.LNX.4.64.0908312133430.17886@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

The result of container_of should not be NULL.  In particular, in this case
the argument to the enclosing function has passed though INIT_WORK, which
dereferences it, implying that its container cannot be NULL.

A simplified version of the semantic patch that makes this change is as
follows:
(http://www.emn.fr/x-info/coccinelle/)

// <smpl>
@@
identifier fn,work,x,fld;
type T;
expression E1,E2;
statement S;
@@

static fn(struct work_struct *work) {
  ... when != work = E1
  x = container_of(work,T,fld)
  ... when != x = E2
- if (x == NULL) S
  ...
}
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 drivers/staging/rtl8192e/r8192E_core.c         |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/rtl8192e/r8192E_core.c b/drivers/staging/rtl8192e/r8192E_core.c
index 681488b..d4fa654 100644
--- a/drivers/staging/rtl8192e/r8192E_core.c
+++ b/drivers/staging/rtl8192e/r8192E_core.c
@@ -1763,8 +1763,6 @@ static void rtl8192_qos_activate(struct work_struct * work)
 	u8  u1bAIFS;
 	u32 u4bAcParam;
         int i;
-        if (priv == NULL)
-                return;
 
         mutex_lock(&priv->mutex);
         if(priv->ieee80211->state != IEEE80211_LINKED)
