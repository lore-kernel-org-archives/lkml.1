Return-Path: <linux-kernel-owner+w=401wt.eu-S1761710AbZBNBCa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761710AbZBNBCa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Feb 2009 20:02:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753534AbZBNBBZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Feb 2009 20:01:25 -0500
Received: from kroah.org ([198.145.64.141]:39382 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753459AbZBNBBY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Feb 2009 20:01:24 -0500
Date: Fri, 13 Feb 2009 16:58:07 -0800
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
       alan@lxorguk.ukuu.org.uk, Tomas Winkler <tomas.winkler@intel.com>,
       "John W. Linville" <linville@tuxdriver.com>
Subject: [patch 02/47] iwlwifi: scan correct setting of valid rx_chains
Message-ID: <20090214005807.GC11282@kroah.com>
References: <20090214005130.617401075@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="iwlwifi-scan-correct-setting-of-valid-rx_chains.patch"
In-Reply-To: <20090214005726.GA11282@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Tomas Winkler <tomas.winkler@intel.com>

commit d588be6bae40f7965f1b681a4dbc3254411787b9 upstream.

This patch sets rx_chain bitmap correctly according hw configuration.

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/wireless/iwlwifi/iwl-scan.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/wireless/iwlwifi/iwl-scan.c
+++ b/drivers/net/wireless/iwlwifi/iwl-scan.c
@@ -704,7 +704,7 @@ static void iwl_bg_request_scan(struct w
 	u16 cmd_len;
 	enum ieee80211_band band;
 	u8 n_probes = 2;
-	u8 rx_chain = 0x7; /* bitmap: ABC chains */
+	u8 rx_chain = priv->hw_params.valid_rx_ant;
 
 	conf = ieee80211_get_hw_conf(priv->hw);
 

