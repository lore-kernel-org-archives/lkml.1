Return-Path: <linux-kernel-owner+w=401wt.eu-S1759777AbYHHV7x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759777AbYHHV7x (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2008 17:59:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760898AbYHHVyQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Aug 2008 17:54:16 -0400
Received: from rv-out-0506.google.com ([209.85.198.234]:58025 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762045AbYHHVyN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2008 17:54:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=nytwXHX1IHYHoyuhgdMMYn0vEYHn6lUKFgRI0o/qZQ4qkvVX2UcC4iGgjR1Hz8ZROF
         NdZlrAaTRL7YClYW3KQCVC1+sCInhnzygPqpaeH0rsz/Pe2j/mPIiqHA7wfhypP/rGj1
         eRzmNljmAIb8IVTtneEJT6MZVms26lLex4RT8=
From: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>, Mike Travis <travis@sgi.com>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Yinghai Lu <yhlu.kernel@gmail.com>
Subject: [PATCH 16/42] drivers/serial to use nr_irqs
Date: Fri,  8 Aug 2008 14:52:22 -0700
Message-Id: <1218232368-31228-17-git-send-email-yhlu.kernel@gmail.com>
X-Mailer: git-send-email 1.5.4.5
In-Reply-To: <1218232368-31228-16-git-send-email-yhlu.kernel@gmail.com>
References: <1218232368-31228-1-git-send-email-yhlu.kernel@gmail.com>
 <1218232368-31228-2-git-send-email-yhlu.kernel@gmail.com>
 <1218232368-31228-3-git-send-email-yhlu.kernel@gmail.com>
 <1218232368-31228-4-git-send-email-yhlu.kernel@gmail.com>
 <1218232368-31228-5-git-send-email-yhlu.kernel@gmail.com>
 <1218232368-31228-6-git-send-email-yhlu.kernel@gmail.com>
 <1218232368-31228-7-git-send-email-yhlu.kernel@gmail.com>
 <1218232368-31228-8-git-send-email-yhlu.kernel@gmail.com>
 <1218232368-31228-9-git-send-email-yhlu.kernel@gmail.com>
 <1218232368-31228-10-git-send-email-yhlu.kernel@gmail.com>
 <1218232368-31228-11-git-send-email-yhlu.kernel@gmail.com>
 <1218232368-31228-12-git-send-email-yhlu.kernel@gmail.com>
 <1218232368-31228-13-git-send-email-yhlu.kernel@gmail.com>
 <1218232368-31228-14-git-send-email-yhlu.kernel@gmail.com>
 <1218232368-31228-15-git-send-email-yhlu.kernel@gmail.com>
 <1218232368-31228-16-git-send-email-yhlu.kernel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>
---
 drivers/serial/8250.c                   |    2 +-
 drivers/serial/amba-pl010.c             |    2 +-
 drivers/serial/amba-pl011.c             |    2 +-
 drivers/serial/cpm_uart/cpm_uart_core.c |    2 +-
 drivers/serial/m32r_sio.c               |    4 ++--
 drivers/serial/serial_core.c            |    2 +-
 drivers/serial/serial_lh7a40x.c         |    2 +-
 drivers/serial/sh-sci.c                 |    2 +-
 drivers/serial/ucc_uart.c               |    2 +-
 9 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/serial/8250.c b/drivers/serial/8250.c
index 71c8e68..f8f1015 100644
--- a/drivers/serial/8250.c
+++ b/drivers/serial/8250.c
@@ -2479,7 +2479,7 @@ static void serial8250_config_port(struct uart_port *port, int flags)
 static int
 serial8250_verify_port(struct uart_port *port, struct serial_struct *ser)
 {
-	if (ser->irq >= NR_IRQS || ser->irq < 0 ||
+	if (ser->irq >= nr_irqs || ser->irq < 0 ||
 	    ser->baud_base < 9600 || ser->type < PORT_UNKNOWN ||
 	    ser->type >= ARRAY_SIZE(uart_config) || ser->type == PORT_CIRRUS ||
 	    ser->type == PORT_STARTECH)
diff --git a/drivers/serial/amba-pl010.c b/drivers/serial/amba-pl010.c
index 90b56c2..7156268 100644
--- a/drivers/serial/amba-pl010.c
+++ b/drivers/serial/amba-pl010.c
@@ -512,7 +512,7 @@ static int pl010_verify_port(struct uart_port *port, struct serial_struct *ser)
 	int ret = 0;
 	if (ser->type != PORT_UNKNOWN && ser->type != PORT_AMBA)
 		ret = -EINVAL;
-	if (ser->irq < 0 || ser->irq >= NR_IRQS)
+	if (ser->irq < 0 || ser->irq >= nr_irqs)
 		ret = -EINVAL;
 	if (ser->baud_base < 9600)
 		ret = -EINVAL;
diff --git a/drivers/serial/amba-pl011.c b/drivers/serial/amba-pl011.c
index 9d08f27..b718004 100644
--- a/drivers/serial/amba-pl011.c
+++ b/drivers/serial/amba-pl011.c
@@ -572,7 +572,7 @@ static int pl010_verify_port(struct uart_port *port, struct serial_struct *ser)
 	int ret = 0;
 	if (ser->type != PORT_UNKNOWN && ser->type != PORT_AMBA)
 		ret = -EINVAL;
-	if (ser->irq < 0 || ser->irq >= NR_IRQS)
+	if (ser->irq < 0 || ser->irq >= nr_irqs)
 		ret = -EINVAL;
 	if (ser->baud_base < 9600)
 		ret = -EINVAL;
diff --git a/drivers/serial/cpm_uart/cpm_uart_core.c b/drivers/serial/cpm_uart/cpm_uart_core.c
index a4f8692..b09fdc2 100644
--- a/drivers/serial/cpm_uart/cpm_uart_core.c
+++ b/drivers/serial/cpm_uart/cpm_uart_core.c
@@ -589,7 +589,7 @@ static int cpm_uart_verify_port(struct uart_port *port,
 
 	if (ser->type != PORT_UNKNOWN && ser->type != PORT_CPM)
 		ret = -EINVAL;
-	if (ser->irq < 0 || ser->irq >= NR_IRQS)
+	if (ser->irq < 0 || ser->irq >= nr_irqs)
 		ret = -EINVAL;
 	if (ser->baud_base < 9600)
 		ret = -EINVAL;
diff --git a/drivers/serial/m32r_sio.c b/drivers/serial/m32r_sio.c
index 23d0305..611c97a 100644
--- a/drivers/serial/m32r_sio.c
+++ b/drivers/serial/m32r_sio.c
@@ -922,7 +922,7 @@ static void m32r_sio_config_port(struct uart_port *port, int flags)
 static int
 m32r_sio_verify_port(struct uart_port *port, struct serial_struct *ser)
 {
-	if (ser->irq >= NR_IRQS || ser->irq < 0 ||
+	if (ser->irq >= nr_irqs || ser->irq < 0 ||
 	    ser->baud_base < 9600 || ser->type < PORT_UNKNOWN ||
 	    ser->type >= ARRAY_SIZE(uart_config))
 		return -EINVAL;
@@ -1162,7 +1162,7 @@ static int __init m32r_sio_init(void)
 
 	printk(KERN_INFO "Serial: M32R SIO driver\n");
 
-	for (i = 0; i < NR_IRQS; i++)
+	for (i = 0; i < nr_irqs; i++)
 		spin_lock_init(&irq_lists[i].lock);
 
 	ret = uart_register_driver(&m32r_sio_reg);
diff --git a/drivers/serial/serial_core.c b/drivers/serial/serial_core.c
index f977c98..effd0bd 100644
--- a/drivers/serial/serial_core.c
+++ b/drivers/serial/serial_core.c
@@ -741,7 +741,7 @@ static int uart_set_info(struct uart_state *state,
 	if (port->ops->verify_port)
 		retval = port->ops->verify_port(port, &new_serial);
 
-	if ((new_serial.irq >= NR_IRQS) || (new_serial.irq < 0) ||
+	if ((new_serial.irq >= nr_irqs) || (new_serial.irq < 0) ||
 	    (new_serial.baud_base < 9600))
 		retval = -EINVAL;
 
diff --git a/drivers/serial/serial_lh7a40x.c b/drivers/serial/serial_lh7a40x.c
index cb49a5a..61dc8b3 100644
--- a/drivers/serial/serial_lh7a40x.c
+++ b/drivers/serial/serial_lh7a40x.c
@@ -460,7 +460,7 @@ static int lh7a40xuart_verify_port (struct uart_port* port,
 
 	if (ser->type != PORT_UNKNOWN && ser->type != PORT_LH7A40X)
 		ret = -EINVAL;
-	if (ser->irq < 0 || ser->irq >= NR_IRQS)
+	if (ser->irq < 0 || ser->irq >= nr_irqs)
 		ret = -EINVAL;
 	if (ser->baud_base < 9600) /* *** FIXME: is this true? */
 		ret = -EINVAL;
diff --git a/drivers/serial/sh-sci.c b/drivers/serial/sh-sci.c
index 3df2aae..667b4b8 100644
--- a/drivers/serial/sh-sci.c
+++ b/drivers/serial/sh-sci.c
@@ -1157,7 +1157,7 @@ static int sci_verify_port(struct uart_port *port, struct serial_struct *ser)
 {
 	struct sci_port *s = &sci_ports[port->line];
 
-	if (ser->irq != s->irqs[SCIx_TXI_IRQ] || ser->irq > NR_IRQS)
+	if (ser->irq != s->irqs[SCIx_TXI_IRQ] || ser->irq > nr_irqs)
 		return -EINVAL;
 	if (ser->baud_base < 2400)
 		/* No paper tape reader for Mitch.. */
diff --git a/drivers/serial/ucc_uart.c b/drivers/serial/ucc_uart.c
index 5c5d18d..503f0b9 100644
--- a/drivers/serial/ucc_uart.c
+++ b/drivers/serial/ucc_uart.c
@@ -1066,7 +1066,7 @@ static int qe_uart_verify_port(struct uart_port *port,
 	if (ser->type != PORT_UNKNOWN && ser->type != PORT_CPM)
 		return -EINVAL;
 
-	if (ser->irq < 0 || ser->irq >= NR_IRQS)
+	if (ser->irq < 0 || ser->irq >= nr_irqs)
 		return -EINVAL;
 
 	if (ser->baud_base < 9600)
-- 
1.5.4.5

