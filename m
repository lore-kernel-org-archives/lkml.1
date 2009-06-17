Return-Path: <linux-kernel-owner+w=401wt.eu-S1756671AbZFQQXQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756671AbZFQQXQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jun 2009 12:23:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753504AbZFQQWg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Jun 2009 12:22:36 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:34009 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753324AbZFQQWg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jun 2009 12:22:36 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: linux-kernel@vger.kernel.org
Cc: mingo@redhat.com, rgetz@blackfin.uclinux.org, akpm@linux-foundation.org
Subject: [PATCH 3/4] lockdep: use new arch_is_kernel_data()
Date: Wed, 17 Jun 2009 12:22:23 -0400
Message-Id: <1245255744-21039-3-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.6.3.1
In-Reply-To: <1245255744-21039-1-git-send-email-vapier@gentoo.org>
References: <1245255744-21039-1-git-send-email-vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This allows lockdep to locate symbols that are in arch-specific data
sections (such as data in Blackfin on-chip SRAM regions).

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 kernel/lockdep.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/kernel/lockdep.c b/kernel/lockdep.c
index 8bbeef9..8dc9b6a 100644
--- a/kernel/lockdep.c
+++ b/kernel/lockdep.c
@@ -636,6 +636,9 @@ static int static_obj(void *obj)
 	if ((addr >= start) && (addr < end))
 		return 1;
 
+	if (arch_is_kernel_data(addr))
+		return 1;
+
 #ifdef CONFIG_SMP
 	/*
 	 * percpu var?
-- 
1.6.3.1

