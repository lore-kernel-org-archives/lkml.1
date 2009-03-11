Return-Path: <linux-kernel-owner+w=401wt.eu-S1755948AbZCKNBn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755948AbZCKNBn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Mar 2009 09:01:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755306AbZCKNBZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Mar 2009 09:01:25 -0400
Received: from ti-out-0910.google.com ([209.85.142.188]:29160 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755576AbZCKNBY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Mar 2009 09:01:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=rYSZjhYh0PYvYkvSG9k5EgZMrU3MCXKcy21rQVPLbiCwnonvTryAfuPLL/wXL+XoJV
         iyzRuiyR/vt6CFuphqZx1P3VpQ3CcAuNon0l6U3BPiMmqxmR+jRktHqeweZCql1kLDXi
         XzoE1n9+ziz60k6/XnDFo3d0886JdhelSvv1A=
From: Magnus Damm <magnus.damm@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: drzeus-wbsd@drzeus.cx, Magnus Damm <magnus.damm@gmail.com>,
       ian@mnementh.co.uk, akpm@linux-foundation.org
Date: Wed, 11 Mar 2009 21:58:54 +0900
Message-Id: <20090311125854.1563.34525.sendpatchset@rx1.opensource.se>
In-Reply-To: <20090311125845.1563.31960.sendpatchset@rx1.opensource.se>
References: <20090311125845.1563.31960.sendpatchset@rx1.opensource.se>
Subject: [PATCH 01/05] tmio_mmc: Fix one off, use resource_size() in probe()
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From:  Magnus Damm <damm@opensource.se>

Update the tmio_mmc code to use resource_size(). With this
patch applied the correct resource size is passed to ioremap().

Signed-off-by: Magnus Damm <damm@opensource.se>
---

 drivers/mmc/host/tmio_mmc.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- 0001/drivers/mmc/host/tmio_mmc.c
+++ work/drivers/mmc/host/tmio_mmc.c	2009-01-29 16:08:04.000000000 +0900
@@ -568,11 +568,11 @@ static int __devinit tmio_mmc_probe(stru
 	host->mmc = mmc;
 	platform_set_drvdata(dev, mmc);
 
-	host->ctl = ioremap(res_ctl->start, res_ctl->end - res_ctl->start);
+	host->ctl = ioremap(res_ctl->start, resource_size(res_ctl));
 	if (!host->ctl)
 		goto host_free;
 
-	host->cnf = ioremap(res_cnf->start, res_cnf->end - res_cnf->start);
+	host->cnf = ioremap(res_cnf->start, resource_size(res_cnf));
 	if (!host->cnf)
 		goto unmap_ctl;
 
