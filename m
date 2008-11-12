Return-Path: <linux-kernel-owner+w=401wt.eu-S1756604AbYKLAiu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756604AbYKLAiu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2008 19:38:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753813AbYKLA0q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Nov 2008 19:26:46 -0500
Received: from kroah.org ([198.145.64.141]:42510 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753808AbYKLA0o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2008 19:26:44 -0500
Date: Tue, 11 Nov 2008 16:24:02 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk,
       Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
       Tomas Winkler <tomas.winkler@intel.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       "John W. Linville" <linville@tuxdriver.com>
Subject: [patch 33/49] iwlwifi: fix suspend to RAM in iwlwifi
Message-ID: <20081112002402.GH10989@kroah.com>
References: <20081112001401.926965113@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="iwlwifi-fix-suspend-to-ram-in-iwlwifi.patch"
In-Reply-To: <20081112002215.GA10989@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Tomas Winkler <tomas.winkler@intel.com>

commit 10d0bd56966571d0324dfd9bbb8aa913a60bef5f upstream

This patch fixes suspend to RAM after by moving
notify_mac out of iwlwifi mutex

http://bugzilla.kernel.org/show_bug.cgi?id=11845

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Tested-by: Carlos R. Mafra <crmafra2@gmail.com>
Tested-by: Christian Borntraeger <borntraeger@de.ibm.com>
Cc: Rafael J. Wysocki <rjw@sisk.pl>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/wireless/iwlwifi/iwl-agn.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -2090,7 +2090,6 @@ static void iwl_alive_start(struct iwl_p
 		iwl4965_error_recovery(priv);
 
 	iwl_power_update_mode(priv, 1);
-	ieee80211_notify_mac(priv->hw, IEEE80211_NOTIFY_RE_ASSOC);
 
 	if (test_and_clear_bit(STATUS_MODE_PENDING, &priv->status))
 		iwl4965_set_mode(priv, priv->iw_mode);
@@ -2342,6 +2341,7 @@ static void iwl_bg_alive_start(struct wo
 	mutex_lock(&priv->mutex);
 	iwl_alive_start(priv);
 	mutex_unlock(&priv->mutex);
+	ieee80211_notify_mac(priv->hw, IEEE80211_NOTIFY_RE_ASSOC);
 }
 
 static void iwl4965_bg_rf_kill(struct work_struct *work)

-- 
