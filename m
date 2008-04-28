Return-Path: <linux-kernel-owner+w=401wt.eu-S1765989AbYD1GfV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765989AbYD1GfV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 02:35:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754754AbYD1GfI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 02:35:08 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:37383
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753079AbYD1GfH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 02:35:07 -0400
Date: Sun, 27 Apr 2008 23:35:07 -0700 (PDT)
Message-Id: <20080427.233507.261574307.davem@davemloft.net>
To: crmafra2@gmail.com
Cc: linux-kernel@vger.kernel.org, reinette.chatre@intel.com,
       linville@tuxdriver.com, torvalds@linux-foundation.org
Subject: Re: [PATCH] iwlwifi: Fix build error in v2.6.25-5561-g064922a
From: David Miller <davem@davemloft.net>
In-Reply-To: <20080428054700.GA16177@Pilar.virtua.com.br>
References: <20080428054700.GA16177@Pilar.virtua.com.br>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Carlos R. Mafra" <crmafra2@gmail.com>
Date: Mon, 28 Apr 2008 02:47:01 -0300

> I've just tried to compile v2.6.25-5561-g064922a and it failed with
> these messages:

Already fixed in net-2.6 by:

commit bd8fd21dfddf51299d782f598cb776b15b7d64cc
Author: Luca Tettamanti <kronos.it@gmail.com>
Date:   Sun Apr 27 15:34:55 2008 -0700

    wireless: Fix compile error with wifi & leds
    
    Fix build error caused by commit
    e82404ad612ebabc65d15c3d59b971cb35c3ff36 ("iwlwifi: Select
    LEDS_CLASS.") from David Miller:
    
    Since MAC80211_LEDS is selected by wireless drivers it must select its
    own dependencies otherwise a build error may occur (kbuild will select
    the symbol regardless of "depends" constraints).
    
    Signed-off-By: Luca Tettamanti <kronos.it@gmail.com>
    Signed-off-by: David S. Miller <davem@davemloft.net>

diff --git a/net/mac80211/Kconfig b/net/mac80211/Kconfig
index 520a518..a24b459 100644
--- a/net/mac80211/Kconfig
+++ b/net/mac80211/Kconfig
@@ -73,7 +73,9 @@ config MAC80211_MESH
 
 config MAC80211_LEDS
 	bool "Enable LED triggers"
-	depends on MAC80211 && LEDS_TRIGGERS
+	depends on MAC80211
+	select NEW_LEDS
+	select LEDS_TRIGGERS
 	---help---
 	  This option enables a few LED triggers for different
 	  packet receive/transmit events.
