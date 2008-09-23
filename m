Return-Path: <linux-kernel-owner+w=401wt.eu-S1753499AbYIWPiD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753499AbYIWPiD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2008 11:38:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751409AbYIWPhy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Sep 2008 11:37:54 -0400
Received: from ey-out-2122.google.com ([74.125.78.26]:30681 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751388AbYIWPhx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2008 11:37:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding:sender;
        b=Jrv7XQk+ZDW/UBinson1uTLytMEMh0sUyVkWObTU8RSDY0T03LTEHvtDZbnMV0sj3Y
         HavlBeHgSeHF5jMAezpXEsUcb3I8MJ617m3hzI4KxUoResIdNArzg37jkutSEqle95nz
         dZEmwLibVA4t2zcczLtSWKDfE0tGmr4NNb2b8=
Message-ID: <48D90D42.9070401@tuffmail.co.uk>
Date: Tue, 23 Sep 2008 16:37:38 +0100
From: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
User-Agent: Thunderbird 2.0.0.16 (X11/20080724)
MIME-Version: 1.0
To: Arjan van de Ven <arjan@infradead.org>
CC: neilb@suse.de, linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] raid: make RAID autodetect default a KConfig option
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I noticed this Configure option is present even if BLK_DEV_MD=m.  In
this case the option does nothing, which is inconsistent with the help
text and generally odd :-).

Would you change it?

------

Hide RAID autodetect option if MD is compiled as a module.

Signed-off-by: Alan Jenkins <alan-jenkins@tuffmail.co.uk>

diff --git a/drivers/md/Configure b/drivers/md/Configure
index 8e72c91..2281b50 100644
--- a/drivers/md/Configure
+++ b/drivers/md/Configure
@@ -32,7 +32,7 @@ config BLK_DEV_MD
 
 config MD_AUTODETECT
 	bool "Autodetect RAID arrays during kernel boot"
-	depends on BLK_DEV_MD
+	depends on BLK_DEV_MD=y
 	default y
 	---help---
 	  If you say Y here, then the kernel will try to autodetect raid

