Return-Path: <linux-kernel-owner+w=401wt.eu-S1752638AbZKAOWA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752638AbZKAOWA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Nov 2009 09:22:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752552AbZKAOWA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Nov 2009 09:22:00 -0500
Received: from mail-ew0-f228.google.com ([209.85.219.228]:44425 "EHLO
	mail-ew0-f228.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752538AbZKAOV7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Nov 2009 09:21:59 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=N8H5oSLx6jTFlnxKFieldT3yhzw4G3zaKDxoAXwxgv68FMDRQNOiwMElODpzgovtVS
         iljNurUftvmPDOFIRqxS5sMtEDQZuY018WF1aqvP22BDUn68dnGpvQnB3LqnwWdVXGKv
         VIBqp/VN9576bFUa1t7pyysLfvBEWTR8eILcI=
Message-ID: <4AED9C22.3040301@gmail.com>
Date: Sun, 01 Nov 2009 15:33:06 +0100
From: Roel Kluin <roel.kluin@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091014 Fedora/3.0-2.8.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: Hirokazu Takata <takata@linux-m32r.org>, linux-m32r@ml.linux-m32r.org,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] m32r: Should index be positive?
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Index `ipi_num' is signed, test whether it is negative to
make sure we don't get a negative array element.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
 arch/m32r/kernel/smp.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

Found by code analysis, is it required?

diff --git a/arch/m32r/kernel/smp.c b/arch/m32r/kernel/smp.c
index 8a88f1f..31cef20 100644
--- a/arch/m32r/kernel/smp.c
+++ b/arch/m32r/kernel/smp.c
@@ -806,7 +806,7 @@ unsigned long send_IPI_mask_phys(cpumask_t physid_mask, int ipi_num,
 
 	if (mask & ~physids_coerce(phys_cpu_present_map))
 		BUG();
-	if (ipi_num >= NR_IPIS)
+	if (ipi_num >= NR_IPIS || ipi_num < 0)
 		BUG();
 
 	mask <<= IPI_SHIFT;
