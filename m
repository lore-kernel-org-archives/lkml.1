Return-Path: <linux-kernel-owner+w=401wt.eu-S1754537AbZERPbn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754537AbZERPbn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 May 2009 11:31:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752655AbZERPbi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 May 2009 11:31:38 -0400
Received: from mail-ew0-f224.google.com ([209.85.219.224]:43257 "EHLO
	mail-ew0-f224.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751961AbZERPbh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 May 2009 11:31:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=ebg/0fM5r4sw5lM83KEfMfgeJ0Fzpwla0SRUWiJPPCXSdjnD/tneZccIHlN2yFxEdS
         tGsS6I/35kGFggsjO9UIYlndMV7gIAgSbyssPWJhIOUV3m4oWBVyyTTb0Q/jLjLNZtFS
         yZbL/LX7Qn+9GF4Yq0nUiCDvjtyCaeN3WrfiY=
Message-ID: <4A117F58.10407@gmail.com>
Date: Mon, 18 May 2009 17:31:36 +0200
From: Roel Kluin <roel.kluin@gmail.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090302)
MIME-Version: 1.0
To: Greg KH <gregkh@suse.de>
CC: lkml <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] [STAGING] wmm_param[1].ac_aci_acm_aifsn tested twice
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

wmm_param[1].ac_aci_acm_aifsn was tested twice, the second should have been
wmm_param[3].ac_aci_acm_aifsn.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
Correct?

diff --git a/drivers/staging/rtl8187se/ieee80211/ieee80211_rx.c b/drivers/staging/rtl8187se/ieee80211/ieee80211_rx.c
index 23519b3..4d4ee56 100644
--- a/drivers/staging/rtl8187se/ieee80211/ieee80211_rx.c
+++ b/drivers/staging/rtl8187se/ieee80211/ieee80211_rx.c
@@ -1680,7 +1680,7 @@ inline void update_network(struct ieee80211_network *dst,
 	if(src->wmm_param[0].ac_aci_acm_aifsn|| \
 	   src->wmm_param[1].ac_aci_acm_aifsn|| \
 	   src->wmm_param[2].ac_aci_acm_aifsn|| \
-	   src->wmm_param[1].ac_aci_acm_aifsn) {
+	   src->wmm_param[3].ac_aci_acm_aifsn) {
 	  memcpy(dst->wmm_param, src->wmm_param, WME_AC_PRAM_LEN);
 	}
 	dst->QoS_Enable = src->QoS_Enable;
