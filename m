Return-Path: <linux-kernel-owner+w=401wt.eu-S1754389AbXEBEa4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754389AbXEBEa4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 00:30:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992715AbXEBEaf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 00:30:35 -0400
Received: from smtp-out.google.com ([216.239.45.13]:25732 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754282AbXEBEaN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 00:30:13 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:date:from:x-x-sender:to:cc:subject:in-reply-to:
	message-id:references:mime-version:content-type;
	b=hHFV6uO0GtCOOcIF47vciYR42Q/3hkgyY73m/OKFqzMYF5osZ5QlnQlg9u5K/2eNj
	1zlcfi55it6+GOx3HXv6g==
Date: Tue, 1 May 2007 21:28:56 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: Paul Mundt <lethal@linux-sh.org>, linux-kernel@vger.kernel.org
Subject: [patch 03/10] sh: dma: use __attribute_unused__
In-Reply-To: <Pine.LNX.4.64.0705012119370.19277@chino.kir.corp.google.com>
Message-ID: <Pine.LNX.4.64.0705012120130.19277@chino.kir.corp.google.com>
References: <Pine.LNX.4.64.0705012118130.19277@chino.kir.corp.google.com>
 <Pine.LNX.4.64.0705012119370.19277@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

There is no such thing as labeling a variable as __attribute__((used)).
Since ts_shift is not referenced in inline assembly, we assume that we're
simply suppressing a warning here if the variable is declared but
unreferenced.

Cc: Paul Mundt <lethal@linux-sh.org>
Signed-off-by: David Rientjes <rientjes@google.com>
---
 include/asm-sh/cpu-sh3/dma.h        |    2 +-
 include/asm-sh/cpu-sh4/dma-sh7780.h |    2 +-
 include/asm-sh/cpu-sh4/dma.h        |    2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/include/asm-sh/cpu-sh3/dma.h b/include/asm-sh/cpu-sh3/dma.h
--- a/include/asm-sh/cpu-sh3/dma.h
+++ b/include/asm-sh/cpu-sh3/dma.h
@@ -26,7 +26,7 @@ enum {
 	XMIT_SZ_128BIT,
 };
 
-static unsigned int ts_shift[] __attribute__ ((used)) = {
+static unsigned int ts_shift[] __attribute_unused__ = {
 	[XMIT_SZ_8BIT]		= 0,
 	[XMIT_SZ_16BIT]		= 1,
 	[XMIT_SZ_32BIT]		= 2,
diff --git a/include/asm-sh/cpu-sh4/dma-sh7780.h b/include/asm-sh/cpu-sh4/dma-sh7780.h
--- a/include/asm-sh/cpu-sh4/dma-sh7780.h
+++ b/include/asm-sh/cpu-sh4/dma-sh7780.h
@@ -28,7 +28,7 @@ enum {
 /*
  * The DMA count is defined as the number of bytes to transfer.
  */
-static unsigned int __attribute__ ((used)) ts_shift[] = {
+static unsigned int ts_shift[] __attribute_unused__ = {
 	[XMIT_SZ_8BIT]		= 0,
 	[XMIT_SZ_16BIT]		= 1,
 	[XMIT_SZ_32BIT]		= 2,
diff --git a/include/asm-sh/cpu-sh4/dma.h b/include/asm-sh/cpu-sh4/dma.h
--- a/include/asm-sh/cpu-sh4/dma.h
+++ b/include/asm-sh/cpu-sh4/dma.h
@@ -53,7 +53,7 @@ enum {
 /*
  * The DMA count is defined as the number of bytes to transfer.
  */
-static unsigned int ts_shift[] __attribute__ ((used)) = {
+static unsigned int ts_shift[] __attribute_unused__ = {
 	[XMIT_SZ_64BIT]		= 3,
 	[XMIT_SZ_8BIT]		= 0,
 	[XMIT_SZ_16BIT]		= 1,
