Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751899Ab0CCFIG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Mar 2010 00:08:06 -0500
Received: from eu1sys200aog109.obsmtp.com ([207.126.144.127]:32908 "EHLO
	eu1sys200aog109.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750838Ab0CCFHx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Mar 2010 00:07:53 -0500
From: Viresh KUMAR <viresh.kumar@st.com>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, armando.visconti@st.com, amit.goel@st.com,
       shiraz.hashim@st.com, vipin.kumar@st.com, rajeev-dlh.kumar@st.com,
       deepak.sikri@st.com, ashish.priyadarshi@st.com,
       Viresh Kumar <viresh.kumar@st.com>
Subject: [PATCH 04/11] ST SPEAr: Added basic header files for SPEAr platform
Date: Wed,  3 Mar 2010 10:37:34 +0530
Message-Id: <1267592861-26911-5-git-send-email-viresh.kumar@st.com>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1267592861-26911-4-git-send-email-viresh.kumar@st.com>
References: <1267592861-26911-1-git-send-email-viresh.kumar@st.com>
 <1267592861-26911-2-git-send-email-viresh.kumar@st.com>
 <1267592861-26911-3-git-send-email-viresh.kumar@st.com>
 <1267592861-26911-4-git-send-email-viresh.kumar@st.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Viresh Kumar <viresh.kumar@st.com>
---
 arch/arm/plat-spear/include/plat/gpt.h |  108 ++++++++++++++++++++++++++++++++
 1 files changed, 108 insertions(+), 0 deletions(-)
 create mode 100644 arch/arm/plat-spear/include/plat/gpt.h

diff --git a/arch/arm/plat-spear/include/plat/gpt.h b/arch/arm/plat-spear/include/plat/gpt.h
new file mode 100644
index 0000000..1ac6cf0
--- /dev/null
+++ b/arch/arm/plat-spear/include/plat/gpt.h
@@ -0,0 +1,108 @@
+/*
+ * arch/arm/plat-spear/include/plat/gpt.h
+ *
+ * SPEAr General Purpose Timers header file
+ *
+ * Copyright (C) 2010 ST Microelectronics
+ * shiraz hashim <shiraz.hashim@st.com>
+ *
+ * This file is licensed under the terms of the GNU General Public
+ * License version 2. This program is licensed "as is" without any
+ * warranty of any kind, whether express or implied.
+ */
+
+#ifndef __ASM_PLAT_GPT_H
+#define __ASM_PLAT_GPT_H
+
+/* register offsets */
+#define GPT_CTRL_OFF		0x80 /* Control Register */
+#define GPT_INT_OFF		0x84 /* Interrupt Regiset */
+#define GPT_LOAD_OFF		0x88 /* Load Register */
+#define GPT_COUNT_OFF		0x8C /* Current Count Register */
+
+/* CTRL Reg Bit Values */
+#define GPT_CTRL_MATCH_INT	0x0100
+#define GPT_CTRL_ENABLE		0x0020
+#define GPT_CTRL_MODE_AR	0x0010
+
+#define GPT_CTRL_PRESCALER1	0x0
+#define GPT_CTRL_PRESCALER2	0x1
+#define GPT_CTRL_PRESCALER4	0x2
+#define GPT_CTRL_PRESCALER8	0x3
+#define GPT_CTRL_PRESCALER16	0x4
+#define GPT_CTRL_PRESCALER32	0x5
+#define GPT_CTRL_PRESCALER64	0x6
+#define GPT_CTRL_PRESCALER128	0x7
+#define GPT_CTRL_PRESCALER256	0x8
+
+/* INT Reg Bit Values */
+#define GPT_STATUS_MATCH	0x0001
+
+/* clock sources */
+#define SPEAR_TIMER_SRC_PLL3_CLK	0x00
+#define SPEAR_TIMER_SRC_SYS_CLK		0x01
+
+/**
+ * struct spear_timer - spear general purpose timer representation
+ * @id: timer identifier 0 onwards
+ * @phys_base: physical base address of timer
+ * @irq: irq to which this gpt is attached
+ * @prescaler: the prescaler for input freq at which timer is working
+ * @fclk: gpt functional clock
+ * @io_base: virtual base address of timer
+ * @reserved: indication that gpt is reserved now
+ * @enabled: indication that gpt is enabled
+ *
+ * The timer structure represent the timer channel available in SPEAr. Each
+ * timer unit in SPEAr contains two individual timer channels with different
+ * set of configuration registers * and irq. But the point to remember is
+ * this that the fclk is common for each channels withing a timer unit.
+ */
+
+struct spear_timer {
+	unsigned int id;
+	unsigned long phys_base;
+	int irq;
+	int prescaler;
+	struct clk *fclk;
+	void __iomem *io_base;
+	unsigned reserved:1;
+	unsigned enabled:1;
+};
+
+/*
+ * Following functions are exported by gpt.c which can be used by other
+ * kernel entities
+ */
+int spear_timer_init(struct spear_timer *, int);
+
+struct spear_timer *spear_timer_request(void);
+struct spear_timer *spear_timer_request_specific(int id);
+
+int spear_timer_free(struct spear_timer *timer);
+int spear_timer_enable(struct spear_timer *timer);
+int spear_timer_disable(struct spear_timer *timer);
+
+int spear_timer_get_irq(struct spear_timer *timer);
+
+struct clk *spear_timer_get_fclk(struct spear_timer *timer);
+
+int spear_timer_start(struct spear_timer *timer);
+int spear_timer_stop(struct spear_timer *timer);
+
+int spear_timer_set_source(struct spear_timer *timer, int source);
+int spear_timer_set_load(struct spear_timer *timer, int autoreload,
+		u16 value);
+int spear_timer_set_load_start(struct spear_timer *timer, int autoreload,
+		u16 value);
+int spear_timer_match_irq(struct spear_timer *timer, int enable);
+int spear_timer_set_prescaler(struct spear_timer *timer, int prescaler);
+
+int spear_timer_read_status(struct spear_timer *timer);
+int spear_timer_clear_status(struct spear_timer *timer, u16 value);
+
+int spear_timer_read_counter(struct spear_timer *timer);
+
+int spear_timer_active(struct spear_timer *);
+
+#endif /* __ASM_PLAT_GPT_H */
-- 
1.6.0.2

