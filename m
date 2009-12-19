Return-Path: <linux-kernel-owner+w=401wt.eu-S1751908AbZLSPWp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751908AbZLSPWp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Dec 2009 10:22:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751302AbZLSPWo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Dec 2009 10:22:44 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:41872 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751194AbZLSPWn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Dec 2009 10:22:43 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=IWubdOHWuNjkbvoRqOJVIVBYeeLqi1U3+iQsWePAL+BckNehkPQC/LGAFnJ62V8qGO
         icZ7/xN+yWA4G8qNHSs8uhA5uJCXBXdkId+/zW6g/HsoaBZ0NVXKG8Yv0QGT8r3kFqQ0
         QFu63ob6i50rBultpf6jSWZeIQSWLyrQYIsrw=
Message-ID: <4B2CEE94.3080800@gmail.com>
Date: Sat, 19 Dec 2009 16:17:40 +0100
From: Roel Kluin <roel.kluin@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-4.fc12 Thunderbird/3.0
MIME-Version: 1.0
To: Tony Lindgren <tony@atomide.com>,
       "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] OMAP: &&/|| confusion in iommu_put()
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

obj can't be both NULL and be an error pointer.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
 arch/arm/plat-omap/iommu.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/arm/plat-omap/iommu.c b/arch/arm/plat-omap/iommu.c
index c0ff1e3..463d638 100644
--- a/arch/arm/plat-omap/iommu.c
+++ b/arch/arm/plat-omap/iommu.c
@@ -827,7 +827,7 @@ EXPORT_SYMBOL_GPL(iommu_get);
  **/
 void iommu_put(struct iommu *obj)
 {
-	if (!obj && IS_ERR(obj))
+	if (!obj || IS_ERR(obj))
 		return;
 
 	mutex_lock(&obj->iommu_lock);
