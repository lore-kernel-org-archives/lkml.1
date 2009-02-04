Return-Path: <linux-kernel-owner+w=401wt.eu-S1753939AbZBDMiz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753939AbZBDMiz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 07:38:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751341AbZBDMiq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 07:38:46 -0500
Received: from mail-ew0-f21.google.com ([209.85.219.21]:37852 "EHLO
	mail-ew0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751234AbZBDMiq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 07:38:46 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=dp2xVpE4t30xn8aRaeVH8xJTUAb44G8Xi6KoKPbyBUHihbWafQlYm3LNVWAHhPdwKt
         Mg4Am39j4z7/wb8x5VLz9epIwvlvU64xg/w0W5rEmgJlfO5SDEJh5502VbWuG/ByGok7
         soeH9s1heekN4ROCt2h7UHHbQwCIcCXE1YE88=
Date: Wed, 4 Feb 2009 15:38:37 +0300
From: Alexander Beregalov <a.beregalov@gmail.com>
To: Sathya Perla <sathyap@serverengines.com>,
       Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org
Subject: Staging: benet: convert netif_rx_* to napi_*
Message-ID: <20090204123837.GA12987@orion>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  *netif_rx_* functions were removed by 288379f ("net: Remove redundant NAPI
  functions")

Signed-off-by: Alexander Beregalov <a.beregalov@gmail.com>
---

 drivers/staging/benet/be_int.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/benet/be_int.c b/drivers/staging/benet/be_int.c
index cba95d0..38bf61c 100644
--- a/drivers/staging/benet/be_int.c
+++ b/drivers/staging/benet/be_int.c
@@ -717,7 +717,7 @@ int be_poll(struct napi_struct *napi, int budget)
 
 	/* All consumed */
 	if (work_done < budget) {
-		netif_rx_complete(napi);
+		napi_complete(napi);
 		/* enable intr */
 		be_notify_cmpl(pnob, work_done, pnob->rx_cq_id, 1);
 	} else {
@@ -752,7 +752,7 @@ static inline u32 process_events(struct be_net_object *pnob)
 		rid = AMAP_GET_BITS_PTR(EQ_ENTRY, ResourceID, eqp);
 		if (rid == pnob->rx_cq_id) {
 			adapter->be_stat.bes_rx_events++;
-			netif_rx_schedule(&pnob->napi);
+			napi_schedule(&pnob->napi);
 		} else if (rid == pnob->tx_cq_id) {
 			process_nic_tx_completions(pnob);
 		} else if (rid == pnob->mcc_cq_id) {
