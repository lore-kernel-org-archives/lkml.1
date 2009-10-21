Return-Path: <linux-kernel-owner+w=401wt.eu-S1754092AbZJUUwr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754092AbZJUUwr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Oct 2009 16:52:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753748AbZJUUwq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Oct 2009 16:52:46 -0400
Received: from mx1.redhat.com ([209.132.183.28]:7137 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753576AbZJUUwp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Oct 2009 16:52:45 -0400
Date: Wed, 21 Oct 2009 22:51:26 +0200 (CEST)
From: John Kacur <jkacur@redhat.com>
X-X-Sender: jkacur@localhost.localdomain
To: Thomas Gleixner <tglx@linutronix.de>
cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Vincent Sanders <vince@simtec.co.uk>, Jonathan Corbet <corbet@lwn.net>,
       Christoph Hellwig <hch@infradead.org>,
       Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [patch 19/28] hw_random: Remove BKL from core
In-Reply-To: <20091010153349.844488872@linutronix.de>
Message-ID: <alpine.LFD.2.00.0910212249560.3526@localhost.localdomain>
References: <20091010153314.827301943@linutronix.de> <20091010153349.844488872@linutronix.de>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From d3da91fe463a0799911ed7c826ec133c38c0a18b Mon Sep 17 00:00:00 2001
From: John Kacur <jkacur@redhat.com>
Date: Wed, 21 Oct 2009 22:46:30 +0200
Subject: [PATCH] RNG: Explicitly set llseek = no_llseek after the BKL is removed.

Now that we've removed the BKL, lets explicitly set llseek to no_llseek
since it is not used here.

Signed-off-by: John Kacur <jkacur@redhat.com>
---
 drivers/char/hw_random/core.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/char/hw_random/core.c b/drivers/char/hw_random/core.c
index 75fb859..9cfd338 100644
--- a/drivers/char/hw_random/core.c
+++ b/drivers/char/hw_random/core.c
@@ -147,6 +147,7 @@ static const struct file_operations rng_chrdev_ops = {
 	.owner		= THIS_MODULE,
 	.open		= rng_dev_open,
 	.read		= rng_dev_read,
+	.llseek		= no_llseek,
 };
 
 static struct miscdevice rng_miscdev = {
-- 
1.6.0.6


