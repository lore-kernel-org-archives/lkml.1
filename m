Return-Path: <linux-kernel-owner+w=401wt.eu-S1756422AbYLJQPm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756422AbYLJQPm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2008 11:15:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753999AbYLJQNr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Dec 2008 11:13:47 -0500
Received: from ug-out-1314.google.com ([66.249.92.171]:61502 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755445AbYLJQNq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2008 11:13:46 -0500
Message-ID: <493feab7.02a1660a.77b3.5168@mx.google.com>
To: Karsten Keil <kkeil@suse.de>
Cc: linux-kernel@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org
Date: Tue, 9 Dec 2008 21:39:48 +0100
Subject: [PATCH 5/9] mISDN: fix sparse warnings
From: Hannes Eder <hannes@hanneseder.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: define variable in the inner most possible scope

Fix this sparse warning:

  drivers/isdn/mISDN/dsp_core.c:746:20: warning: symbol 'nskb' shadows an earlier one
  drivers/isdn/mISDN/dsp_core.c:634:19: originally declared here

Signed-off-by: Hannes Eder <hannes@hanneseder.net>
---
 drivers/isdn/mISDN/dsp_core.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/isdn/mISDN/dsp_core.c b/drivers/isdn/mISDN/dsp_core.c
index 41af063..1dc21d8 100644
--- a/drivers/isdn/mISDN/dsp_core.c
+++ b/drivers/isdn/mISDN/dsp_core.c
@@ -631,7 +631,6 @@ dsp_function(struct mISDNchannel *ch,  struct sk_buff *skb)
 	int			ret = 0;
 	u8			*digits;
 	int			cont;
-	struct			sk_buff *nskb;
 	u_long			flags;
 
 	hh = mISDN_HEAD_P(skb);
@@ -690,6 +689,7 @@ dsp_function(struct mISDNchannel *ch,  struct sk_buff *skb)
 			digits = dsp_dtmf_goertzel_decode(dsp, skb->data,
 				skb->len, (dsp_options&DSP_OPT_ULAW)?1:0);
 			while (*digits) {
+				struct sk_buff *nskb;
 				if (dsp_debug & DEBUG_DSP_DTMF)
 					printk(KERN_DEBUG "%s: digit"
 					    "(%c) to layer %s\n",
-- 
1.5.6.3

