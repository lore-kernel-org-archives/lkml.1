Return-Path: <linux-kernel-owner+w=401wt.eu-S1754929AbYKLAj6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754929AbYKLAj6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2008 19:39:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753842AbYKLA0u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Nov 2008 19:26:50 -0500
Received: from kroah.org ([198.145.64.141]:42552 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753843AbYKLA0t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2008 19:26:49 -0500
Date: Tue, 11 Nov 2008 16:24:09 -0800
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
       alan@lxorguk.ukuu.org.uk, Zhu Yi <yi.zhu@intel.com>,
       Tomas Winkler <tomas.winkler@intel.com>,
       Reinette Chatre <reinette.chatre@intel.com>,
       "John W. Linville" <linville@tuxdriver.com>
Subject: [patch 36/49] iwl3945: fix deadlock on suspend
Message-ID: <20081112002409.GK10989@kroah.com>
References: <20081112001401.926965113@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="iwl3945-fix-deadlock-on-suspend.patch"
In-Reply-To: <20081112002215.GA10989@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Zhu Yi <yi.zhu@intel.com>

commit d54bc4e3fc5c56600a13c9ebc0a7e1077ac05d59 upstream.

This patch fixes iwl3945 deadlock during suspend by moving notify_mac out
of iwl3945 mutex. This is a portion of the same fix for iwlwifi by Tomas.

Signed-off-by: Zhu Yi <yi.zhu@intel.com>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/wireless/iwlwifi/iwl3945-base.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -5761,7 +5761,6 @@ static void iwl3945_alive_start(struct i
 	if (priv->error_recovering)
 		iwl3945_error_recovery(priv);
 
-	ieee80211_notify_mac(priv->hw, IEEE80211_NOTIFY_RE_ASSOC);
 	return;
 
  restart:
@@ -6006,6 +6005,7 @@ static void iwl3945_bg_alive_start(struc
 	mutex_lock(&priv->mutex);
 	iwl3945_alive_start(priv);
 	mutex_unlock(&priv->mutex);
+	ieee80211_notify_mac(priv->hw, IEEE80211_NOTIFY_RE_ASSOC);
 }
 
 static void iwl3945_bg_rf_kill(struct work_struct *work)

-- 
