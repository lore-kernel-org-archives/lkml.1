Return-Path: <linux-kernel-owner+w=401wt.eu-S1753985AbYHWK0Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753985AbYHWK0Q (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Aug 2008 06:26:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752606AbYHWK0A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Aug 2008 06:26:00 -0400
Received: from smtp7-g19.free.fr ([212.27.42.64]:58069 "EHLO smtp7-g19.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752585AbYHWKZ7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Aug 2008 06:25:59 -0400
From: Jim Meyering <meyering@redhat.com>
To: Marcel Holtmann <holtmann@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, Sujith.Manoharan@atheros.com,
       linville@tuxdriver.com
Subject: [PATCH] ath9k: remove useless if-before-kfree; correct misleading indentation
In-Reply-To: <1219485762.7591.476.camel@violet.holtmann.net> (Marcel
	Holtmann's message of "Sat, 23 Aug 2008 12:02:42 +0200")
References: <87zln4rzce.fsf@rho.meyering.net>
	<1219485762.7591.476.camel@violet.holtmann.net>
Date: Sat, 23 Aug 2008 12:25:57 +0200
Message-ID: <87myj4rpsa.fsf_-_@rho.meyering.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


---
Marcel Holtmann <holtmann@linux.intel.com> wrote:
> Hi Jim
>
>> Alternatively, you could remove the nowadays-useless
>> "if-before-kfree" test and leave the sometimes-redundant
>> assignment as-is: unconditional.
>
> actually the later one is preferred. Just remove the NULL check.

I prefer it, too, but the indentation suggested that
adding braces would match the author's intent.

In case anyone is interested, I have been maintaining a patch
that removes *all* useless if-before-kfree tests.  I have not
posted it because such changes have a reputation for provoking
flames on this list, but now you've provoked me ;-)

    http://meyering.net/code/remove-useless-if-before-kfree.patch
     74 files changed, 127 insertions(+), 250 deletions(-)

Here's the alternative patch:

 drivers/net/wireless/ath9k/main.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath9k/main.c b/drivers/net/wireless/ath9k/main.c
index 2888778..6eb7ad7 100644
--- a/drivers/net/wireless/ath9k/main.c
+++ b/drivers/net/wireless/ath9k/main.c
@@ -1056,9 +1056,8 @@ void ath_tx_complete(struct ath_softc *sc, struct sk_buff *skb,
 	if (tx_info->flags & IEEE80211_TX_CTL_NO_ACK ||
 		tx_info->flags & IEEE80211_TX_STAT_TX_FILTERED) {
 		/* free driver's private data area of tx_info */
-		if (tx_info->driver_data[0] != NULL)
-			kfree(tx_info->driver_data[0]);
-			tx_info->driver_data[0] = NULL;
+		kfree(tx_info->driver_data[0]);
+		tx_info->driver_data[0] = NULL;
 	}

 	if (tx_status->flags & ATH_TX_BAR) {
-- 
1.6.0.90.g436ed

