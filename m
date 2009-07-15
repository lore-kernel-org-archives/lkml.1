Return-Path: <linux-kernel-owner+w=401wt.eu-S1754622AbZGOOjR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754622AbZGOOjR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jul 2009 10:39:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752089AbZGOOjR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Jul 2009 10:39:17 -0400
Received: from rv-out-0506.google.com ([209.85.198.231]:52860 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750797AbZGOOjQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jul 2009 10:39:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=oVZ7XwT8jPliITdS36DJOQwLQexi+6qF931lqN/lu0sPa+fzTq60MvbwKyEMGYn4mP
         grCpaoJkZ0ZkFr0GH+FbgjS4mLUPE2ED16wVaIKPd2Cz6ofeYO7SzYRE7Rv40C78lu6H
         a5AxJfsPf77p4F5XjvZtUFTLehKttTa6YJTk0=
Message-ID: <4A5DEA0D.8050706@gmail.com>
Date: Wed, 15 Jul 2009 23:39:09 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>, linux-next@vger.kernel.org,
       lkml <linux-kernel@vger.kernel.org>,
       Randy Dunlap <randy.dunlap@oracle.com>
Subject: [PATCH] percpu: add dummy pcpu_lpage_remapped() for !CONFIG_SMP
References: <20090706162632.fdde002e.sfr@canb.auug.org.au>	<20090706095343.df21d4c9.rdunlap@xenotime.net>	<20090709102248.01e2312c.randy.dunlap@oracle.com>	<20090715094720.GA6674@linux.vnet.ibm.com> <20090715195807.f0d1a7ea.sfr@canb.auug.org.au> <4A5DA937.6040605@kernel.org>
In-Reply-To: <4A5DA937.6040605@kernel.org>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

!CONFIG_SMP was missing pcpu_lpage_remapped() definition causing build
failure.  Add dummy implementation.  This was discovered by linux-next
testing.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
---
Yeap, it was missing dummy definition on !CONFIG_SMP.  This patch
fixes it.  Committed to percpu#for-next.  Thanks.

 include/linux/percpu.h |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/include/linux/percpu.h b/include/linux/percpu.h
index 8ce91af..e134c82 100644
--- a/include/linux/percpu.h
+++ b/include/linux/percpu.h
@@ -184,6 +184,11 @@ static inline void free_percpu(void *p)

 static inline void __init setup_per_cpu_areas(void) { }

+static inline void *pcpu_lpage_remapped(void *kaddr)
+{
+	return NULL;
+}
+
 #endif /* CONFIG_SMP */

 #define alloc_percpu(type)	(type *)__alloc_percpu(sizeof(type), \
-- 
1.6.0.2

