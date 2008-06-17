Return-Path: <linux-kernel-owner+w=401wt.eu-S1760000AbYFQWbo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760000AbYFQWbo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2008 18:31:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758622AbYFQWbf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jun 2008 18:31:35 -0400
Received: from smtp6.pp.htv.fi ([213.243.153.40]:50734 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758553AbYFQWbc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2008 18:31:32 -0400
Date: Wed, 18 Jun 2008 01:30:05 +0300
From: Adrian Bunk <bunk@kernel.org>
To: dmitry.torokhov@gmail.com
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [2.6 patch] input/serio/hil_mlc.c: make code static
Message-ID: <20080617223005.GC25911@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

 drivers/input/serio/hil_mlc.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

2666f2e78ff94da848dadf01279e89a0ba459aa8 diff --git a/drivers/input/serio/hil_mlc.c b/drivers/input/serio/hil_mlc.c
index 93a1a6b..37586a6 100644
--- a/drivers/input/serio/hil_mlc.c
+++ b/drivers/input/serio/hil_mlc.c
@@ -76,7 +76,7 @@ static struct timer_list	hil_mlcs_kicker;
 static int			hil_mlcs_probe;
 
 static void hil_mlcs_process(unsigned long unused);
-DECLARE_TASKLET_DISABLED(hil_mlcs_tasklet, hil_mlcs_process, 0);
+static DECLARE_TASKLET_DISABLED(hil_mlcs_tasklet, hil_mlcs_process, 0);
 
 
 /* #define HIL_MLC_DEBUG */
@@ -459,7 +459,7 @@ static int hilse_operate(hil_mlc *mlc, int repoll)
 #define OUT_LAST(pack) \
 { HILSE_OUT_LAST,	{ .packet = pack }, 0, 0, 0, 0 },
 
-const struct hilse_node hil_mlc_se[HILSEN_END] = {
+static const struct hilse_node hil_mlc_se[HILSEN_END] = {
 
 	/* 0  HILSEN_START */
 	FUNC(hilse_init_lcv, 0,	HILSEN_NEXT,	HILSEN_SLEEP,	0)
@@ -784,7 +784,7 @@ static void hil_mlcs_process(unsigned long unused)
 
 /************************* Keepalive timer task *********************/
 
-void hil_mlcs_timer(unsigned long data)
+static void hil_mlcs_timer(unsigned long data)
 {
 	hil_mlcs_probe = 1;
 	tasklet_schedule(&hil_mlcs_tasklet);

