Return-Path: <linux-kernel-owner+w=401wt.eu-S1754509AbYHaR2n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754509AbYHaR2n (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Aug 2008 13:28:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756407AbYHaR2d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 31 Aug 2008 13:28:33 -0400
Received: from fg-out-1718.google.com ([72.14.220.153]:51693 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754415AbYHaR2b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Aug 2008 13:28:31 -0400
To: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
From: Hannes Eder <hannes@hanneseder.net>
Date: Fri, 29 Aug 2008 21:01:21 +0200
Subject: [PATCH] proc: fix sparse warning: make function grab_header static
Message-ID: <48bad4bb.0aaa660a.7eb7.ffff80b2@mx.google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix the following sparse warning in fs/proc/proc_sysctl.c, by making
the function grab_header static.

warning: symbol 'grab_header' was not declared. Should it be static?

Signed-off-by: Hannes Eder <hannes@hanneseder.net>
---
 fs/proc/proc_sysctl.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/proc/proc_sysctl.c b/fs/proc/proc_sysctl.c
index f9a8b89..84f58e8 100644
--- a/fs/proc/proc_sysctl.c
+++ b/fs/proc/proc_sysctl.c
@@ -66,7 +66,7 @@ static struct ctl_table *find_in_table(struct ctl_table *p, struct qstr *name)
 	return NULL;
 }
 
-struct ctl_table_header *grab_header(struct inode *inode)
+static struct ctl_table_header *grab_header(struct inode *inode)
 {
 	if (PROC_I(inode)->sysctl)
 		return sysctl_head_grab(PROC_I(inode)->sysctl);
