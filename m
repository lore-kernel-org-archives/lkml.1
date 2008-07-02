Return-Path: <linux-kernel-owner+w=401wt.eu-S1763397AbYGBHXs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763397AbYGBHXs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2008 03:23:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762901AbYGBHXD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jul 2008 03:23:03 -0400
Received: from smtp116.sbc.mail.sp1.yahoo.com ([69.147.64.89]:44884 "HELO
	smtp116.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1761416AbYGBHWk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2008 03:22:40 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=5tUYAh/cP7OPMTNi6iWIoosTZvKvYq30dSQXDC/BP1hSnmzXqnrTJr+wKzpOCrsxcCAWBjpDjQPqsiEIutjIu4vYx/oMKUzMucULZuaguDp3OIDrSYOThMRU/QD0lYBENde67AVrKkb6MD/Akk5gztvHRZEykfqOAZUFfQ8WhRs=  ;
X-YMail-OSG: viwlGGwVM1nYY9x2S5t52MuL_aMu_CGY_EEjeY00TOO06zG303daE2LYbmVOVJgl.tqCWgmuCnuW_O3b1FvSbj3CmQWU5SKExSiYHx_xzKiXi5e33HZ..pe_TmaSa8cGfIc-
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 2.6.26-rc8] dma: fix platform driver hotplug/coldplug
Date: Wed, 2 Jul 2008 00:22:35 -0700
User-Agent: KMail/1.9.9
Cc: lkml <linux-kernel@vger.kernel.org>, kay.sievers@vrfy.org,
       maciej.sosnowski@intel.com, dan.j.williams@intel.com
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807020022.35486.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kay Sievers <kay.sievers@vrfy.org>

Since 43cc71eed1250755986da4c0f9898f9a635cb3bf, the platform
modalias is prefixed with "platform:". Add MODULE_ALIAS() to most
of the hotpluggable platform drivers, to re-enable auto loading.

Signed-off-by: Kay Sievers <kay.sievers@vrfy.org>
Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
---
 drivers/dma/iop-adma.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/dma/iop-adma.c	2008-07-01 23:58:22.000000000 -0700
+++ b/drivers/dma/iop-adma.c	2008-07-02 00:00:19.000000000 -0700
@@ -1387,6 +1387,8 @@ static void iop_chan_start_null_xor(stru
 	spin_unlock_bh(&iop_chan->lock);
 }
 
+MODULE_ALIAS("platform:iop-adma");
+
 static struct platform_driver iop_adma_driver = {
 	.probe		= iop_adma_probe,
 	.remove		= iop_adma_remove,
