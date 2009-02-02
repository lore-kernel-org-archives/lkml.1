Return-Path: <linux-kernel-owner+w=401wt.eu-S1757695AbZBBSqT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757695AbZBBSqT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Feb 2009 13:46:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753472AbZBBSqE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Feb 2009 13:46:04 -0500
Received: from mga11.intel.com ([192.55.52.93]:35318 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753016AbZBBSqD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Feb 2009 13:46:03 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.37,366,1231142400"; 
   d="scan'208";a="427467040"
Subject: Re: [possible BUG] PM suspend warning in 2.6.29-rc3-00227-gf1dd849
From: reinette chatre <reinette.chatre@intel.com>
To: Ming Lei <tom.leiming@gmail.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux-kernel <linux-kernel@vger.kernel.org>,
       "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <d82e647a0902020614q4f772816s7a6c8d143fd58662@mail.gmail.com>
References: <d82e647a0902010634o1b4e4075m7d38365f605d3c31@mail.gmail.com>
	 <200902012208.40758.rjw@sisk.pl>
	 <d82e647a0902020614q4f772816s7a6c8d143fd58662@mail.gmail.com>
Content-Type: text/plain
Date: Mon, 02 Feb 2009 10:49:15 -0800
Message-Id: <1233600555.2411.158.camel@rc-desk>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ming,

On Mon, 2009-02-02 at 06:14 -0800, Ming Lei wrote:
> After applying your patch, following is the dmesg output, so it is the
> iwl3945 driver that does not save pci state.

Could you please test with the patch below?

Thank you

diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c
b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index 95d0198..5b44d32 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -8143,6 +8143,7 @@ static int iwl3945_pci_suspend(struct pci_dev
*pdev, pm_message_t state)
 		priv->is_open = 1;
 	}
 
+	pci_save_state(pdev);
 	pci_set_power_state(pdev, PCI_D3hot);
 
 	return 0;
@@ -8153,6 +8154,7 @@ static int iwl3945_pci_resume(struct pci_dev
*pdev)
 	struct iwl3945_priv *priv = pci_get_drvdata(pdev);
 
 	pci_set_power_state(pdev, PCI_D0);
+	pci_restore_state(pdev);
 
 	if (priv->is_open)
 		iwl3945_mac_start(priv->hw);




