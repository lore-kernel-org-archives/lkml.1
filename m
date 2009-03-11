Return-Path: <linux-kernel-owner+w=401wt.eu-S1755965AbZCKNB7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755965AbZCKNB7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Mar 2009 09:01:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755827AbZCKNBf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Mar 2009 09:01:35 -0400
Received: from ti-out-0910.google.com ([209.85.142.188]:29160 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755894AbZCKNBe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Mar 2009 09:01:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=f/Mk6Uj68BhbtO0inPewf1mnPBXQ7sLhDdkaWUpVLqVWRw7vJ81w5lB2gvjJnD9enc
         iz8BlXDYdoDiahhzi9itM6dLuOecvgiYY6qmP3Gn8R1ACXjEU/qcL6dmWDZjzobTB6fg
         GUntfih1xJu/N2G55w8NDVw+1elqRTPjQMciE=
From: Magnus Damm <magnus.damm@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: drzeus-wbsd@drzeus.cx, Magnus Damm <magnus.damm@gmail.com>,
       ian@mnementh.co.uk, akpm@linux-foundation.org
Date: Wed, 11 Mar 2009 21:59:03 +0900
Message-Id: <20090311125903.1563.71042.sendpatchset@rx1.opensource.se>
In-Reply-To: <20090311125845.1563.31960.sendpatchset@rx1.opensource.se>
References: <20090311125845.1563.31960.sendpatchset@rx1.opensource.se>
Subject: [PATCH 02/05] tmio_mmc: Fix use after free in remove()
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From:  Magnus Damm <damm@opensource.se>

Update the tmio_mmc code to call mmc_free_host() when
done using the private data. Without this fix the driver
frees memory and then keeps on using it as private data.

Signed-off-by: Magnus Damm <damm@opensource.se>
---

 drivers/mmc/host/tmio_mmc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- 0010/drivers/mmc/host/tmio_mmc.c
+++ work/drivers/mmc/host/tmio_mmc.c	2009-03-11 19:24:03.000000000 +0900
@@ -650,10 +650,10 @@ static int __devexit tmio_mmc_remove(str
 	if (mmc) {
 		struct tmio_mmc_host *host = mmc_priv(mmc);
 		mmc_remove_host(mmc);
-		mmc_free_host(mmc);
 		free_irq(host->irq, host);
 		iounmap(host->ctl);
 		iounmap(host->cnf);
+		mmc_free_host(mmc);
 	}
 
 	return 0;
