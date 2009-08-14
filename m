Return-Path: <linux-kernel-owner+w=401wt.eu-S1753790AbZHNUlH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753790AbZHNUlH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Aug 2009 16:41:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753327AbZHNUkw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Aug 2009 16:40:52 -0400
Received: from vms173013pub.verizon.net ([206.46.173.13]:40525 "EHLO
	vms173013pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753215AbZHNUkt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Aug 2009 16:40:49 -0400
From: Len Brown <lenb@kernel.org>
To: x86@kernel.org, sfi-devel@simplefirmware.org, linux-kernel@vger.kernel.org,
       linux-acpi@vger.kernel.org
Cc: Feng Tang <feng.tang@intel.com>, Len Brown <len.brown@intel.com>
Subject: [PATCH 07/11] SFI: create linux/sfi.h
Date: Fri, 14 Aug 2009 16:38:11 -0400
Message-id: <4a07603b5073c06f55fe6db7966c820c9082c6ea.1250281826.git.len.brown@intel.com>
X-Mailer: git-send-email 1.6.4.122.g6ffd7
In-reply-to: <1250282295-25216-1-git-send-email-lenb@kernel.org>
References: <1250282295-25216-1-git-send-email-lenb@kernel.org>
In-reply-to: <0763223ab0ef5c0016b7a179c1acccaabbefea02.1250281826.git.len.brown@intel.com>
References: <0763223ab0ef5c0016b7a179c1acccaabbefea02.1250281826.git.len.brown@intel.com>
X-Patchwork-Hint: ignore
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Feng Tang <feng.tang@intel.com>

include/linux/include/sfi.h defines everything that customers
of SFI need to know in order to use the SFI suport in the kernel.

The primary API is sfi_table_parse(), where a driver or another part
of the kernel can supply a handler to parse the named table.

sfi.h also includes the currently defined table signatures and table
formats.

Signed-off-by: Feng Tang <feng.tang@intel.com>
Signed-off-by: Len Brown <len.brown@intel.com>
---
 include/linux/sfi.h |  206 +++++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 206 insertions(+), 0 deletions(-)
 create mode 100644 include/linux/sfi.h

diff --git a/include/linux/sfi.h b/include/linux/sfi.h
new file mode 100644
index 0000000..9a6f760
--- /dev/null
+++ b/include/linux/sfi.h
@@ -0,0 +1,206 @@
+/* sfi.h Simple Firmware Interface */
+
+/*
+
+  This file is provided under a dual BSD/GPLv2 license.  When using or
+  redistributing this file, you may do so under either license.
+
+  GPL LICENSE SUMMARY
+
+  Copyright(c) 2009 Intel Corporation. All rights reserved.
+
+  This program is free software; you can redistribute it and/or modify
+  it under the terms of version 2 of the GNU General Public License as
+  published by the Free Software Foundation.
+
+  This program is distributed in the hope that it will be useful, but
+  WITHOUT ANY WARRANTY; without even the implied warranty of
+  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+  General Public License for more details.
+
+  You should have received a copy of the GNU General Public License
+  along with this program; if not, write to the Free Software
+  Foundation, Inc., 51 Franklin St - Fifth Floor, Boston, MA 02110-1301 USA.
+  The full GNU General Public License is included in this distribution
+  in the file called LICENSE.GPL.
+
+  BSD LICENSE
+
+  Copyright(c) 2009 Intel Corporation. All rights reserved.
+
+  Redistribution and use in source and binary forms, with or without
+  modification, are permitted provided that the following conditions
+  are met:
+
+    * Redistributions of source code must retain the above copyright
+      notice, this list of conditions and the following disclaimer.
+    * Redistributions in binary form must reproduce the above copyright
+      notice, this list of conditions and the following disclaimer in
+      the documentation and/or other materials provided with the
+      distribution.
+    * Neither the name of Intel Corporation nor the names of its
+      contributors may be used to endorse or promote products derived
+      from this software without specific prior written permission.
+
+  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
+  "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
+  LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
+  A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
+  OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
+  SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
+  LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
+  DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
+  THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
+  (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
+  OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
+
+*/
+
+#ifndef _LINUX_SFI_H
+#define _LINUX_SFI_H
+
+/* Table signatures reserved by the SFI specification */
+#define SFI_SIG_SYST		"SYST"
+#define SFI_SIG_FREQ		"FREQ"
+#define SFI_SIG_IDLE		"IDLE"
+#define SFI_SIG_CPUS		"CPUS"
+#define SFI_SIG_MTMR		"MTMR"
+#define SFI_SIG_MRTC		"MRTC"
+#define SFI_SIG_MMAP		"MMAP"
+#define SFI_SIG_APIC		"APIC"
+#define SFI_SIG_XSDT		"XSDT"
+#define SFI_SIG_WAKE		"WAKE"
+#define SFI_SIG_SPIB		"SPIB"
+#define SFI_SIG_I2CB		"I2CB"
+#define SFI_SIG_GPEM		"GPEM"
+
+#define SFI_SIGNATURE_SIZE	4
+#define SFI_OEM_ID_SIZE		6
+#define SFI_OEM_TABLE_ID_SIZE	8
+
+#define SFI_SYST_SEARCH_BEGIN		0x000E0000
+#define SFI_SYST_SEARCH_END		0x000FFFFF
+
+#define SFI_GET_NUM_ENTRIES(ptable, entry_type) \
+	((ptable->header.len - sizeof(struct sfi_table_header)) / \
+	(sizeof(entry_type)))
+/*
+ * Table structures must be byte-packed to match the SFI specification,
+ * as they are provided by the BIOS.
+ */
+struct sfi_table_header {
+	char	sig[SFI_SIGNATURE_SIZE];
+	u32	len;
+	u8	rev;
+	u8	csum;
+	char	oem_id[SFI_OEM_ID_SIZE];
+	char	oem_table_id[SFI_OEM_TABLE_ID_SIZE];
+} __packed;
+
+struct sfi_table_simple {
+	struct sfi_table_header		header;
+	u64				pentry[1];
+} __packed;
+
+/* Comply with UEFI spec 2.1 */
+struct sfi_mem_entry {
+	u32	type;
+	u64	phys_start;
+	u64	virt_start;
+	u64	pages;
+	u64	attrib;
+} __packed;
+
+struct sfi_cpu_table_entry {
+	u32	apic_id;
+} __packed;
+
+struct sfi_cstate_table_entry {
+	u32	hint;		/* MWAIT hint */
+	u32	latency;	/* latency in ms */
+} __packed;
+
+struct sfi_apic_table_entry {
+	u64	phys_addr;	/* phy base addr for APIC reg */
+} __packed;
+
+struct sfi_freq_table_entry {
+	u32	freq_mhz;	/* in MHZ */
+	u32	latency;	/* transition latency in ms */
+	u32	ctrl_val;	/* value to write to PERF_CTL */
+} __packed;
+
+struct sfi_wake_table_entry {
+	u64	phys_addr;	/* pointer to where the wake vector locates */
+} __packed;
+
+struct sfi_timer_table_entry {
+	u64	phys_addr;	/* phy base addr for the timer */
+	u32	freq_hz;	/* in HZ */
+	u32	irq;
+} __packed;
+
+struct sfi_rtc_table_entry {
+	u64	phys_addr;	/* phy base addr for the RTC */
+	u32	irq;
+} __packed;
+
+struct sfi_spi_table_entry {
+	u16	host_num;	/* attached to host 0, 1...*/
+	u16	cs;		/* chip select */
+	u16	irq_info;
+	char	name[16];
+	u8	dev_info[10];
+} __packed;
+
+struct sfi_i2c_table_entry {
+	u16	host_num;
+	u16	addr;		/* slave addr */
+	u16	irq_info;
+	char	name[16];
+	u8	dev_info[10];
+} __packed;
+
+struct sfi_gpe_table_entry {
+	u16	logical_id;	/* logical id */
+	u16	phys_id;	/* physical GPE id */
+} __packed;
+
+
+typedef int (*sfi_table_handler) (struct sfi_table_header *table);
+
+#ifdef CONFIG_SFI
+extern void __init sfi_init(void);
+extern int __init sfi_platform_init(void);
+extern void __init sfi_init_late(void);
+extern int sfi_table_parse(char *signature, char *oem_id, char *oem_table_id,
+				sfi_table_handler handler);
+
+extern int sfi_disabled;
+static inline void disable_sfi(void)
+{
+	sfi_disabled = 1;
+}
+
+#else /* !CONFIG_SFI */
+
+static inline void sfi_init(void)
+{
+}
+
+static inline void sfi_init_late(void)
+{
+}
+
+#define sfi_disabled	0
+
+static inline int sfi_table_parse(char *signature, char *oem_id,
+					char *oem_table_id,
+					sfi_table_handler handler)
+{
+	return -1;
+}
+
+#endif /* !CONFIG_SFI */
+
+#endif /*_LINUX_SFI_H*/
-- 
1.6.0.6

