Return-Path: <linux-kernel-owner+w=401wt.eu-S932995AbZJFSLa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932995AbZJFSLa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 14:11:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932949AbZJFSLa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 14:11:30 -0400
Received: from rcsinet11.oracle.com ([148.87.113.123]:25004 "EHLO
	rgminet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932881AbZJFSL3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 14:11:29 -0400
Date: Tue, 6 Oct 2009 11:02:11 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>, Dave Jones <davej@redhat.com>,
       Avi Kivity <avi@redhat.com>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       cpufreq@vger.kernel.org
Subject: [PATCH -next] cpufreq: provide cpufreq_get stub
Message-Id: <20091006110211.139b91e5.randy.dunlap@oracle.com>
In-Reply-To: <20091006165220.b5cb1c44.sfr@canb.auug.org.au>
References: <20091006165220.b5cb1c44.sfr@canb.auug.org.au>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt357.oracle.com [141.146.40.157]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090209.4ACB8819.002C:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

When CONFIG_CPU_FREQ is disabled, cpufreq_get() needs a stub.
Used by kvm (although it looks like a bit of the kvm code could
be omitted when CONFIG_CPU_FREQ is disabled).

arch/x86/built-in.o: In function `kvm_arch_init':
(.text+0x10de7): undefined reference to `cpufreq_get'
 
Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 include/linux/cpufreq.h |    7 +++++++
 1 file changed, 7 insertions(+)

--- linux-next-20091006.orig/include/linux/cpufreq.h
+++ linux-next-20091006/include/linux/cpufreq.h
@@ -291,8 +291,15 @@ struct global_attr {
 int cpufreq_get_policy(struct cpufreq_policy *policy, unsigned int cpu);
 int cpufreq_update_policy(unsigned int cpu);
 
+#ifdef CONFIG_CPU_FREQ
 /* query the current CPU frequency (in kHz). If zero, cpufreq couldn't detect it */
 unsigned int cpufreq_get(unsigned int cpu);
+#else
+static inline unsigned int cpufreq_get(unsigned int cpu)
+{
+	return 0;
+}
+#endif
 
 /* query the last known CPU freq (in kHz). If zero, cpufreq couldn't detect it */
 #ifdef CONFIG_CPU_FREQ
---
~Randy
