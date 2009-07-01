Return-Path: <linux-kernel-owner+w=401wt.eu-S1763708AbZGABGy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763708AbZGABGy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 21:06:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761496AbZGAAfU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 20:35:20 -0400
Received: from kroah.org ([198.145.64.141]:60536 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761506AbZGAAfN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 20:35:13 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Tue Jun 30 17:24:35 2009
Message-Id: <20090701002435.626499318@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Tue, 30 Jun 2009 17:24:00 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Sujith <Sujith.Manoharan@atheros.com>,
       "John W. Linville" <linville@tuxdriver.com>
Subject: [patch 071/108] ath9k: Fix bug in scan termination
References: <20090701002249.937782934@mini.kroah.org>
Content-Disposition: inline; filename=ath9k-fix-bug-in-scan-termination.patch
In-Reply-To: <20090701002838.GA7100@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.30-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Sujith <Sujith.Manoharan@atheros.com>

commit 9c07a7777f44c7e39accec5ad8c4293d6a9b2a47 upstream.

A full HW reset needs to be done on termination of a scan run.
Not setting SC_OP_FULL_RESET resulted in doing a
fast channel change.

Signed-off-by: Sujith <Sujith.Manoharan@atheros.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/wireless/ath9k/main.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/net/wireless/ath9k/main.c
+++ b/drivers/net/wireless/ath9k/main.c
@@ -2772,6 +2772,7 @@ static void ath9k_sw_scan_complete(struc
 	mutex_lock(&sc->mutex);
 	aphy->state = ATH_WIPHY_ACTIVE;
 	sc->sc_flags &= ~SC_OP_SCANNING;
+	sc->sc_flags |= SC_OP_FULL_RESET;
 	mutex_unlock(&sc->mutex);
 }
 


