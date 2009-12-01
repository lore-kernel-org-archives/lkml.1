Return-Path: <linux-kernel-owner+w=401wt.eu-S1754709AbZLAXlO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754709AbZLAXlO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Dec 2009 18:41:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753191AbZLAXlN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Dec 2009 18:41:13 -0500
Received: from hera.kernel.org ([140.211.167.34]:53498 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751352AbZLAXlM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Dec 2009 18:41:12 -0500
Message-ID: <4B15A9EA.3090108@kernel.org>
Date: Wed, 02 Dec 2009 08:42:34 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20090915 SUSE/3.0b4-3.6 Thunderbird/3.0b4
MIME-Version: 1.0
To: Randy Dunlap <randy.dunlap@oracle.com>
CC: LKML <linux-kernel@vger.kernel.org>, linux-next@vger.kernel.org,
       Vivek Goyal <vgoyal@redhat.com>
Subject: [PATCH] percpu: add missing per_cpu_ptr_to_phys() definition for
 UP
References: <4B1560C2.8040603@oracle.com>
In-Reply-To: <4B1560C2.8040603@oracle.com>
X-Enigmail-Version: 0.97a
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 3b034b0d084221596bf35c8d893e1d4d5477b9cc implemented
per_cpu_ptr_to_phys() but forgot to add UP definition.  Add UP
definition which is simple wrapper around __pa().

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Vivek Goyal <vgoyal@redhat.com>
Reported-by: Randy Dunlap <randy.dunlap@oracle.com>
---
Hello,

> drivers/base/cpu.c: line 100: fails to build when CONFIG_SMP=n:
> 
> 	addr = per_cpu_ptr_to_phys(per_cpu_ptr(crash_notes, cpunum));
> 
> Can you suggest a fix for that, please?

Oops, right, UP definition was missing.  This patch should do it.

Thanks.

 include/linux/percpu.h |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/include/linux/percpu.h b/include/linux/percpu.h
index 6ac984f..8e4ead6 100644
--- a/include/linux/percpu.h
+++ b/include/linux/percpu.h
@@ -180,6 +180,11 @@ static inline void free_percpu(void *p)
 	kfree(p);
 }
 
+static inline phys_addr_t per_cpu_ptr_to_phys(void *addr)
+{
+	return __pa(addr);
+}
+
 static inline void __init setup_per_cpu_areas(void) { }
 
 static inline void *pcpu_lpage_remapped(void *kaddr)
-- 
1.6.4.2

