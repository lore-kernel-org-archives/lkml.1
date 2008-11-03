Return-Path: <linux-kernel-owner+w=401wt.eu-S1755712AbYKCLVm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755712AbYKCLVm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2008 06:21:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755133AbYKCLVe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Nov 2008 06:21:34 -0500
Received: from anchor-post-33.mail.demon.net ([194.217.242.91]:1519 "EHLO
	anchor-post-33.mail.demon.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755076AbYKCLVd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2008 06:21:33 -0500
Subject: [PATCH 6/8] p80211wext don't set default key id twice
From: Richard Kennedy <richard@rsk.demon.co.uk>
To: gregkh <gregkh@suse.de>
Cc: lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <1225710353.3113.5.camel@castor.localdomain>
References: <1225710353.3113.5.camel@castor.localdomain>
Content-Type: text/plain
Date: Mon, 03 Nov 2008 11:21:30 +0000
Message-Id: <1225711290.3113.27.camel@castor.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

p80211wext don't set default key id twice

another change from wlan-ng-devel

Signed-off-by: Richard Kennedy <richard@rsk.demon.co.uk>
---
 drivers/staging/wlan-ng/p80211wext.c |    7 -------
 1 files changed, 0 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/wlan-ng/p80211wext.c b/drivers/staging/wlan-ng/p80211wext.c
index de0789a..28c8359 100644
--- a/drivers/staging/wlan-ng/p80211wext.c
+++ b/drivers/staging/wlan-ng/p80211wext.c
@@ -616,13 +616,6 @@ static int p80211wext_siwencode(netdevice_t *dev,
 		else
 			i--;
 
-		result = p80211wext_dorequest(wlandev, DIDmib_dot11smt_dot11PrivacyTable_dot11WEPDefaultKeyID, i);
-
-		if (result) {
-			err = -EFAULT;
-			goto exit;
-		}
-
 		/* Set current key number only if no keys are given */
 		if (erq->flags & IW_ENCODE_NOKEY) {
 			result = p80211wext_dorequest(wlandev, DIDmib_dot11smt_dot11PrivacyTable_dot11WEPDefaultKeyID, i);
-- 
1.5.6.5



