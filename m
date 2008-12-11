Return-Path: <linux-kernel-owner+w=401wt.eu-S1759705AbYLKXBc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759705AbYLKXBc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2008 18:01:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759281AbYLKXAP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Dec 2008 18:00:15 -0500
Received: from fk-out-0910.google.com ([209.85.128.190]:46588 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758797AbYLKXAO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2008 18:00:14 -0500
Message-ID: <49419a31.0aa1660a.486c.07b8@mx.google.com>
To: netdev@vger.kernel.org
Cc: Karsten Keil <kkeil@suse.de>
Cc: linux-kernel@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org
Date: Thu, 11 Dec 2008 22:36:00 +0100
Subject: [PATCH 5/9][v2] mISDN: fix sparse warning: symbol 'nskb' shadows an earlier one
From: Hannes Eder <hannes@hanneseder.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: define first occurence of variable 'nskb' in inner most possible scope

Fix this sparse warning:

  drivers/isdn/mISDN/dsp_core.c:746:20: warning: symbol 'nskb' shadows an earlier one
  drivers/isdn/mISDN/dsp_core.c:634:19: originally declared here

Signed-off-by: Hannes Eder <hannes@hanneseder.net>
Acked-by: Karsten Keil <kkeil@suse.de>
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

