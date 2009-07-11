Return-Path: <linux-kernel-owner+w=401wt.eu-S1758614AbZGKIcf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758614AbZGKIcf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Jul 2009 04:32:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756211AbZGKIc0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Jul 2009 04:32:26 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:55397 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753541AbZGKIc0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Jul 2009 04:32:26 -0400
Date: Sat, 11 Jul 2009 10:32:23 +0200 (CEST)
From: Julia Lawall <julia@diku.dk>
To: jirislaby@gmail.com, gregkh@suse.de, devel@driverdev.osuosl.org,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH 5/5, revised] staging/otus: Drop an unnecessary NULL test
Message-ID: <Pine.LNX.4.64.0907111031480.29592@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

Apparently, the NULL test is not necessary at this point.

The semantic patch that finds this problem is as follows:
(http://www.emn.fr/x-info/coccinelle/)

// <smpl>
@@
type T;
expression E;
identifier i,fld;
statement S;
@@

- T i = E->fld;
+ T i;
  ... when != E
      when != i
  if (E == NULL) S
+ i = E->fld;
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 drivers/staging/otus/wwrap.c |    5 -----
 1 file changed, 5 deletions(-)

diff --git a/drivers/staging/otus/wwrap.c b/drivers/staging/otus/wwrap.c
index 4db8f6e..855ff41 100644
--- a/drivers/staging/otus/wwrap.c
+++ b/drivers/staging/otus/wwrap.c
@@ -1018,11 +1018,6 @@ void kevent(struct work_struct *work)
                container_of(work, struct usbdrv_private, kevent);
     zdev_t *dev = macp->device;
 
-    if (macp == NULL)
-    {
-        return;
-    }
-
     if (test_and_set_bit(0, (void *)&smp_kevent_Lock))
     {
         //schedule_work(&macp->kevent);
