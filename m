Return-Path: <linux-kernel-owner+w=401wt.eu-S1754562AbZGVCAB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754562AbZGVCAB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jul 2009 22:00:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752354AbZGVCAA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Jul 2009 22:00:00 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:59637 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752034AbZGVCAA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jul 2009 22:00:00 -0400
Date: Wed, 22 Jul 2009 11:59:56 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: David Miller <davem@davemloft.net>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Samuel Ortiz <samuel.ortiz@intel.com>, Zhu Yi <yi.zhu@intel.com>,
       "John W. Linville" <linville@tuxdriver.com>
Subject: linux-next: manual merge of the net tree with the wireless-current
 tree
Message-Id: <20090722115956.482777b4.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.16.4; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi David,

Today's linux-next merge of the net tree got a conflict in
drivers/net/wireless/iwmc3200wifi/netdev.c between commit
513a2396d8e8327aff1ce50bea3fb4f16ff3455b ("iwmc3200wifi: fix NULL pointer
dereference in iwm_if_free") from the wireless-current tree and commit
3549716484a95fd16f7fcf8b68699bd4c803b382 ("iwmc3200wifi: cache keys when
interface is down") from the net tree.

Just context changes.   I fixed it up (see below) and can carry the fix
as necessary.
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/net/wireless/iwmc3200wifi/netdev.c
index aea5ccf,e94e969..0000000
--- a/drivers/net/wireless/iwmc3200wifi/netdev.c
+++ b/drivers/net/wireless/iwmc3200wifi/netdev.c
@@@ -151,8 -156,10 +156,10 @@@ void iwm_if_free(struct iwm_priv *iwm
  		return;
  
  	free_netdev(iwm_to_ndev(iwm));
 -	iwm_wdev_free(iwm);
  	iwm_priv_deinit(iwm);
 +	iwm_wdev_free(iwm);
+ 	kfree(iwm->umac_profile);
+ 	iwm->umac_profile = NULL;
  }
  
  int iwm_if_add(struct iwm_priv *iwm)
