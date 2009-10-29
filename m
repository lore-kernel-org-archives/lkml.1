Return-Path: <linux-kernel-owner+w=401wt.eu-S1754270AbZJ2OCX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754270AbZJ2OCX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Oct 2009 10:02:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753336AbZJ2OCW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Oct 2009 10:02:22 -0400
Received: from hera.kernel.org ([140.211.167.34]:45374 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752390AbZJ2OCW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Oct 2009 10:02:22 -0400
Message-ID: <4AE9A0B3.4010305@kernel.org>
Date: Thu, 29 Oct 2009 15:03:31 +0100
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "'linux-ia64@vger.kernel.org'" <linux-ia64@vger.kernel.org>,
       "Luck, Tony" <tony.luck@intel.com>,
       Christoph Lameter <cl@linux-foundation.org>
Subject: [PATCH percpu#for-next] ia64: add sparse annotation to __ia64_per_cpu_var()
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ia64 has its own optimized percpu accessor - __ia64_per_cpu_var().
Add percpu sparse annotations to it.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 arch/ia64/include/asm/percpu.h |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

Index: work/arch/ia64/include/asm/percpu.h
===================================================================
--- work.orig/arch/ia64/include/asm/percpu.h
+++ work/arch/ia64/include/asm/percpu.h
@@ -39,7 +39,10 @@ extern void *per_cpu_init(void);
  * On the positive side, using __ia64_per_cpu_var() instead of __get_cpu_var() is slightly
  * more efficient.
  */
-#define __ia64_per_cpu_var(var)	var
+#define __ia64_per_cpu_var(var) (*({					\
+	__verify_pcpu_ptr(&(var));					\
+	((typeof(var) __kernel __force *)&(var));			\
+}))
 
 #include <asm-generic/percpu.h>
 
