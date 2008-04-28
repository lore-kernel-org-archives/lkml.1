Return-Path: <linux-kernel-owner+w=401wt.eu-S1763223AbYD1FEq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763223AbYD1FEq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 01:04:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752619AbYD1FEj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 01:04:39 -0400
Received: from wa-out-1112.google.com ([209.85.146.177]:56645 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751288AbYD1FEi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 01:04:38 -0400
In-Reply-To: <20080427.001709.221075811.davem@davemloft.net>
References: <a24804730804270012ycdbd962v377e0a3b9a379013@mail.gmail.com> <20080427.001709.221075811.davem@davemloft.net>
Mime-Version: 1.0 (Apple Message framework v753)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <A9BE4B91-0B5E-4F42-B4A8-95A45B566BD1@cpeterso.com>
Cc: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 7bit
From: Chris Peterson <cpeterso@cpeterso.com>
Subject: Re: [PATCH] fix uninitialized variable warning in crypto/async_tx/async_tx.c (fixed?)
Date: Sun, 27 Apr 2008 22:04:33 -0700
To: David Miller <davem@davemloft.net>
X-Mailer: Apple Mail (2.753)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

oops, sorry. Let me try this again.

chris


---
diff -Naur linux-2.6.25-git7/crypto/async_tx/async_tx.c linux-2.6.25- 
git7+patch/crypto/async_tx/async_tx.c
--- linux-2.6.25-git7/crypto/async_tx/async_tx.c        2008-04-25  
22:46:24.000000000 -0700
+++ linux-2.6.25-git7+patch/crypto/async_tx/async_tx.c  2008-04-25  
23:39:44.000000000 -0700
@@ -596,8 +596,11 @@
                         device = NULL;

                 tx = device ? device->device_prep_dma_interrupt 
(chan, 0) : NULL;
-       } else
+       } else {
+               chan = NULL;
+               device = NULL;
                 tx = NULL;
+       }

         if (tx) {
                 pr_debug("%s: (async)\n", __func__);

