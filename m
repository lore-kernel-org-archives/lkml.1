Return-Path: <linux-kernel-owner+w=401wt.eu-S1756922AbZLODo1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756922AbZLODo1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Dec 2009 22:44:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754180AbZLODo0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Dec 2009 22:44:26 -0500
Received: from adelie.canonical.com ([91.189.90.139]:37621 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753897AbZLODo0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Dec 2009 22:44:26 -0500
From: Ike Panhc <ike.pan@canonical.com>
To: kernel-team@lists.ubuntu.com
Cc: stable@kernel.org, Wey-Yi Guy <wey-yi.w.guy@intel.com>,
       Tomas Winkler <tomas.winkler@intel.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 0/2] Fix iwl6000 does not work in 2.6.31 kernel
Date: Tue, 15 Dec 2009 11:44:15 +0800
Message-Id: <1260848655-5582-1-git-send-email-ike.pan@canonical.com>
X-Mailer: git-send-email 1.6.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

BugLink: http://bugs.launchpad.net/bugs/496496

User reports that the Ubuntu Karmic (2.6.31-14-generic) recognize the the PCI
id of iwl6000 series but can not scan for APs and not even to associate to AP.
We need two commits cherry-picked from mainline kernel to fix this problem.

Since we have only version 4 firmware for iwl6000 in the linux-firmware package.
We need to change the IWL6000_UCODE_API_MAX to v4 for driver to load version 4
firmware.

After fixing the firmware loading issue, the dmesg reports randomly command
timeout for RXON, Unifying RXON timing is necessary for iwl6000. One minor
conflict solved due to we still need sw_crypto in iwl-dev.h

Patches against linux-2.6.31.8 and Ubuntu-2.6.31-17.54 are listed below.

Ike Panhc (1):
  iwlwifi: unify iwl_setup_rxon_timing

Wey-Yi Guy (1):
  iwlwifi: change IWL6000_UCODE_API_MAX to v4

 drivers/net/wireless/iwlwifi/iwl-3945.c     |    1 +
 drivers/net/wireless/iwlwifi/iwl-6000.c     |    4 +-
 drivers/net/wireless/iwlwifi/iwl-agn.c      |   64 -----------------------
 drivers/net/wireless/iwlwifi/iwl-commands.h |   20 +++++++-
 drivers/net/wireless/iwlwifi/iwl-core.c     |   59 +++++++++++++++++++++
 drivers/net/wireless/iwlwifi/iwl-core.h     |    1 +
 drivers/net/wireless/iwlwifi/iwl-dev.h      |    1 +
 drivers/net/wireless/iwlwifi/iwl3945-base.c |   74 +--------------------------
 8 files changed, 84 insertions(+), 140 deletions(-)

