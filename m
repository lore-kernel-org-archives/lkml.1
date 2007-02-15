Return-Path: <linux-kernel-owner+w=401wt.eu-S1030592AbXBOUGU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030592AbXBOUGU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Feb 2007 15:06:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030598AbXBOUGT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Feb 2007 15:06:19 -0500
Received: from mx1.redhat.com ([66.187.233.31]:39065 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030592AbXBOUGT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Feb 2007 15:06:19 -0500
Date: Thu, 15 Feb 2007 18:08:36 -0200
From: Glauber de Oliveira Costa <gcosta@redhat.com>
To: linux-kernel@vger.kernel.org, akpm@osdl.org
Subject: [PATCH] Missing __user in pointer referenced within copy_from_user
Message-ID: <20070215200836.GA21689@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Pointers to user data should be marked with a __user hint. This one is missing.

Signed-off-by: Glauber de Oliveira Costa <gcosta@redhat.com>
---
 fs/proc/base.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/proc/base.c b/fs/proc/base.c
index 4f5745a..01f7769 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -581,7 +581,7 @@ out_no_task:
 
 #ifndef mem_write
 /* This is a security hazard */
-static ssize_t mem_write(struct file * file, const char * buf,
+static ssize_t mem_write(struct file * file, const char __user *buf,
 			 size_t count, loff_t *ppos)
 {
 	int copied;
-- 
1.4.4.2
