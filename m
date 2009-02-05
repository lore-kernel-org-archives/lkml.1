Return-Path: <linux-kernel-owner+w=401wt.eu-S1758853AbZBERBQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758853AbZBERBQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Feb 2009 12:01:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753928AbZBERA4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Feb 2009 12:00:56 -0500
Received: from charlotte.tuxdriver.com ([70.61.120.58]:58973 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753175AbZBERAy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Feb 2009 12:00:54 -0500
Date: Thu, 5 Feb 2009 11:58:38 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: davem@davemloft.net
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: pull request: wireless-2.6 2009-02-05
Message-ID: <20090205165837.GB4638@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dave,

A couple of small fixes for iwlwifi intended for 2.6.29.  One of them
will conflict when it is pulled into net-next-2.6 -- just take all the
hunks.

Please let me know if there are problems!

John

---

Individual patches are available here:

	http://www.kernel.org/pub/linux/kernel/people/linville/wireless-2.6/

---

The following changes since commit 55128bc23e9ab44e97f81f6cd349035230ee59a6:
  Randy Dunlap (1):
        sunrpc: fix rdma dependencies

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/linville/wireless-2.6.git master

Reinette Chatre (2):
      iwlwifi: clean key table in iwl_clear_stations_table
      iwlwifi: save PCI state before suspend, restore after resume

 drivers/net/wireless/iwlwifi/iwl-agn.c      |    2 ++
 drivers/net/wireless/iwlwifi/iwl-sta.c      |    3 +++
 drivers/net/wireless/iwlwifi/iwl3945-base.c |    2 ++
 3 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index b35c881..c01ea48 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -4042,6 +4042,7 @@ static int iwl_pci_suspend(struct pci_dev *pdev, pm_message_t state)
 		priv->is_open = 1;
 	}
 
+	pci_save_state(pdev);
 	pci_set_power_state(pdev, PCI_D3hot);
 
 	return 0;
@@ -4052,6 +4053,7 @@ static int iwl_pci_resume(struct pci_dev *pdev)
 	struct iwl_priv *priv = pci_get_drvdata(pdev);
 
 	pci_set_power_state(pdev, PCI_D0);
+	pci_restore_state(pdev);
 
 	if (priv->is_open)
 		iwl_mac_start(priv->hw);
diff --git a/drivers/net/wireless/iwlwifi/iwl-sta.c b/drivers/net/wireless/iwlwifi/iwl-sta.c
index 412f66b..70a8b21 100644
--- a/drivers/net/wireless/iwlwifi/iwl-sta.c
+++ b/drivers/net/wireless/iwlwifi/iwl-sta.c
@@ -480,6 +480,9 @@ void iwl_clear_stations_table(struct iwl_priv *priv)
 	priv->num_stations = 0;
 	memset(priv->stations, 0, sizeof(priv->stations));
 
+	/* clean ucode key table bit map */
+	priv->ucode_key_table = 0;
+
 	spin_unlock_irqrestore(&priv->sta_lock, flags);
 }
 EXPORT_SYMBOL(iwl_clear_stations_table);
diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index 95d0198..5b44d32 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -8143,6 +8143,7 @@ static int iwl3945_pci_suspend(struct pci_dev *pdev, pm_message_t state)
 		priv->is_open = 1;
 	}
 
+	pci_save_state(pdev);
 	pci_set_power_state(pdev, PCI_D3hot);
 
 	return 0;
@@ -8153,6 +8154,7 @@ static int iwl3945_pci_resume(struct pci_dev *pdev)
 	struct iwl3945_priv *priv = pci_get_drvdata(pdev);
 
 	pci_set_power_state(pdev, PCI_D0);
+	pci_restore_state(pdev);
 
 	if (priv->is_open)
 		iwl3945_mac_start(priv->hw);
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
