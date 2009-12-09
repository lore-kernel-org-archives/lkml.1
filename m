Return-Path: <linux-kernel-owner+w=401wt.eu-S1757410AbZLITYK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757410AbZLITYK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Dec 2009 14:24:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757364AbZLITYG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Dec 2009 14:24:06 -0500
Received: from mgw2.diku.dk ([130.225.96.92]:54067 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754071AbZLITYE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Dec 2009 14:24:04 -0500
Date: Wed, 9 Dec 2009 20:24:09 +0100 (CET)
From: Julia Lawall <julia@diku.dk>
To: Alessandro Zummo <a.zummo@towertech.it>,
       Paul Gortmaker <p_gortmaker@yahoo.com>, rtc-linux@googlegroups.com,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH 6/12] drivers/rtc: Correct size given to memset
Message-ID: <Pine.LNX.4.64.0912092023500.1870@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

Memset should be given the size of the structure, not the size of the pointer.

The semantic patch that makes this change is as follows:
(http://coccinelle.lip6.fr/)

// <smpl>
@@
type T;
T *x;
expression E;
@@

memset(x, E, sizeof(
+ *
 x))
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 drivers/rtc/rtc-at91sam9.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -u -p a/drivers/rtc/rtc-at91sam9.c b/drivers/rtc/rtc-at91sam9.c
--- a/drivers/rtc/rtc-at91sam9.c
+++ b/drivers/rtc/rtc-at91sam9.c
@@ -161,7 +161,7 @@ static int at91_rtc_readalarm(struct dev
 	if (offset == 0)
 		return -EILSEQ;
 
-	memset(alrm, 0, sizeof(alrm));
+	memset(alrm, 0, sizeof(*alrm));
 	if (alarm != ALARM_DISABLED && offset != 0) {
 		rtc_time_to_tm(offset + alarm, tm);
 
