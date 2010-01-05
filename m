Return-Path: <linux-kernel-owner+w=401wt.eu-S1754453Ab0AEAfx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754453Ab0AEAfx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jan 2010 19:35:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754409Ab0AEAfp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jan 2010 19:35:45 -0500
Received: from kroah.org ([198.145.64.141]:34422 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754398Ab0AEAfj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jan 2010 19:35:39 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Reinette Chatre <reinette.chatre@intel.com>,
       "John W. Linville" <linville@tuxdriver.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 57/97] iwlwifi: fix 40MHz operation setting on cards that do not allow it
Date: Mon,  4 Jan 2010 16:33:10 -0800
Message-Id: <1262651630-7354-57-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.6
In-Reply-To: <20100105003133.GA7199@kroah.com>
References: <20100105003133.GA7199@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Reinette Chatre <reinette.chatre@intel.com>

commit 6c3069b1e7e983e176a5f826e2edffefdd404a08 upstream.

Some devices have 40MHz operation disabled entirely. Ensure that driver do
not enable 40MHz operation if a channel does not allow this.

This fixes http://bugzilla.intellinuxwireless.org/show_bug.cgi?id=2135

Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/net/wireless/iwlwifi/iwl-eeprom.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-eeprom.c b/drivers/net/wireless/iwlwifi/iwl-eeprom.c
index 622b636..18dc3a4 100644
--- a/drivers/net/wireless/iwlwifi/iwl-eeprom.c
+++ b/drivers/net/wireless/iwlwifi/iwl-eeprom.c
@@ -711,7 +711,8 @@ static int iwl_mod_ht40_chan_info(struct iwl_priv *priv,
 	ch_info->ht40_min_power = 0;
 	ch_info->ht40_scan_power = eeprom_ch->max_power_avg;
 	ch_info->ht40_flags = eeprom_ch->flags;
-	ch_info->ht40_extension_channel &= ~clear_ht40_extension_channel;
+	if (eeprom_ch->flags & EEPROM_CHANNEL_VALID)
+		ch_info->ht40_extension_channel &= ~clear_ht40_extension_channel;
 
 	return 0;
 }
-- 
1.6.6

