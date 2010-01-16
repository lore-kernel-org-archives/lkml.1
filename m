Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754055Ab0APP5V (ORCPT <rfc822;list-kernel77@spinics.net>);
	Sat, 16 Jan 2010 10:57:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753514Ab0APP5T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Jan 2010 10:57:19 -0500
Received: from mgw1.diku.dk ([130.225.96.91]:42620 "EHLO mgw1.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751627Ab0APP5S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jan 2010 10:57:18 -0500
Date: Sat, 16 Jan 2010 16:57:16 +0100 (CET)
From: Julia Lawall <julia@diku.dk>
To: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH 1/9] drivers/char: Eliminate useless code
Message-ID: <Pine.LNX.4.64.1001161656560.28745@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

The variable x is initialized twice to the same (side effect-free)
expression.  Drop one initialization.

A simplified version of the semantic match that finds this problem is:
(http://coccinelle.lip6.fr/)

// <smpl>
@forall@
idexpression *x;
identifier f!=ERR_PTR;
@@

x = f(...)
... when != x
(
x = f(...,<+...x...+>,...)
|
* x = f(...)
)
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 drivers/char/mmtimer.c              |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/char/mmtimer.c b/drivers/char/mmtimer.c
index 918711a..04fd0d8 100644
--- a/drivers/char/mmtimer.c
+++ b/drivers/char/mmtimer.c
@@ -546,9 +546,9 @@ static void mmtimer_tasklet(unsigned long data)
 {
 	int nodeid = data;
 	struct mmtimer_node *mn = &timers[nodeid];
-	struct mmtimer *x = rb_entry(mn->next, struct mmtimer, list);
+	struct mmtimer *x;
 	struct k_itimer *t;
 	unsigned long flags;
 
