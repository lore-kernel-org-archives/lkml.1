Return-Path: <linux-kernel-owner+w=401wt.eu-S1752570AbYKGVwx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752570AbYKGVwx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2008 16:52:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751434AbYKGVwq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Nov 2008 16:52:46 -0500
Received: from rcsinet12.oracle.com ([148.87.113.124]:21971 "EHLO
	rgminet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751171AbYKGVwp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2008 16:52:45 -0500
Date: Fri, 7 Nov 2008 13:51:32 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: akpm <akpm@linux-foundation.org>, Alexey Dobriyan <adobriyan@gmail.com>
Subject: [PATCH] DOC: add printk-formats.txt
Message-Id: <20081107135132.a6fe9bba.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt704.oracle.com [141.146.40.82]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A0B0202.4914B884.0102:SCFSTAT928724,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Add printk-formats.txt so that we don't have to keep fixing the
same things over and over again.  <wishful thinking>

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
cc: Alexey Dobriyan <adobriyan@gmail.com>
---
 Documentation/00-INDEX           |    2 ++
 Documentation/printk-formats.txt |   36 ++++++++++++++++++++++++++++++++++++
 2 files changed, 38 insertions(+)

--- linux-next-20081107.orig/Documentation/00-INDEX
+++ linux-next-20081107/Documentation/00-INDEX
@@ -290,6 +290,8 @@ powerpc/
 	- directory with info on using Linux with the PowerPC.
 preempt-locking.txt
 	- info on locking under a preemptive kernel.
+printk-formats.txt
+	- how to get printk format specifiers right
 prio_tree.txt
 	- info on radix-priority-search-tree use for indexing vmas.
 ramdisk.txt
--- /dev/null
+++ linux-next-20081107/Documentation/printk-formats.txt
@@ -0,0 +1,36 @@
+If variable is of Type,		use printk format specifier:
+---------------------------------------------------------
+		int			%d or %x
+		unsigned int		%u or %x
+		long			%ld or %lx
+		unsigned long		%lu or %lx
+		long long		%lld or %llx
+		unsigned long long	%llu or %llx
+		size_t			%zu or %zx
+		ssize_t			%zd or %zx
+
+Raw pointer value SHOULD be printed with %p.
+
+u64 SHOULD be printed with %llu/%llx, (unsigned long long):
+
+	printk("%llu", (unsigned long long)u64_var);
+
+s64 SHOULD be printed with %lld/%llx, (long long):
+
+	printk("%lld", (long long)s64_var);
+
+If <type> is dependent on a config option for its size (e.g., sector_t,
+blkcnt_t, phys_addr_t, resource_size_t) or is architecture-dependent
+for its size (e.g., tcflag_t), use a format specifier of its largest
+possible type and explicitly cast to it.  Example:
+
+	printk("test: sector number/total blocks: %llu/%llu\n",
+		(unsigned long long)sector, (unsigned long long)blockcount);
+
+Reminder: sizeof() result is of type size_t.
+
+Thank you for your cooperation and attention.
+
+
+Written by Alexey Dobriyan <adobriyan@gmail.com>
+Updated by Randy Dunlap <rdunlap@xenotime.net>
