Return-Path: <linux-kernel-owner+w=401wt.eu-S1756081AbZJLKfl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756081AbZJLKfl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 06:35:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756030AbZJLKfk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 06:35:40 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:49822 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755145AbZJLKfj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 06:35:39 -0400
Date: Mon, 12 Oct 2009 11:36:29 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Nick Bowler <nbowler@draconx.ca>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [Regression, bisected] Transmit failure in et131x.
Message-ID: <20091012113629.4ed8e7f4@lxorguk.ukuu.org.uk>
In-Reply-To: <loom.20091012T004346-812@post.gmane.org>
References: <20091008140805.GA21535@emergent.ellipticsemi.com>
	<20091009112016.4fb07eb7@lxorguk.ukuu.org.uk>
	<loom.20091012T004346-812@post.gmane.org>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Thanks a lot for your help.  Alas, this does not resolve the issue.
> Using tcpdump indicates that receive continues to work while transmit
> fails.
> 
> I was using gigabit, but the problem persists when I run at 100mbit.
> The MTU setting remains at the default 1500 bytes.

et131x: Fix the add_10bit macro

From: Alan Cox <alan@linux.intel.com>

Duh.. we need to preserve the wrap bit when adding.

Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 drivers/staging/et131x/et1310_address_map.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)


diff --git a/drivers/staging/et131x/et1310_address_map.h b/drivers/staging/et131x/et1310_address_map.h
index 2273926..d71e04a 100644
--- a/drivers/staging/et131x/et1310_address_map.h
+++ b/drivers/staging/et131x/et1310_address_map.h
@@ -223,7 +223,7 @@ typedef union _TXDMA_PR_NUM_DES_t {
 
 extern inline void add_10bit(u32 *v, int n)
 {
-	*v = INDEX10(*v + n);
+	*v = INDEX10(*v + n) | (*v & ET_DMA10_WRAP);
 }
 
 /*
