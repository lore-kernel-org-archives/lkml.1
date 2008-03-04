Return-Path: <linux-kernel-owner+w=401wt.eu-S1763330AbYCDDOM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763330AbYCDDOM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 22:14:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757747AbYCDDKZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 22:10:25 -0500
Received: from gv-out-0910.google.com ([216.239.58.190]:39909 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757839AbYCDDKC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 22:10:02 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=XrE6Ggd/xevseUtdKe0tK7l802yIyqL+to8H2HDO9VdB7Z17jUKK1UlLD6MsjVtak+MUhzi4znL29ckqhT6ke6RPTznxYxg8Y6UkqOOSPA1U+Drj67zSblneJhNdn+SSCA5V0rLF+pwHxCNrdaE8MOdJ09IC9uRwwLcFisVIjfI=
Subject: [PATCH 10/14] serial: replace remaining __FUNCTION__ occurrences
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Russell King <rmk@arm.linux.org.uk>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <ff8fd021606e7a6f03e9c274230cfcf64eade6d2.1204599636.git.harvey.harrison@gmail.com>
References: <ff8fd021606e7a6f03e9c274230cfcf64eade6d2.1204599636.git.harvey.harrison@gmail.com>
Content-Type: text/plain
Date: Mon, 03 Mar 2008 19:09:50 -0800
Message-Id: <1204600191.22933.90.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

__FUNCTION__ is gcc-specific, use __func__

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 drivers/serial/68360serial.c            |    4 +-
 drivers/serial/8250_early.c             |    2 +-
 drivers/serial/bfin_5xx.c               |    4 +-
 drivers/serial/cpm_uart/cpm_uart_core.c |    2 +-
 drivers/serial/crisv10.c                |    8 +++---
 drivers/serial/ioc3_serial.c            |   36 +++++++++++++++---------------
 drivers/serial/ioc4_serial.c            |   32 +++++++++++++-------------
 drivers/serial/s3c2410.c                |    6 ++--
 drivers/serial/sa1100.c                 |    4 +-
 drivers/serial/sh-sci.c                 |    2 +-
 drivers/serial/sn_console.c             |    2 +-
 drivers/serial/uartlite.c               |    2 +-
 drivers/serial/ucc_uart.c               |    4 +-
 13 files changed, 54 insertions(+), 54 deletions(-)

diff --git a/drivers/serial/68360serial.c b/drivers/serial/68360serial.c
index 2aa6bfe..1a0c363 100644
--- a/drivers/serial/68360serial.c
+++ b/drivers/serial/68360serial.c
@@ -1245,7 +1245,7 @@ static int rs_360_tiocmget(struct tty_struct *tty, struct file *file)
 #ifdef modem_control
 	unsigned char control, status;
 
-	if (serial_paranoia_check(info, tty->name, __FUNCTION__))
+	if (serial_paranoia_check(info, tty->name, __func__))
 		return -ENODEV;
 
 	if (tty->flags & (1 << TTY_IO_ERROR))
@@ -1276,7 +1276,7 @@ static int rs_360_tiocmset(struct tty_struct *tty, struct file *file,
 	ser_info_t *info = (ser_info_t *)tty->driver_data;
  	unsigned int arg;
 
-	if (serial_paranoia_check(info, tty->name, __FUNCTION__))
+	if (serial_paranoia_check(info, tty->name, __func__))
 		return -ENODEV;
 
 	if (tty->flags & (1 << TTY_IO_ERROR))
diff --git a/drivers/serial/8250_early.c b/drivers/serial/8250_early.c
index 38776e8..cd89870 100644
--- a/drivers/serial/8250_early.c
+++ b/drivers/serial/8250_early.c
@@ -156,7 +156,7 @@ static int __init parse_options(struct early_serial8250_device *device,
 		port->membase = ioremap(port->mapbase, 64);
 		if (!port->membase) {
 			printk(KERN_ERR "%s: Couldn't ioremap 0x%llx\n",
-				__FUNCTION__,
+				__func__,
 			       (unsigned long long)port->mapbase);
 			return -ENOMEM;
 		}
diff --git a/drivers/serial/bfin_5xx.c b/drivers/serial/bfin_5xx.c
index 0aa345b..16c8ae1 100644
--- a/drivers/serial/bfin_5xx.c
+++ b/drivers/serial/bfin_5xx.c
@@ -766,7 +766,7 @@ bfin_serial_set_termios(struct uart_port *port, struct ktermios *termios,
 		break;
 	default:
 		printk(KERN_ERR "%s: word lengh not supported\n",
-			__FUNCTION__);
+			__func__);
 	}
 
 	if (termios->c_cflag & CSTOPB)
@@ -1012,7 +1012,7 @@ bfin_serial_console_get_options(struct bfin_serial_port *uart, int *baud,
 
 		*baud = get_sclk() / (16*(dll | dlh << 8));
 	}
-	pr_debug("%s:baud = %d, parity = %c, bits= %d\n", __FUNCTION__, *baud, *parity, *bits);
+	pr_debug("%s:baud = %d, parity = %c, bits= %d\n", __func__, *baud, *parity, *bits);
 }
 #endif
 
diff --git a/drivers/serial/cpm_uart/cpm_uart_core.c b/drivers/serial/cpm_uart/cpm_uart_core.c
index 236af9d..ca96ce5 100644
--- a/drivers/serial/cpm_uart/cpm_uart_core.c
+++ b/drivers/serial/cpm_uart/cpm_uart_core.c
@@ -1118,7 +1118,7 @@ int cpm_uart_drv_get_platform_data(struct platform_device *pdev, int is_con)
 
 	line = cpm_uart_id2nr(idx);
 	if(line < 0) {
-		printk(KERN_ERR"%s(): port %d is not registered", __FUNCTION__, idx);
+		printk(KERN_ERR"%s(): port %d is not registered", __func__, idx);
 		return -EINVAL;
 	}
 
diff --git a/drivers/serial/crisv10.c b/drivers/serial/crisv10.c
index 383c4e6..0385c5b 100644
--- a/drivers/serial/crisv10.c
+++ b/drivers/serial/crisv10.c
@@ -1788,7 +1788,7 @@ static unsigned int handle_descr_data(struct e100_serial *info,
 
 	if (info->recv_cnt + recvl > 65536) {
 		printk(KERN_CRIT
-		       "%s: Too much pending incoming serial data! Dropping %u bytes.\n", __FUNCTION__, recvl);
+		       "%s: Too much pending incoming serial data! Dropping %u bytes.\n", __func__, recvl);
 		return 0;
 	}
 
@@ -1801,7 +1801,7 @@ static unsigned int handle_descr_data(struct e100_serial *info,
 	append_recv_buffer(info, buffer);
 
 	if (!(buffer = alloc_recv_buffer(SERIAL_DESCR_BUF_SIZE)))
-		panic("%s: Failed to allocate memory for receive buffer!\n", __FUNCTION__);
+		panic("%s: Failed to allocate memory for receive buffer!\n", __func__);
 
 	descr->buf = virt_to_phys(buffer->buffer);
 
@@ -1925,7 +1925,7 @@ static int start_recv_dma(struct e100_serial *info)
 	/* Set up the receiving descriptors */
 	for (i = 0; i < SERIAL_RECV_DESCRIPTORS; i++) {
 		if (!(buffer = alloc_recv_buffer(SERIAL_DESCR_BUF_SIZE)))
-			panic("%s: Failed to allocate memory for receive buffer!\n", __FUNCTION__);
+			panic("%s: Failed to allocate memory for receive buffer!\n", __func__);
 
 		descr[i].ctrl = d_int;
 		descr[i].buf = virt_to_phys(buffer->buffer);
@@ -4513,7 +4513,7 @@ rs_init(void)
 
 	if (request_irq(SERIAL_IRQ_NBR, ser_interrupt,
 			IRQF_SHARED | IRQF_DISABLED, "serial ", driver))
-		panic("%s: Failed to request irq8", __FUNCTION__);
+		panic("%s: Failed to request irq8", __func__);
 
 #endif
 #endif /* CONFIG_SVINTO_SIM */
diff --git a/drivers/serial/ioc3_serial.c b/drivers/serial/ioc3_serial.c
index 168073f..4f1af71 100644
--- a/drivers/serial/ioc3_serial.c
+++ b/drivers/serial/ioc3_serial.c
@@ -52,7 +52,7 @@ static unsigned int Submodule_slot;
 #define DPRINT_CONFIG(_x...)	;
 //#define DPRINT_CONFIG(_x...)  printk _x
 #define NOT_PROGRESS()	;
-//#define NOT_PROGRESS()	printk("%s : fails %d\n", __FUNCTION__, __LINE__)
+//#define NOT_PROGRESS()	printk("%s : fails %d\n", __func__, __LINE__)
 
 /* number of characters we want to transmit to the lower level at a time */
 #define MAX_CHARS		256
@@ -445,7 +445,7 @@ static int inline port_init(struct ioc3_port *port)
 		sbbr_h = &idd->vma->sbbr_h;
 		ring_pci_addr = (unsigned long __iomem)port->ip_dma_ringbuf;
 		DPRINT_CONFIG(("%s: ring_pci_addr 0x%p\n",
-			       __FUNCTION__, (void *)ring_pci_addr));
+			       __func__, (void *)ring_pci_addr));
 
 		writel((unsigned int)((uint64_t) ring_pci_addr >> 32), sbbr_h);
 		writel((unsigned int)ring_pci_addr | BUF_SIZE_BIT, sbbr_l);
@@ -593,7 +593,7 @@ config_port(struct ioc3_port *port,
 
 	DPRINT_CONFIG(("%s: line %d baud %d byte_size %d stop %d parenb %d "
 			"parodd %d\n",
-		       __FUNCTION__, ((struct uart_port *)port->ip_port)->line,
+		       __func__, ((struct uart_port *)port->ip_port)->line,
 			baud, byte_size, stop_bits, parenb, parodd));
 
 	if (set_baud(port, baud))
@@ -871,14 +871,14 @@ static int ioc3_set_proto(struct ioc3_port *port, int proto)
 	default:
 	case PROTO_RS232:
 		/* Clear the appropriate GIO pin */
-		DPRINT_CONFIG(("%s: rs232\n", __FUNCTION__));
+		DPRINT_CONFIG(("%s: rs232\n", __func__));
 		writel(0, (&port->ip_idd->vma->gppr[0]
 					+ hooks->rs422_select_pin));
 		break;
 
 	case PROTO_RS422:
 		/* Set the appropriate GIO pin */
-		DPRINT_CONFIG(("%s: rs422\n", __FUNCTION__));
+		DPRINT_CONFIG(("%s: rs422\n", __func__));
 		writel(1, (&port->ip_idd->vma->gppr[0]
 					+ hooks->rs422_select_pin));
 		break;
@@ -988,7 +988,7 @@ ioc3_change_speed(struct uart_port *the_port,
 	}
 	baud = uart_get_baud_rate(the_port, new_termios, old_termios,
 				  MIN_BAUD_SUPPORTED, MAX_BAUD_SUPPORTED);
-	DPRINT_CONFIG(("%s: returned baud %d for line %d\n", __FUNCTION__, baud,
+	DPRINT_CONFIG(("%s: returned baud %d for line %d\n", __func__, baud,
 				the_port->line));
 
 	if (!the_port->fifosize)
@@ -1026,7 +1026,7 @@ ioc3_change_speed(struct uart_port *the_port,
 	DPRINT_CONFIG(("%s : port 0x%p line %d cflag 0%o "
 		       "config_port(baud %d data %d stop %d penable %d "
 			" parity %d), notification 0x%x\n",
-		       __FUNCTION__, (void *)port, the_port->line, cflag, baud,
+		       __func__, (void *)port, the_port->line, cflag, baud,
 		       new_data, new_stop, new_parity_enable, new_parity,
 		       the_port->ignore_status_mask));
 
@@ -1919,7 +1919,7 @@ static inline int ioc3_serial_core_attach( struct ioc3_submodule *is,
 	struct pci_dev *pdev = idd->pdev;
 
 	DPRINT_CONFIG(("%s: attach pdev 0x%p - card_ptr 0x%p\n",
-		       __FUNCTION__, pdev, (void *)card_ptr));
+		       __func__, pdev, (void *)card_ptr));
 
 	if (!card_ptr)
 		return -ENODEV;
@@ -1933,7 +1933,7 @@ static inline int ioc3_serial_core_attach( struct ioc3_submodule *is,
 		port->ip_port = the_port;
 
 		DPRINT_CONFIG(("%s: attach the_port 0x%p / port 0x%p [%d/%d]\n",
-			__FUNCTION__, (void *)the_port, (void *)port,
+			__func__, (void *)the_port, (void *)port,
 				phys_port, ii));
 
 		/* membase, iobase and mapbase just need to be non-0 */
@@ -1950,7 +1950,7 @@ static inline int ioc3_serial_core_attach( struct ioc3_submodule *is,
 		if (uart_add_one_port(&ioc3_uart, the_port) < 0) {
 			printk(KERN_WARNING
 		          "%s: unable to add port %d bus %d\n",
-			       __FUNCTION__, the_port->line, pdev->bus->number);
+			       __func__, the_port->line, pdev->bus->number);
 		} else {
 			DPRINT_CONFIG(("IOC3 serial port %d irq %d bus %d\n",
 		          the_port->line, the_port->irq, pdev->bus->number));
@@ -2017,7 +2017,7 @@ ioc3uart_probe(struct ioc3_submodule *is, struct ioc3_driver_data *idd)
 	struct ioc3_port *ports[PORTS_PER_CARD];
 	int phys_port;
 
-	DPRINT_CONFIG(("%s (0x%p, 0x%p)\n", __FUNCTION__, is, idd));
+	DPRINT_CONFIG(("%s (0x%p, 0x%p)\n", __func__, is, idd));
 
 	card_ptr = kzalloc(sizeof(struct ioc3_card), GFP_KERNEL);
 	if (!card_ptr) {
@@ -2067,7 +2067,7 @@ ioc3uart_probe(struct ioc3_submodule *is, struct ioc3_driver_data *idd)
 
 			DPRINT_CONFIG(("%s : Port A ip_serial_regs 0x%p "
 				       "ip_uart_regs 0x%p\n",
-				       __FUNCTION__,
+				       __func__,
 				       (void *)port->ip_serial_regs,
 				       (void *)port->ip_uart_regs));
 
@@ -2082,7 +2082,7 @@ ioc3uart_probe(struct ioc3_submodule *is, struct ioc3_driver_data *idd)
 			DPRINT_CONFIG(("%s : Port A ip_cpu_ringbuf 0x%p "
 				       "ip_dma_ringbuf 0x%p, ip_inring 0x%p "
 					"ip_outring 0x%p\n",
-				       __FUNCTION__,
+				       __func__,
 				       (void *)port->ip_cpu_ringbuf,
 				       (void *)port->ip_dma_ringbuf,
 				       (void *)port->ip_inring,
@@ -2094,7 +2094,7 @@ ioc3uart_probe(struct ioc3_submodule *is, struct ioc3_driver_data *idd)
 
 			DPRINT_CONFIG(("%s : Port B ip_serial_regs 0x%p "
 				       "ip_uart_regs 0x%p\n",
-				       __FUNCTION__,
+				       __func__,
 				       (void *)port->ip_serial_regs,
 				       (void *)port->ip_uart_regs));
 
@@ -2108,7 +2108,7 @@ ioc3uart_probe(struct ioc3_submodule *is, struct ioc3_driver_data *idd)
 			DPRINT_CONFIG(("%s : Port B ip_cpu_ringbuf 0x%p "
 				       "ip_dma_ringbuf 0x%p, ip_inring 0x%p "
 					"ip_outring 0x%p\n",
-				       __FUNCTION__,
+				       __func__,
 				       (void *)port->ip_cpu_ringbuf,
 				       (void *)port->ip_dma_ringbuf,
 				       (void *)port->ip_inring,
@@ -2116,7 +2116,7 @@ ioc3uart_probe(struct ioc3_submodule *is, struct ioc3_driver_data *idd)
 		}
 
 		DPRINT_CONFIG(("%s : port %d [addr 0x%p] card_ptr 0x%p",
-			       __FUNCTION__,
+			       __func__,
 			       phys_port, (void *)port, (void *)card_ptr));
 		DPRINT_CONFIG((" ip_serial_regs 0x%p ip_uart_regs 0x%p\n",
 			       (void *)port->ip_serial_regs,
@@ -2127,7 +2127,7 @@ ioc3uart_probe(struct ioc3_submodule *is, struct ioc3_driver_data *idd)
 
 		DPRINT_CONFIG(("%s: phys_port %d port 0x%p inring 0x%p "
 			       "outring 0x%p\n",
-			       __FUNCTION__,
+			       __func__,
 			       phys_port, (void *)port,
 			       (void *)port->ip_inring,
 			       (void *)port->ip_outring));
@@ -2170,7 +2170,7 @@ static int __devinit ioc3uart_init(void)
 	if ((ret = uart_register_driver(&ioc3_uart)) < 0) {
 		printk(KERN_WARNING
 		       "%s: Couldn't register IOC3 uart serial driver\n",
-		       __FUNCTION__);
+		       __func__);
 		return ret;
 	}
 	ret = ioc3_register_submodule(&ioc3uart_submodule);
diff --git a/drivers/serial/ioc4_serial.c b/drivers/serial/ioc4_serial.c
index 0c17938..49b8a82 100644
--- a/drivers/serial/ioc4_serial.c
+++ b/drivers/serial/ioc4_serial.c
@@ -889,7 +889,7 @@ static int inline port_init(struct ioc4_port *port)
 
 		ring_pci_addr = (unsigned long __iomem)port->ip_dma_ringbuf;
 		DPRINT_CONFIG(("%s: ring_pci_addr 0x%lx\n",
-					__FUNCTION__, ring_pci_addr));
+					__func__, ring_pci_addr));
 
 		writel((unsigned int)((uint64_t)ring_pci_addr >> 32), sbbr_h);
 		writel((unsigned int)ring_pci_addr | IOC4_BUF_SIZE_BIT, sbbr_l);
@@ -1028,7 +1028,7 @@ static irqreturn_t ioc4_intr(int irq, void *arg)
 		spin_lock_irqsave(&soft->is_ir_lock, flag);
 		printk ("%s : %d : mem 0x%p sio_ir 0x%x sio_ies 0x%x "
 				"other_ir 0x%x other_ies 0x%x mask 0x%x\n",
-		     __FUNCTION__, __LINE__,
+		     __func__, __LINE__,
 		     (void *)mem, readl(&mem->sio_ir.raw),
 		     readl(&mem->sio_ies.raw),
 		     readl(&mem->other_ir.raw),
@@ -1155,14 +1155,14 @@ static int inline ioc4_attach_local(struct ioc4_driver_data *idd)
 				(TOTAL_RING_BUF_SIZE - 1)) == 0));
 			DPRINT_CONFIG(("%s : ip_cpu_ringbuf 0x%p "
 						"ip_dma_ringbuf 0x%p\n",
-					__FUNCTION__,
+					__func__,
 					(void *)port->ip_cpu_ringbuf,
 					(void *)port->ip_dma_ringbuf));
 			port->ip_inring = RING(port, RX_0_OR_2);
 			port->ip_outring = RING(port, TX_0_OR_2);
 		}
 		DPRINT_CONFIG(("%s : port %d [addr 0x%p] control 0x%p",
-				__FUNCTION__,
+				__func__,
 				port_number, (void *)port, (void *)control));
 		DPRINT_CONFIG((" ip_serial_regs 0x%p ip_uart_regs 0x%p\n",
 				(void *)port->ip_serial_regs,
@@ -1173,7 +1173,7 @@ static int inline ioc4_attach_local(struct ioc4_driver_data *idd)
 
 		DPRINT_CONFIG(("%s: port_number %d port 0x%p inring 0x%p "
 						"outring 0x%p\n",
-				__FUNCTION__,
+				__func__,
 				port_number, (void *)port,
 				(void *)port->ip_inring,
 				(void *)port->ip_outring));
@@ -1317,7 +1317,7 @@ config_port(struct ioc4_port *port,
 	int spiniter = 0;
 
 	DPRINT_CONFIG(("%s: baud %d byte_size %d stop %d parenb %d parodd %d\n",
-		__FUNCTION__, baud, byte_size, stop_bits, parenb, parodd));
+		__func__, baud, byte_size, stop_bits, parenb, parodd));
 
 	if (set_baud(port, baud))
 		return 1;
@@ -1725,7 +1725,7 @@ ioc4_change_speed(struct uart_port *the_port,
 	}
 	baud = uart_get_baud_rate(the_port, new_termios, old_termios,
 				MIN_BAUD_SUPPORTED, MAX_BAUD_SUPPORTED);
-	DPRINT_CONFIG(("%s: returned baud %d\n", __FUNCTION__, baud));
+	DPRINT_CONFIG(("%s: returned baud %d\n", __func__, baud));
 
 	/* default is 9600 */
 	if (!baud)
@@ -1765,7 +1765,7 @@ ioc4_change_speed(struct uart_port *the_port,
 	DPRINT_CONFIG(("%s : port 0x%p cflag 0%o "
 		"config_port(baud %d data %d stop %d p enable %d parity %d),"
 		" notification 0x%x\n",
-	     __FUNCTION__, (void *)port, cflag, baud, new_data, new_stop,
+	     __func__, (void *)port, cflag, baud, new_data, new_stop,
 	     new_parity_enable, new_parity, the_port->ignore_status_mask));
 
 	if ((config_port(port, baud,		/* baud */
@@ -2715,7 +2715,7 @@ ioc4_serial_core_attach(struct pci_dev *pdev, int port_type)
 

 	DPRINT_CONFIG(("%s: attach pdev 0x%p - control 0x%p\n",
-			__FUNCTION__, pdev, (void *)control));
+			__func__, pdev, (void *)control));
 
 	if (!control)
 		return -ENODEV;
@@ -2734,7 +2734,7 @@ ioc4_serial_core_attach(struct pci_dev *pdev, int port_type)
 		port->ip_all_ports[port_type_idx] = the_port;
 
 		DPRINT_CONFIG(("%s: attach the_port 0x%p / port 0x%p : type %s\n",
-				__FUNCTION__, (void *)the_port,
+				__func__, (void *)the_port,
 				(void *)port,
 				port_type == PROTO_RS232 ? "rs232" : "rs422"));
 
@@ -2752,7 +2752,7 @@ ioc4_serial_core_attach(struct pci_dev *pdev, int port_type)
 		if (uart_add_one_port(u_driver, the_port) < 0) {
 			printk(KERN_WARNING
 		           "%s: unable to add port %d bus %d\n",
-			       __FUNCTION__, the_port->line, pdev->bus->number);
+			       __func__, the_port->line, pdev->bus->number);
 		} else {
 			DPRINT_CONFIG(
 			    ("IOC4 serial port %d irq = %d, bus %d\n",
@@ -2777,7 +2777,7 @@ ioc4_serial_attach_one(struct ioc4_driver_data *idd)
 	int ret = 0;
 

-	DPRINT_CONFIG(("%s (0x%p, 0x%p)\n", __FUNCTION__, idd->idd_pdev,
+	DPRINT_CONFIG(("%s (0x%p, 0x%p)\n", __func__, idd->idd_pdev,
 							idd->idd_pci_id));
 
 	/* PCI-RT does not bring out serial connections.
@@ -2806,7 +2806,7 @@ ioc4_serial_attach_one(struct ioc4_driver_data *idd)
 		goto out2;
 	}
 	DPRINT_CONFIG(("%s : mem 0x%p, serial 0x%p\n",
-				__FUNCTION__, (void *)idd->idd_misc_regs,
+				__func__, (void *)idd->idd_misc_regs,
 				(void *)serial));
 
 	/* Get memory for the new card */
@@ -2858,7 +2858,7 @@ ioc4_serial_attach_one(struct ioc4_driver_data *idd)
 	} else {
 		printk(KERN_WARNING
 		    "%s : request_irq fails for IRQ 0x%x\n ",
-			__FUNCTION__, idd->idd_pdev->irq);
+			__func__, idd->idd_pdev->irq);
 	}
 	ret = ioc4_attach_local(idd);
 	if (ret)
@@ -2911,13 +2911,13 @@ int ioc4_serial_init(void)
 	if ((ret = uart_register_driver(&ioc4_uart_rs232)) < 0) {
 		printk(KERN_WARNING
 			"%s: Couldn't register rs232 IOC4 serial driver\n",
-			__FUNCTION__);
+			__func__);
 		return ret;
 	}
 	if ((ret = uart_register_driver(&ioc4_uart_rs422)) < 0) {
 		printk(KERN_WARNING
 			"%s: Couldn't register rs422 IOC4 serial driver\n",
-			__FUNCTION__);
+			__func__);
 		return ret;
 	}
 
diff --git a/drivers/serial/s3c2410.c b/drivers/serial/s3c2410.c
index 45de193..7131e68 100644
--- a/drivers/serial/s3c2410.c
+++ b/drivers/serial/s3c2410.c
@@ -1093,13 +1093,13 @@ static int s3c24xx_serial_probe(struct platform_device *dev,
 	ourport = &s3c24xx_serial_ports[probe_index];
 	probe_index++;
 
-	dbg("%s: initialising port %p...\n", __FUNCTION__, ourport);
+	dbg("%s: initialising port %p...\n", __func__, ourport);
 
 	ret = s3c24xx_serial_init_port(ourport, info, dev);
 	if (ret < 0)
 		goto probe_err;
 
-	dbg("%s: adding port\n", __FUNCTION__);
+	dbg("%s: adding port\n", __func__);
 	uart_add_one_port(&s3c24xx_uart_drv, &ourport->port);
 	platform_set_drvdata(dev, &ourport->port);
 
@@ -1584,7 +1584,7 @@ static int s3c2412_serial_resetport(struct uart_port *port,
 	unsigned long ucon = rd_regl(port, S3C2410_UCON);
 
 	dbg("%s: port=%p (%08lx), cfg=%p\n",
-	    __FUNCTION__, port, port->mapbase, cfg);
+	    __func__, port, port->mapbase, cfg);
 
 	/* ensure we don't change the clock settings... */
 
diff --git a/drivers/serial/sa1100.c b/drivers/serial/sa1100.c
index 58a83c2..066587e 100644
--- a/drivers/serial/sa1100.c
+++ b/drivers/serial/sa1100.c
@@ -655,7 +655,7 @@ void __init sa1100_register_uart_fns(struct sa1100_port_fns *fns)
 void __init sa1100_register_uart(int idx, int port)
 {
 	if (idx >= NR_PORTS) {
-		printk(KERN_ERR "%s: bad index number %d\n", __FUNCTION__, idx);
+		printk(KERN_ERR "%s: bad index number %d\n", __func__, idx);
 		return;
 	}
 
@@ -682,7 +682,7 @@ void __init sa1100_register_uart(int idx, int port)
 		break;
 
 	default:
-		printk(KERN_ERR "%s: bad port number %d\n", __FUNCTION__, port);
+		printk(KERN_ERR "%s: bad port number %d\n", __func__, port);
 	}
 }
 
diff --git a/drivers/serial/sh-sci.c b/drivers/serial/sh-sci.c
index a8c116b..ed8ab28 100644
--- a/drivers/serial/sh-sci.c
+++ b/drivers/serial/sh-sci.c
@@ -850,7 +850,7 @@ static int sci_notifier(struct notifier_block *self,
 
 		printk(KERN_INFO "%s: got a postchange notification "
 		       "for cpu %d (old %d, new %d)\n",
-		       __FUNCTION__, freqs->cpu, freqs->old, freqs->new);
+		       __func__, freqs->cpu, freqs->old, freqs->new);
 	}
 
 	return NOTIFY_OK;
diff --git a/drivers/serial/sn_console.c b/drivers/serial/sn_console.c
index 41fc612..019da2e 100644
--- a/drivers/serial/sn_console.c
+++ b/drivers/serial/sn_console.c
@@ -839,7 +839,7 @@ static int __init sn_sal_module_init(void)
 
 	if (uart_add_one_port(&sal_console_uart, &sal_console_port.sc_port) < 0) {
 		/* error - not sure what I'd do - so I'll do nothing */
-		printk(KERN_ERR "%s: unable to add port\n", __FUNCTION__);
+		printk(KERN_ERR "%s: unable to add port\n", __func__);
 	}
 
 	/* when this driver is compiled in, the console initialization
diff --git a/drivers/serial/uartlite.c b/drivers/serial/uartlite.c
index 4e06ab6..91c17c4 100644
--- a/drivers/serial/uartlite.c
+++ b/drivers/serial/uartlite.c
@@ -581,7 +581,7 @@ ulite_of_probe(struct of_device *op, const struct of_device_id *match)
 	const unsigned int *id;
 	int irq, rc;
 
-	dev_dbg(&op->dev, "%s(%p, %p)\n", __FUNCTION__, op, match);
+	dev_dbg(&op->dev, "%s(%p, %p)\n", __func__, op, match);
 
 	rc = of_address_to_resource(op->node, 0, &res);
 	if (rc) {
diff --git a/drivers/serial/ucc_uart.c b/drivers/serial/ucc_uart.c
index e0994f0..56fe947 100644
--- a/drivers/serial/ucc_uart.c
+++ b/drivers/serial/ucc_uart.c
@@ -215,7 +215,7 @@ static inline dma_addr_t cpu2qe_addr(void *addr, struct uart_qe_port *qe_port)
 		return qe_port->bd_dma_addr + (addr - qe_port->bd_virt);
 
 	/* something nasty happened */
-	printk(KERN_ERR "%s: addr=%p\n", __FUNCTION__, addr);
+	printk(KERN_ERR "%s: addr=%p\n", __func__, addr);
 	BUG();
 	return 0;
 }
@@ -234,7 +234,7 @@ static inline void *qe2cpu_addr(dma_addr_t addr, struct uart_qe_port *qe_port)
 		return qe_port->bd_virt + (addr - qe_port->bd_dma_addr);
 
 	/* something nasty happened */
-	printk(KERN_ERR "%s: addr=%x\n", __FUNCTION__, addr);
+	printk(KERN_ERR "%s: addr=%x\n", __func__, addr);
 	BUG();
 	return NULL;
 }
-- 
1.5.4.3.500.g83a2c


