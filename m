Return-Path: <linux-kernel-owner+w=401wt.eu-S1751649AbXBEQzy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751649AbXBEQzy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Feb 2007 11:55:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751761AbXBEQzy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Feb 2007 11:55:54 -0500
Received: from an-out-0708.google.com ([209.85.132.246]:40423 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751649AbXBEQzv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Feb 2007 11:55:51 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:to:cc:subject:message-id:mime-version:content-type:content-disposition:in-reply-to:user-agent:from;
        b=XOvEcfRC96dKQTBUZEZZ/5+AAxF1lMaMDOp2atgU9tBBWHdsTW8QZhcca29v1pXaRrfrlzntPoAMvLuOJLSNx+c/UtECcUnx2eU/2mTTFF6BM990BogwOj0HwQRUVgaxRkkm0cPUvD9R49wH/Q6jZmWLgnudSKQHANAzTMVxQZM=
Date: Mon, 5 Feb 2007 18:55:46 +0200
To: cramerj@intel.com, john.ronciak@intel.com
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH 2.6.20] e1000: Use ARRAY_SIZE macro when appropriate
Message-ID: <20070205165546.GE3896@Ahmed>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070205165429.GD3896@Ahmed>
User-Agent: Mutt/1.5.11
From: "Ahmed S. Darwish" <darwish.07@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

A patch to use ARRAY_SIZE macro already defined in kernel.h.

Signed-off-by: Ahmed S. Darwish <darwish.07@gmail.com>
---
Patch is compile tested.

diff --git a/drivers/net/e1000/e1000_ethtool.c b/drivers/net/e1000/e1000_ethtool.c
index fb96c87..d21706e 100644
--- a/drivers/net/e1000/e1000_ethtool.c
+++ b/drivers/net/e1000/e1000_ethtool.c
@@ -746,7 +746,7 @@ err_setup:
 	uint32_t pat, value;                                                   \
 	uint32_t test[] =                                                      \
 		{0x5A5A5A5A, 0xA5A5A5A5, 0x00000000, 0xFFFFFFFF};              \
-	for (pat = 0; pat < sizeof(test)/sizeof(test[0]); pat++) {              \
+	for (pat = 0; pat < ARRAY_SIZE(test); pat++) {              \
 		E1000_WRITE_REG(&adapter->hw, R, (test[pat] & W));             \
 		value = E1000_READ_REG(&adapter->hw, R);                       \
 		if (value != (test[pat] & W & M)) {                             \

-- 
Ahmed S. Darwish
http://darwish-07.blogspot.com
