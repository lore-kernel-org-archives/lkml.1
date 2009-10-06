Return-Path: <linux-kernel-owner+w=401wt.eu-S933574AbZJFWY0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933574AbZJFWY0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 18:24:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933468AbZJFWSz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 18:18:55 -0400
Received: from mail.pxnet.com ([195.227.45.7]:40988 "EHLO mail.pxnet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933252AbZJFWSx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 18:18:53 -0400
From: Tilman Schmidt <tilman@imap.cc>
Subject: [PATCH 2/4] isdn: accept CAPI Informational Info values as success
To: David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
CC: Karsten Keil <isdn@linux-pingi.de>, Karsten Keil <keil@b1-systems.de>,
       isdn4linux@listserv.isdn4linux.de, i4ldeveloper@listserv.isdn4linux.de
Message-ID: <20091006-patch-capi-2.tilman@imap.cc>
In-Reply-To: <20091006-patch-capi-0.tilman@imap.cc>
References: <20091006-patch-capi-0.tilman@imap.cc>
Date: Wed,  7 Oct 2009 00:18:05 +0200 (CEST)
X-Spam-Score: -2.137 () AWL,BAYES_00,RDNS_NONE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Info values in the 0x00xx range are defined in the CAPI standard
as "Informational, message processed successfully". Therefore a
CONNECT_B3_CONF message with an Info value in that range should
open an NCCI just as with Info==0.

Impact: minor bugfix
Signed-off-by: Tilman Schmidt <tilman@imap.cc>
Acked-by: Karsten Keil <keil@b1-systems.de>
---
 drivers/isdn/capi/capi.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/isdn/capi/capi.c b/drivers/isdn/capi/capi.c
index 2d83524..65bf91e 100644
--- a/drivers/isdn/capi/capi.c
+++ b/drivers/isdn/capi/capi.c
@@ -603,7 +603,7 @@ static void capi_recv_message(struct capi20_appl *ap, struct sk_buff *skb)
 
 	if (CAPIMSG_CMD(skb->data) == CAPI_CONNECT_B3_CONF) {
 		u16 info = CAPIMSG_U16(skb->data, 12); // Info field
-		if (info == 0) {
+		if ((info & 0xff00) == 0) {
 			mutex_lock(&cdev->ncci_list_mtx);
 			capincci_alloc(cdev, CAPIMSG_NCCI(skb->data));
 			mutex_unlock(&cdev->ncci_list_mtx);
-- 
1.6.2.1.214.ge986c

