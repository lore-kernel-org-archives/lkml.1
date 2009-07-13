Return-Path: <linux-kernel-owner+w=401wt.eu-S1755356AbZGMKKi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755356AbZGMKKi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jul 2009 06:10:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755301AbZGMKKh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Jul 2009 06:10:37 -0400
Received: from mgw1.diku.dk ([130.225.96.91]:55083 "EHLO mgw1.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755322AbZGMKKg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jul 2009 06:10:36 -0400
Date: Mon, 13 Jul 2009 12:10:32 +0200 (CEST)
From: Julia Lawall <julia@diku.dk>
To: samuel@sortiz.org, irda-users@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH 2/2] net/irda/ircomm: Drop unnecessary NULL test
Message-ID: <Pine.LNX.4.64.0907131210070.6808@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

The result of container_of should not be NULL.  In particular, in this case
the argument to the enclosing function has passed though INIT_WORK,
which dereferences it, implying that its container cannot be NULL.

The semantic match that finds this problem is as follows:
(http://www.emn.fr/x-info/coccinelle/)

// <smpl>
@@
expression x,e;
@@

x = container_of(...)
... when != x = e
* x == NULL
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 net/irda/ircomm/ircomm_tty.c        |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/irda/ircomm/ircomm_tty.c b/net/irda/ircomm/ircomm_tty.c
index 811984d..6306c19 100644
--- a/net/irda/ircomm/ircomm_tty.c
+++ b/net/irda/ircomm/ircomm_tty.c
@@ -609,7 +609,7 @@ static void ircomm_tty_do_softint(struct work_struct *work)
 
 	IRDA_DEBUG(2, "%s()\n", __func__ );
 
-	if (!self || self->magic != IRCOMM_TTY_MAGIC)
+	if (self->magic != IRCOMM_TTY_MAGIC)
 		return;
 
 	tty = self->tty;
