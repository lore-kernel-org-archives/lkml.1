Return-Path: <linux-kernel-owner+w=401wt.eu-S1757902AbYBKS4h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757902AbYBKS4h (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2008 13:56:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751495AbYBKS42
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Feb 2008 13:56:28 -0500
Received: from smtp-out2.tiscali.nl ([195.241.79.177]:46534 "EHLO
	smtp-out2.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751387AbYBKS41 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2008 13:56:27 -0500
Message-ID: <47B09A4A.3030907@tiscali.nl>
Date: Mon, 11 Feb 2008 19:56:10 +0100
From: Roel Kluin <12o3l@tiscali.nl>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: John David Anglin <dave@hiauly1.hia.nrc.ca>
CC: James.Bottomley@HansenPartnership.com, kyle@parisc-linux.org,
       matthew@wil.cx, grundler@parisc-linux.org, linux-parisc@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH?][arch/parisc/kernel/pci-dma.c]      pcxl_dma_ops.alloc_noncoherent
References: <200802111708.m1BH8q3p008073@hiauly1.hia.nrc.ca>
In-Reply-To: <200802111708.m1BH8q3p008073@hiauly1.hia.nrc.ca>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

John David Anglin wrote:
>> James Bottomley wrote:
>>> On Mon, 2008-02-11 at 17:23 +0100, Roel Kluin wrote:
>>>> duplicate pa11_dma_alloc_consistent; more appropriate appears
>>>> pa11_dma_alloc_noncoherent here. 
>>>>
>>>> Not tested, please confirm that this fix is correct
>>> No, it looks completely incorrect to me.  What makes you think a pcxl
>>> box has a problem with coherency?
>> Ok, please ignore the patch then. It just appeared suspicious to me
>> that the function did exist, but the names assigned were different.
> 
> How about a comment?

Based on James Bottomley's explanation maybe a comment like this?
---
Explain why dma_alloc_noncoherent is only used for boxes PA7200 and below

Signed-off-by: Roel Kluin <12o3l@tiscali.nl>
---
diff --git a/arch/parisc/kernel/pci-dma.c b/arch/parisc/kernel/pci-dma.c
index 9448d4e..fc3325a 100644
--- a/arch/parisc/kernel/pci-dma.c
+++ b/arch/parisc/kernel/pci-dma.c
@@ -567,6 +567,10 @@ static void *fail_alloc_consistent(struct device *dev, size_t size,
 	return NULL;
 }
 
+/*
+ * dma_alloc_noncoherent is a fallback for boxes PA7200 and below which
+ * cannot allocate coherent memory.
+ */
 static void *pa11_dma_alloc_noncoherent(struct device *dev, size_t size,
 					  dma_addr_t *dma_handle, gfp_t flag)
 {
@@ -586,6 +590,10 @@ static void pa11_dma_free_noncoherent(struct device *dev, size_t size,
 	return;
 }
 
+/*
+ * PCXL allocates coherent memory even for dma_alloc_noncoherent() due to the
+ * uncached trick for coherent memory.
+ */
 struct hppa_dma_ops pcx_dma_ops = {
 	.dma_supported =	pa11_dma_supported,
 	.alloc_consistent =	fail_alloc_consistent,

