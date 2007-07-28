Return-Path: <linux-kernel-owner+w=401wt.eu-S1757014AbXG1Tg7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757014AbXG1Tg7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jul 2007 15:36:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754106AbXG1Tgw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Jul 2007 15:36:52 -0400
Received: from ug-out-1314.google.com ([66.249.92.170]:48446 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751446AbXG1Tgv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jul 2007 15:36:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=s5Plm9QiX26Cru7oGfJmpPjGyzvQKav3UKeT25Ig5lVBtLZotXm/UVCLAaHh286tUx8fcOcdtDjxDpmrlOD39RSct8BkWsoXY1JomRCCg+qoTXfaxJL53rDMZOwQw0e1oRFtkqTITTdsTCsLTh6nWF4Qhbi7hpPxUBPgn5/jf/4=
Message-ID: <46AB99DA.6050402@googlemail.com>
Date: Sat, 28 Jul 2007 21:32:42 +0200
From: Gabriel C <nix.or.die@googlemail.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070721)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org, jgarzik@pobox.com, linux-ide@vger.kernel.org
Subject: [PATCH -mm] Fix libata warnings with CONFIG_PM=n
References: <20070725040304.111550f4.akpm@linux-foundation.org>
In-Reply-To: <20070725040304.111550f4.akpm@linux-foundation.org>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jeff,

I noticed this warnings when CONFIG_PM=n 

...

drivers/ata/libata-core.c:5993: warning: 'ata_host_disable_link_pm' defined but not used
drivers/ata/libata-core.c:6004: warning: 'ata_host_enable_link_pm' defined but not used

...

Signed-off-by: Gabriel Craciunescu <nix.or.die@googlemail.com>

---

--- linux-2.6.23-rc1/drivers/ata/libata-core.c.orig	2007-07-28 21:17:31.000000000 +0200
+++ linux-2.6.23-rc1/drivers/ata/libata-core.c	2007-07-28 21:17:48.000000000 +0200
@@ -5989,6 +5989,7 @@ int ata_flush_cache(struct ata_device *d
 	return 0;
 }
 
+#ifdef CONFIG_PM
 static void ata_host_disable_link_pm(struct ata_host *host)
 {
 	int i;
@@ -6011,7 +6012,7 @@ static void ata_host_enable_link_pm(stru
 	}
 }
 
-#ifdef CONFIG_PM
+
 static int ata_host_request_pm(struct ata_host *host, pm_message_t mesg,
 			       unsigned int action, unsigned int ehi_flags,
 			       int wait)

