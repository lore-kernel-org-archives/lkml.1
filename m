Return-Path: <linux-kernel-owner+w=401wt.eu-S1759984AbZFRR5p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759984AbZFRR5p (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jun 2009 13:57:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754858AbZFRR4B
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Jun 2009 13:56:01 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:61245 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754315AbZFRRz4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jun 2009 13:55:56 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Michal Simek <monstr@monstr.eu>
Cc: microblaze-uclinux@itee.uq.edu.au, LKML <linux-kernel@vger.kernel.org>,
       Remis Lima Baima <remis.developer@googlemail.com>,
       Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 07/11] microblaze: make syscall_table implementation generic
Date: Thu, 18 Jun 2009 19:55:31 +0200
Message-Id: <8b43b3c47a5900dae2531bdc026dcb76cb1b3382.1245347640.git.arnd@arndb.de>
X-Mailer: git-send-email 1.6.3.1
In-Reply-To: <cover.1245345894.git.arnd@arndb.de>
References: <cover.1245345894.git.arnd@arndb.de>
In-Reply-To: <24d10c58e2739bacec05d641ab2a2c95ce6d69a9.1245347640.git.arnd@arndb.de>
References: <24d10c58e2739bacec05d641ab2a2c95ce6d69a9.1245347640.git.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1+oREfoL8UVDFrvb+dzxJ81FQsZLjKDDnvGSpN
 TwHXlKQR6flWMYWBaICIQP3UxSczNNodTm/4paSONVliROygdn
 2opsmTpKaCwDpwo6GYB2g==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The syscall table as added to the microblaze architecture
is entirely generic and can be used by all future
architectures as well, so move it to kernel/syscall_table.c.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 arch/microblaze/Kconfig                            |    3 +++
 arch/microblaze/kernel/Makefile                    |    2 +-
 kernel/Makefile                                    |    1 +
 {arch/microblaze/kernel => kernel}/syscall_table.c |    0
 4 files changed, 5 insertions(+), 1 deletions(-)
 rename {arch/microblaze/kernel => kernel}/syscall_table.c (100%)

diff --git a/arch/microblaze/Kconfig b/arch/microblaze/Kconfig
index b50b845..8b4de19 100644
--- a/arch/microblaze/Kconfig
+++ b/arch/microblaze/Kconfig
@@ -53,6 +53,9 @@ config GENERIC_HARDIRQS_NO__DO_IRQ
 config GENERIC_GPIO
 	def_bool y
 
+config GENERIC_SYSCALL_TABLE
+	def_bool y
+
 config PCI
 	def_bool n
 
diff --git a/arch/microblaze/kernel/Makefile b/arch/microblaze/kernel/Makefile
index 62353a9..f4a5e19 100644
--- a/arch/microblaze/kernel/Makefile
+++ b/arch/microblaze/kernel/Makefile
@@ -7,7 +7,7 @@ extra-y := head.o vmlinux.lds
 obj-y += exceptions.o \
 	hw_exception_handler.o init_task.o intc.o irq.o of_device.o \
 	of_platform.o process.o prom.o prom_parse.o ptrace.o \
-	setup.o signal.o sys_microblaze.o timer.o traps.o syscall_table.o
+	setup.o signal.o sys_microblaze.o timer.o traps.o
 
 obj-y += cpu/
 
diff --git a/kernel/Makefile b/kernel/Makefile
index 9df4501..a3d4fa3 100644
--- a/kernel/Makefile
+++ b/kernel/Makefile
@@ -98,6 +98,7 @@ obj-$(CONFIG_X86_DS) += trace/
 obj-$(CONFIG_SMP) += sched_cpupri.o
 obj-$(CONFIG_SLOW_WORK) += slow-work.o
 obj-$(CONFIG_PERF_COUNTERS) += perf_counter.o
+obj-$(CONFIG_GENERIC_SYSCALL_TABLE) += syscall_table.o
 
 ifneq ($(CONFIG_SCHED_OMIT_FRAME_POINTER),y)
 # According to Alan Modra <alan@linuxcare.com.au>, the -fno-omit-frame-pointer is
diff --git a/arch/microblaze/kernel/syscall_table.c b/kernel/syscall_table.c
similarity index 100%
rename from arch/microblaze/kernel/syscall_table.c
rename to kernel/syscall_table.c
-- 
1.6.3.1

