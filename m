Return-Path: <linux-kernel-owner+w=401wt.eu-S932097AbZHMUP4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932097AbZHMUP4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Aug 2009 16:15:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756152AbZHMUPz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Aug 2009 16:15:55 -0400
Received: from kroah.org ([198.145.64.141]:41616 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755567AbZHMT7I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Aug 2009 15:59:08 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Thu Aug 13 12:51:24 2009
Message-Id: <20090813195124.804107734@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Thu, 13 Aug 2009 12:49:36 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, Greg KH <greg@kroah.com>
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       "John W. Linville" <linville@tuxdriver.com>,
       Reinette Chatre <reinette.chatre@intel.com>
Subject: [patch 01/74] iwlwifi: only show active power level via sysfs
References: <20090813194935.985368088@mini.kroah.org>
Content-Disposition: inline; filename=iwlwifi-only-show-active-power-level-via-sysfs.patch
In-Reply-To: <20090813195705.GA22393@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.30-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Reinette Chatre <reinette.chatre@intel.com>

commit 872ed1902f511a8947021c562f5728a5bf0640b5 upstream.

This changes the power_level file to adhere to the "one value
per file" sysfs rule. The user will know which power level was
requested as it will be the number just written to this file. It
is thus not necessary to create a new sysfs file for this value.

In addition it fixes a problem where powertop's parsing expects
this value to be the first value in this file without any descriptions.

Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/wireless/iwlwifi/iwl-agn.c      |   19 +------------------
 drivers/net/wireless/iwlwifi/iwl3945-base.c |   19 +------------------
 2 files changed, 2 insertions(+), 36 deletions(-)

--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -4623,27 +4623,10 @@ static ssize_t show_power_level(struct d
 				struct device_attribute *attr, char *buf)
 {
 	struct iwl_priv *priv = dev_get_drvdata(d);
-	int mode = priv->power_data.user_power_setting;
-	int system = priv->power_data.system_power_setting;
 	int level = priv->power_data.power_mode;
 	char *p = buf;
 
-	switch (system) {
-	case IWL_POWER_SYS_AUTO:
-		p += sprintf(p, "SYSTEM:auto");
-		break;
-	case IWL_POWER_SYS_AC:
-		p += sprintf(p, "SYSTEM:ac");
-		break;
-	case IWL_POWER_SYS_BATTERY:
-		p += sprintf(p, "SYSTEM:battery");
-		break;
-	}
-
-	p += sprintf(p, "\tMODE:%s", (mode < IWL_POWER_AUTO) ?
-			"fixed" : "auto");
-	p += sprintf(p, "\tINDEX:%d", level);
-	p += sprintf(p, "\n");
+	p += sprintf(p, "%d\n", level);
 	return p - buf + 1;
 }
 
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -3101,27 +3101,10 @@ static ssize_t show_power_level(struct d
 				struct device_attribute *attr, char *buf)
 {
 	struct iwl_priv *priv = dev_get_drvdata(d);
-	int mode = priv->power_data.user_power_setting;
-	int system = priv->power_data.system_power_setting;
 	int level = priv->power_data.power_mode;
 	char *p = buf;
 
-	switch (system) {
-	case IWL_POWER_SYS_AUTO:
-		p += sprintf(p, "SYSTEM:auto");
-		break;
-	case IWL_POWER_SYS_AC:
-		p += sprintf(p, "SYSTEM:ac");
-		break;
-	case IWL_POWER_SYS_BATTERY:
-		p += sprintf(p, "SYSTEM:battery");
-		break;
-	}
-
-	p += sprintf(p, "\tMODE:%s", (mode < IWL_POWER_AUTO) ?
-			"fixed" : "auto");
-	p += sprintf(p, "\tINDEX:%d", level);
-	p += sprintf(p, "\n");
+	p += sprintf(p, "%d\n", level);
 	return p - buf + 1;
 }
 


