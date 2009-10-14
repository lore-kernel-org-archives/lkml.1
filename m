Return-Path: <linux-kernel-owner+w=401wt.eu-S934729AbZJNPu4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934729AbZJNPu4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Oct 2009 11:50:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934694AbZJNPuz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Oct 2009 11:50:55 -0400
Received: from hera.kernel.org ([140.211.167.34]:34610 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934680AbZJNPuy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Oct 2009 11:50:54 -0400
Date: Wed, 14 Oct 2009 15:49:40 GMT
From: tip-bot for Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       herbert@gondor.apana.org.au, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       herbert@gondor.apana.org.au, tglx@linutronix.de
In-Reply-To: <20091010153349.844488872@linutronix.de>
References: <20091010153349.844488872@linutronix.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:bkl/drivers] hw_random: Remove BKL from core
Message-ID: <tip-a09ba31a54dbc9a548c4ff90619e4c7128a4282e@git.kernel.org>
Git-Commit-ID: a09ba31a54dbc9a548c4ff90619e4c7128a4282e
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 14 Oct 2009 15:49:41 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  a09ba31a54dbc9a548c4ff90619e4c7128a4282e
Gitweb:     http://git.kernel.org/tip/a09ba31a54dbc9a548c4ff90619e4c7128a4282e
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Sat, 10 Oct 2009 12:36:32 +0200
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Wed, 14 Oct 2009 17:36:50 +0200

hw_random: Remove BKL from core

hw_random core is completely serialized with rng_mutex. No need for
the cycle_kernel_lock() magic.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
LKML-Reference: <20091010153349.844488872@linutronix.de>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
---
 drivers/char/hw_random/core.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/char/hw_random/core.c b/drivers/char/hw_random/core.c
index 1573aeb..75fb859 100644
--- a/drivers/char/hw_random/core.c
+++ b/drivers/char/hw_random/core.c
@@ -87,7 +87,6 @@ static int rng_dev_open(struct inode *inode, struct file *filp)
 		return -EINVAL;
 	if (filp->f_mode & FMODE_WRITE)
 		return -EINVAL;
-	cycle_kernel_lock();
 	return 0;
 }
 
