Return-Path: <linux-kernel-owner+w=401wt.eu-S1753544AbYDMOnt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753544AbYDMOnt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Apr 2008 10:43:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758426AbYDMOnc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Apr 2008 10:43:32 -0400
Received: from fg-out-1718.google.com ([72.14.220.153]:23379 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754743AbYDMOnb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Apr 2008 10:43:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=JMDuCxeTrxaPMW2CvBmEA9e4ARrQCK7IVWAVo8zKZv6bx2Ffe63ERnfKgRnsxikYb3Uxxl/+x5PJfFwPz4OMP2rqBnwAk8QWDX7RtVJ3hekVMbY4HAufpB9Y82kRJ8UnF0cR9X3NT6MUca0/3jevS9UvTVojC1KsVOA6rAjPTbc=
Date: Sun, 13 Apr 2008 18:43:20 +0400
From: Dmitry Baryshkov <dbaryshkov@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org,
       Haavard Skinnemoen <haavard.skinnemoen@atmel.com>,
       Russell King <rmk+lkml@arm.linux.org.uk>,
       Paul Mundt <lethal@linux-sh.org>,
       pHilipp Zabel <philipp.zabel@gmail.com>, Pavel Machek <pavel@ucw.cz>,
       tony@atomide.com, paul@pwsan.com, David Brownell <david-b@pacbell.net>
Subject: [PATCH 2/5] Clocklib: debugfs support
Message-ID: <20080413144320.GA1958@doriath.ww600.siemens.net>
References: <20080413144138.GA31665@doriath.ww600.siemens.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080413144138.GA31665@doriath.ww600.siemens.net>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Provide /sys/kernel/debug/clock to ease debugging.

Signed-off-by: Dmitry Baryshkov <dbaryshkov@gmail.com>
---
 Documentation/ABI/testing/debugfs-clock |   49 ++++++++++++++++++++
 include/linux/clklib.h                  |    2 +
 kernel/clklib.c                         |   74 +++++++++++++++++++++++++++++++
 3 files changed, 125 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/ABI/testing/debugfs-clock

diff --git a/Documentation/ABI/testing/debugfs-clock b/Documentation/ABI/testing/debugfs-clock
new file mode 100644
index 0000000..79196e9
--- /dev/null
+++ b/Documentation/ABI/testing/debugfs-clock
@@ -0,0 +1,49 @@
+What:           /debug/clock
+Date:           Apr. 2008
+KernelVersion:  2.6.26
+Contact:        Dmitry Baryshkov <dbaryshkov@gmail.com>
+Description:
+
+debugfs interface
+-----------------
+		The /debug/clock file displays information about registered
+		clocks, their rates, usage counters, etc.
+
+Example:
+-------
+cat /sys/kernel/debug/clock
+
+GPIO11_CLK            use=4 rate=   3686400 Hz
+  3_6MHz_CLK          use=4 rate=   3686400 Hz
+    32K_CLK           use=1 rate=     32768 Hz
+      MMCCLK          use=1 rate=     32768 Hz for cell tmio-mmc
+    TMIOUSBCLK        use=1 rate=         0 Hz
+      USBCLK          use=1 rate=         0 Hz for cell tmio-ohci
+    TMIOMCLK          use=1 rate=  48000000 Hz
+      FBCLK           use=1 rate=  48000000 Hz for cell tmio-fb
+HWUARTCLK             use=0 rate=  14745600 Hz
+  UARTCLK             use=0 rate=  14745600 Hz for device pxa2xx-uart.3
+LCDCLK                use=0 rate=  99530000 Hz
+FFUARTCLK             use=1 rate=  14745600 Hz
+  UARTCLK             use=1 rate=  14745600 Hz for device pxa2xx-uart.0
+BTUARTCLK             use=0 rate=  14745600 Hz
+  UARTCLK             use=0 rate=  14745600 Hz for device pxa2xx-uart.1
+STUARTCLK             use=0 rate=  14745600 Hz
+  UARTCLK             use=0 rate=  14745600 Hz for device pxa2xx-uart.2
+  SIRCLK              use=0 rate=  14745600 Hz
+UDCCLK                use=0 rate=  47923000 Hz
+PXAMMCCLK             use=0 rate=  19169000 Hz
+  MMCCLK              use=0 rate=  19169000 Hz for device pxa2xx-mci.0
+I2CCLK                use=1 rate=  31949000 Hz
+SSP_CLK               use=0 rate=   3686400 Hz
+  SSPCLK              use=0 rate=   3686400 Hz for device pxa25x-ssp.0
+NSSPCLK               use=1 rate=   3686400 Hz
+  SSPCLK              use=1 rate=   3686400 Hz for device pxa25x-nssp.1
+ASSPCLK               use=0 rate=   3686400 Hz
+  SSPCLK              use=0 rate=   3686400 Hz for device pxa25x-nssp.2
+PWM0CLK               use=0 rate=   3686400 Hz
+  PWMCLK              use=0 rate=   3686400 Hz for device pxa25x-pwm.0
+PWM1CLK               use=0 rate=   3686400 Hz
+  PWMCLK              use=0 rate=   3686400 Hz for device pxa25x-pwm.1
+AC97CLK               use=0 rate=  24576000 Hz
+FICPCLK               use=0 rate=  47923000 Hz
diff --git a/include/linux/clklib.h b/include/linux/clklib.h
index 9545159..46c6977 100644
--- a/include/linux/clklib.h
+++ b/include/linux/clklib.h
@@ -19,6 +19,7 @@ struct seq_file;
  * @get_rate: obtain the current clock rate of a specified clock
  * @set_rate: set the clock rate for a specified clock
  * @round_rate: adjust a reate to the exact rate a clock can provide
+ * @format: output any additional information for a clock
  *
  * This structure specifies clock operations that are used to configure
  * specific clock.
@@ -30,6 +31,7 @@ struct clk_ops {
 	unsigned long (*get_rate)(struct clk *clk);
 	int (*set_rate)(struct clk *, unsigned long);
 	long (*round_rate)(struct clk *, unsigned long);
+	int (*format)(struct clk *, struct seq_file *);
 };
 
 /**
diff --git a/kernel/clklib.c b/kernel/clklib.c
index 024a232..29174c9 100644
--- a/kernel/clklib.c
+++ b/kernel/clklib.c
@@ -332,3 +332,77 @@ out:
 	return rc;
 }
 EXPORT_SYMBOL(clk_alloc_function);
+
+#ifdef CONFIG_DEBUG_FS
+
+#include <linux/debugfs.h>
+#include <linux/seq_file.h>
+
+#define NAME_FIELD_LEN	20
+
+static void dump_clocks(struct seq_file *s, struct clk *parent, int nest)
+{
+	struct clk *clk;
+	int i;
+
+	list_for_each_entry(clk, &clocks, node) {
+		if (clk->parent == parent) {
+			for (i = 0; i < nest; i++) {
+				seq_putc(s, ' ');
+				seq_putc(s, ' ');
+			}
+			seq_puts(s, clk->name);
+
+			i = 2 * nest + strlen(clk->name);
+			if (i >= NAME_FIELD_LEN)
+				i = NAME_FIELD_LEN - 1;
+			for (; i < NAME_FIELD_LEN; i++) {
+				seq_putc(s, ' ');
+			}
+			seq_printf(s, "%c use=%d rate=%10lu Hz",
+				clk->ops && clk->ops->set_parent ? '*' : ' ',
+				clk->users,
+				__clk_get_rate(clk));
+			if (clk->ops && clk->ops->format)
+				clk->ops->format(clk, s);
+			seq_putc(s, '\n');
+
+			dump_clocks(s, clk, nest + 1);
+		}
+	}
+}
+
+static int clocklib_show(struct seq_file *s, void *unused)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&clocks_lock, flags);
+
+	dump_clocks(s, NULL, 0);
+
+	spin_unlock_irqrestore(&clocks_lock, flags);
+
+	return 0;
+}
+
+static int clocklib_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, clocklib_show, NULL);
+}
+
+static struct file_operations clocklib_operations = {
+	.open		= clocklib_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= single_release,
+};
+
+static int __init clocklib_debugfs_init(void)
+{
+	debugfs_create_file("clock", S_IFREG | S_IRUGO,
+				NULL, NULL, &clocklib_operations);
+	return 0;
+}
+subsys_initcall(clocklib_debugfs_init);
+
+#endif /* DEBUG_FS */
-- 
1.5.4.4


-- 
With best wishes
Dmitry

