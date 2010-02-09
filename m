Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754207Ab0BILA4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Feb 2010 06:00:56 -0500
Received: from ey-out-2122.google.com ([74.125.78.25]:26917 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754062Ab0BILAy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Feb 2010 06:00:54 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=q26hvPvsLEUaySurVog3FjvIpOxPHCSRn5kDrWFXiXsGSjbNlnPuFIXaGs87W0k3XV
         OG7pCLhwnvVGRn12A/8SKQGKIX79f7jPZ2/0lAD/RTNUJpq9kXCeTCU5JhCqeF9cZsae
         YXXusFszDNAPj+q/cFVS5hGOQPmblFy3iaE4o=
Message-ID: <4B7141FD.7050605@gmail.com>
Date: Tue, 09 Feb 2010 12:07:41 +0100
From: Roel Kluin <roel.kluin@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc12 Thunderbird/3.0.1
MIME-Version: 1.0
To: Samuel Ortiz <samuel.ortiz@intel.com>, Zhu Yi <yi.zhu@intel.com>,
       Intel Linux Wireless <ilw@linux.intel.com>,
       linux-wireless@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] iwmc3200wifi: Test of wrong pointer after kzalloc in iwm_mlme_update_bss_table()
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The wrong pointer was tested.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
 drivers/net/wireless/iwmc3200wifi/rx.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/iwmc3200wifi/rx.c b/drivers/net/wireless/iwmc3200wifi/rx.c
index 6d6ed74..f727b4a 100644
--- a/drivers/net/wireless/iwmc3200wifi/rx.c
+++ b/drivers/net/wireless/iwmc3200wifi/rx.c
@@ -794,7 +794,7 @@ static int iwm_mlme_update_bss_table(struct iwm_priv *iwm, u8 *buf,
 	}
 
 	bss->bss = kzalloc(bss_len, GFP_KERNEL);
-	if (!bss) {
+	if (!bss->bss) {
 		kfree(bss);
 		IWM_ERR(iwm, "Couldn't allocate bss\n");
 		return -ENOMEM;
