Return-Path: <linux-kernel-owner+w=401wt.eu-S1765368AbYBMBCY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765368AbYBMBCY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 20:02:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753962AbYBMBCL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 20:02:11 -0500
Received: from mail.vyatta.com ([216.93.170.194]:39814 "EHLO mail.vyatta.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752363AbYBMBCK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 20:02:10 -0500
X-Spam-Flag: NO
X-Spam-Score: -2.499
Message-Id: <20080213005122.653836965@vyatta.com>
References: <20080213005042.150212716@vyatta.com>
User-Agent: quilt/0.46-1
Date: Tue, 12 Feb 2008 16:50:43 -0800
From: Stephen Hemminger <shemminger@vyatta.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 1/4] rcu_assign_pointer: null check fix
Content-Disposition: inline; filename=rcu-assign-warn.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Goofed on last change, should avoid barrier only on rcu_assign_pointer(p, NULL)

Signed-off-by: Stephen Hemminger <shemminger@vyatta.com>
---
 include/linux/rcupdate.h |   13 +++++++------
 1 files changed, 7 insertions(+), 6 deletions(-)

--- a/include/linux/rcupdate.h	2008-02-12 14:46:49.000000000 -0800
+++ b/include/linux/rcupdate.h	2008-02-12 14:56:17.000000000 -0800
@@ -178,7 +178,7 @@ struct rcu_head {
 
 #define rcu_assign_pointer(p, v)			\
 	({						\
-		if (!(__builtin_constant_p(v) && v))	\
+		if (!__builtin_constant_p(v) || v)	\
 			smp_wmb();			\
 		(p) = (v);				\
 	})

-- 
Stephen Hemminger <shemminger@vyatta.com>

