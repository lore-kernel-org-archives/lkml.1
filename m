Return-Path: <linux-kernel-owner+w=401wt.eu-S1754769AbZGLUPG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754769AbZGLUPG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Jul 2009 16:15:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754712AbZGLUOz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Jul 2009 16:14:55 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:59064 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753251AbZGLUOy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Jul 2009 16:14:54 -0400
Date: Sun, 12 Jul 2009 22:06:00 +0200 (CEST)
From: Julia Lawall <julia@diku.dk>
To: samuel@sortiz.org, irda-users@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH 5/5] net/irda: Drop unnecessary NULL test
Message-ID: <Pine.LNX.4.64.0907122205340.22658@ask.diku.dk>
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
 net/irda/irnet/irnet_irda.c         |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/net/irda/irnet/irnet_irda.c b/net/irda/irnet/irnet_irda.c
index cf9a4b5..49ed80d 100644
--- a/net/irda/irnet/irnet_irda.c
+++ b/net/irda/irnet/irnet_irda.c
@@ -21,8 +21,6 @@ static void irnet_ppp_disconnect(struct work_struct *work)
 	irnet_socket * self =
 		container_of(work, irnet_socket, disconnect_work);
 
-	if (self == NULL)
-		return;
 	/*
 	 * If we were connected, cleanup & close the PPP
 	 * channel, which will kill pppd (hangup) and the rest.
