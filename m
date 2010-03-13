Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934934Ab0CMAUT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Mar 2010 19:20:19 -0500
Received: from kroah.org ([198.145.64.141]:60598 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934780Ab0CMATo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Mar 2010 19:19:44 -0500
X-Mailbox-Line: From gregkh@kvm.kroah.org Fri Mar 12 16:15:06 2010
Message-Id: <20100313001506.751921078@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Fri, 12 Mar 2010 16:11:56 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       "John W. Linville" <linville@tuxdriver.com>
Subject: [patch 018/123] ath9k: fix keycache leak in split tkip case
In-Reply-To: <20100313001618.GA9811@kroah.com>
In-Reply-To: <20100313001618.GA9811@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-stable review patch.  If anyone has any objections, please let me know.

-----------------

From: Ming Lei <tom.leiming@gmail.com>

commit 733da37dab72de6b3f8b0c56b5cdea322f18a684 upstream.

If split tkip key is used, ath_delete_key should delete
rx key and rx mic key. This patch fixes the leak of hw
keycache in the case.

Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/wireless/ath/ath9k/main.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -928,6 +928,7 @@ static void ath_key_delete(struct ath_co
 
 	clear_bit(key->hw_key_idx + 64, common->keymap);
 	if (common->splitmic) {
+		ath9k_hw_keyreset(ah, key->hw_key_idx + 32);
 		clear_bit(key->hw_key_idx + 32, common->keymap);
 		clear_bit(key->hw_key_idx + 64 + 32, common->keymap);
 	}


