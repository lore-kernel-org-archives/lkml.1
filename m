Return-Path: <linux-kernel-owner+w=401wt.eu-S1754058Ab0AKTyM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754058Ab0AKTyM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jan 2010 14:54:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753946Ab0AKTyL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jan 2010 14:54:11 -0500
Received: from mail-fx0-f215.google.com ([209.85.220.215]:65109 "EHLO
	mail-fx0-f215.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753882Ab0AKTyK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jan 2010 14:54:10 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=mvXG90R4rjOG0lPRBcYiyF7spyP4zozqAJNhJTAsKlfFSl11MNce/TuBAJZHT2ahXa
         zzHuyqnOo9JBNTKTO4f1Iz7FrPqRe19SEEWWGCSujvmoPEraY19ajQmo1UiUwIKQD2Er
         r8U+3nh6xZv+fGOKv6Fm7bqe/RuzmEVBxN88o=
Message-ID: <4B4B82DD.4040209@gmail.com>
Date: Mon, 11 Jan 2010 20:58:21 +0100
From: Roel Kluin <roel.kluin@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-4.fc12 Thunderbird/3.0
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, borislav.petkov@amd.com,
       dougthompson@xmission.com
Subject: [PATCH] amd64_edac: index not within bounds in amd64_get_scrub_rate()
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ensure index stays within bound in amd64_get_scrub_rate()

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
diff --git a/drivers/edac/amd64_edac.c b/drivers/edac/amd64_edac.c
index c5facd9..000dc67 100644
--- a/drivers/edac/amd64_edac.c
+++ b/drivers/edac/amd64_edac.c
@@ -197,7 +197,7 @@ static int amd64_get_scrub_rate(struct mem_ctl_info *mci, u32 *bw)
 	edac_printk(KERN_DEBUG, EDAC_MC,
 		    "pci-read, sdram scrub control value: %d \n", scrubval);
 
-	for (i = 0; ARRAY_SIZE(scrubrates); i++) {
+	for (i = 0; i < ARRAY_SIZE(scrubrates); i++) {
 		if (scrubrates[i].scrubval == scrubval) {
 			*bw = scrubrates[i].bandwidth;
 			status = 0;
