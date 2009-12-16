Return-Path: <linux-kernel-owner+w=401wt.eu-S933785AbZLPNGQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933785AbZLPNGQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 08:06:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752044AbZLPNGP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 08:06:15 -0500
Received: from mail-fx0-f221.google.com ([209.85.220.221]:58111 "EHLO
	mail-fx0-f221.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751296AbZLPNGO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 08:06:14 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=UrxJEhaobl6nU6UrauHGc1HHCwSJJqlmLjt3p+6PlopF+0JWqocKxzunOzZp6wdXJ5
         VeytIsptQz+Vxf7sQiOUZkt5DxU52wHb57F2+2VvZ3BHgksPumgX2BJliwhYo6vfZCs+
         RWYM8980gzTHA+lA+Rqyd9I/lzUCviYmm9XGE=
Message-ID: <4B28DBB6.5030304@gmail.com>
Date: Wed, 16 Dec 2009 14:08:06 +0100
From: Roel Kluin <roel.kluin@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20090922 Fedora/3.0-3.9.b4.fc12 Thunderbird/3.0b4
MIME-Version: 1.0
To: Samuel Ortiz <samuel.ortiz@intel.com>, Zhu Yi <yi.zhu@intel.com>,
       Intel Linux Wireless <ilw@linux.intel.com>,
       linux-wireless@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] iwmc3200wifi: Fix test of unsigned in iwm_ntf_stop_resume_tx()
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

`queue' is unsigned so the test did not work.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
Found using coccinelle: http://coccinelle.lip6.fr/

diff --git a/drivers/net/wireless/iwmc3200wifi/rx.c b/drivers/net/wireless/iwmc3200wifi/rx.c
index 1c57c1f..9ac72e4 100644
--- a/drivers/net/wireless/iwmc3200wifi/rx.c
+++ b/drivers/net/wireless/iwmc3200wifi/rx.c
@@ -1128,7 +1128,7 @@ static int iwm_ntf_stop_resume_tx(struct iwm_priv *iwm, u8 *buf,
 			struct iwm_tx_queue *txq;
 			u16 queue = iwm_tid_to_queue(bit);
 
-			if (queue < 0)
+			if (queue == -EINVAL)
 				continue;
 
 			txq = &iwm->txq[queue];
