Return-Path: <linux-kernel-owner+w=401wt.eu-S934772AbZJNPw3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934772AbZJNPw3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Oct 2009 11:52:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934738AbZJNPw1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Oct 2009 11:52:27 -0400
Received: from hera.kernel.org ([140.211.167.34]:34697 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934713AbZJNPw0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Oct 2009 11:52:26 -0400
Date: Wed, 14 Oct 2009 15:51:30 GMT
From: tip-bot for Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       rdreier@cisco.com, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       rdreier@cisco.com, tglx@linutronix.de
In-Reply-To: <adad44tj090.fsf@cisco.com>
References: <adad44tj090.fsf@cisco.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:bkl/drivers] inifiband: Remove BKL from ipath_open()
Message-ID: <tip-f96d3015e9f7f7fff4cab7ed1d467664cc980061@git.kernel.org>
Git-Commit-ID: f96d3015e9f7f7fff4cab7ed1d467664cc980061
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 14 Oct 2009 15:51:31 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  f96d3015e9f7f7fff4cab7ed1d467664cc980061
Gitweb:     http://git.kernel.org/tip/f96d3015e9f7f7fff4cab7ed1d467664cc980061
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Wed, 14 Oct 2009 16:36:26 +0200
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Wed, 14 Oct 2009 17:36:54 +0200

inifiband: Remove BKL from ipath_open()

cycle_kernel_lock() got pushed down to ipath_open(). I tried hard to
understand what it might protect, but finally gave up.

Roland noted that qlogic seems to have abandoned the ipath driver and
came to the following wise conclusion: "So I guess if the BKL stuff is
blocking you in any way, we can just drop it from ipath and leave it
as yet another race condition in a rotting old driver."

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
LKML-Reference: <adad44tj090.fsf@cisco.com>
Cc: Roland Dreier <rdreier@cisco.com>
---
 drivers/infiniband/hw/ipath/ipath_file_ops.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/infiniband/hw/ipath/ipath_file_ops.c b/drivers/infiniband/hw/ipath/ipath_file_ops.c
index 40dbe54..73933a4 100644
--- a/drivers/infiniband/hw/ipath/ipath_file_ops.c
+++ b/drivers/infiniband/hw/ipath/ipath_file_ops.c
@@ -1821,7 +1821,6 @@ done:
 static int ipath_open(struct inode *in, struct file *fp)
 {
 	/* The real work is performed later in ipath_assign_port() */
-	cycle_kernel_lock();
 	fp->private_data = kzalloc(sizeof(struct ipath_filedata), GFP_KERNEL);
 	return fp->private_data ? 0 : -ENOMEM;
 }
