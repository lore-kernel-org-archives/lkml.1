Return-Path: <linux-kernel-owner+w=401wt.eu-S1752428AbZL0Oli@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752428AbZL0Oli (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Dec 2009 09:41:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752190AbZL0Oli
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Dec 2009 09:41:38 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:37437 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752042AbZL0Olh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Dec 2009 09:41:37 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=VbMCC9Z9aLOzRX/OJLZycFhiBXGD5mLx6Amx9R6MlMsbKLx6f0I4Ig2DZSuLisAIOU
         kiujSb+sZbOn0lFp8IX9lqHrsjR9tsiyqF6AKdORUWD955yuc7xFWc5jHHp913Rh/88x
         C1HdMA6Lm56P4rJGbA8JyMRutzmqmwQ9aks8Y=
Message-ID: <4B3772CA.80505@gmail.com>
Date: Sun, 27 Dec 2009 15:44:26 +0100
From: Roel Kluin <roel.kluin@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-4.fc12 Thunderbird/3.0
MIME-Version: 1.0
To: Tim Waugh <tim@cyberelk.net>, linux-parport@lists.infradead.org,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] paride: test off by one
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With `while (j++ < PX_SPIN)' j reaches PX_SPIN + 1 after the loop. This is
probably unlikely to produce a problem.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
 drivers/block/paride/pcd.c |    2 +-
 drivers/block/paride/pf.c  |    2 +-
 drivers/block/paride/pt.c  |    2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/block/paride/pcd.c b/drivers/block/paride/pcd.c
index 8866ca3..5b9b40b 100644
--- a/drivers/block/paride/pcd.c
+++ b/drivers/block/paride/pcd.c
@@ -341,7 +341,7 @@ static int pcd_wait(struct pcd_unit *cd, int go, int stop, char *fun, char *msg)
 	       && (j++ < PCD_SPIN))
 		udelay(PCD_DELAY);
 
-	if ((r & (IDE_ERR & stop)) || (j >= PCD_SPIN)) {
+	if ((r & (IDE_ERR & stop)) || (j > PCD_SPIN)) {
 		s = read_reg(cd, 7);
 		e = read_reg(cd, 1);
 		p = read_reg(cd, 2);
diff --git a/drivers/block/paride/pf.c b/drivers/block/paride/pf.c
index ea54ea3..8418a36 100644
--- a/drivers/block/paride/pf.c
+++ b/drivers/block/paride/pf.c
@@ -391,7 +391,7 @@ static int pf_wait(struct pf_unit *pf, int go, int stop, char *fun, char *msg)
 	       && (j++ < PF_SPIN))
 		udelay(PF_SPIN_DEL);
 
-	if ((r & (STAT_ERR & stop)) || (j >= PF_SPIN)) {
+	if ((r & (STAT_ERR & stop)) || (j > PF_SPIN)) {
 		s = read_reg(pf, 7);
 		e = read_reg(pf, 1);
 		p = read_reg(pf, 2);
diff --git a/drivers/block/paride/pt.c b/drivers/block/paride/pt.c
index 1e4006e..4fd99d9 100644
--- a/drivers/block/paride/pt.c
+++ b/drivers/block/paride/pt.c
@@ -274,7 +274,7 @@ static int pt_wait(struct pt_unit *tape, int go, int stop, char *fun, char *msg)
 	       && (j++ < PT_SPIN))
 		udelay(PT_SPIN_DEL);
 
-	if ((r & (STAT_ERR & stop)) || (j >= PT_SPIN)) {
+	if ((r & (STAT_ERR & stop)) || (j > PT_SPIN)) {
 		s = read_reg(pi, 7);
 		e = read_reg(pi, 1);
 		p = read_reg(pi, 2);
