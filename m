Return-Path: <linux-kernel-owner+w=401wt.eu-S2992433AbXCOXVM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992433AbXCOXVM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2007 19:21:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992434AbXCOXVM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Mar 2007 19:21:12 -0400
Received: from mail.gmx.net ([213.165.64.20]:42437 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S2992433AbXCOXVJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2007 19:21:09 -0400
X-Provags-ID: V01U2FsdGVkX19Xo4EwqaNXi/EbLuuW5TQlVlLWdL6LSeLEWaNS5D
	pktBBZhVO8zP/j
Date: Fri, 16 Mar 2007 00:21:03 +0100
From: Klaus Kudielka <klaus.kudielka@gmx.net>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Klaus Kudielka <klaus.kudielka@gmx.net>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fix cyclades.h for x86_64 (and probably others)
Message-ID: <20070315232103.GA24861@mars.oe1kib.ampr.org>
References: <20070314215746.GA7781@mars.oe1kib.ampr.org> <20070315110708.ed5ca541.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="VS++wcV0S1rZb1Fb"
Content-Disposition: inline
In-Reply-To: <20070315110708.ed5ca541.akpm@linux-foundation.org>
User-Agent: Mutt/1.4.2.2i
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--VS++wcV0S1rZb1Fb
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Mar 15, 2007 at 11:07:08AM -0800, Andrew Morton wrote:
> Looks OK, thanks.
> 
> It would be nice as a followup patch to simply remove ucchar, uclong and
> all that gunk altogether from that driver  and just use u8, u16 etc.
> 
> But if you decide to do that, please fix your email client first - it is
> replacing tabs with spaces.

Something like this? Applies & compiles Ok on 2.6.20.
I don't have access to the hardware right now, but am pretty sure that
the result is the same.

BTW, it was a copy-paste which made the spaces ;)

Regards, Klaus


--VS++wcV0S1rZb1Fb
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="cyclades-patch-x86_64-v2.txt"

--- include/linux/cyclades.h.orig	2007-03-15 23:46:00.000000000 +0100
+++ include/linux/cyclades.h	2007-03-15 23:14:26.000000000 +0100
@@ -67,6 +67,8 @@
 #ifndef _LINUX_CYCLADES_H
 #define _LINUX_CYCLADES_H
 
+#include <linux/types.h>
+
 struct cyclades_monitor {
         unsigned long           int_count;
         unsigned long           char_count;
@@ -149,15 +151,6 @@
  *	architectures and compilers.
  */
 
-#if defined(__alpha__)
-typedef unsigned long	ucdouble;	/* 64 bits, unsigned */
-typedef unsigned int	uclong;		/* 32 bits, unsigned */
-#else
-typedef unsigned long	uclong;		/* 32 bits, unsigned */
-#endif
-typedef unsigned short	ucshort;	/* 16 bits, unsigned */
-typedef unsigned char	ucchar;		/* 8 bits, unsigned */
-
 /*
  *	Memory Window Sizes
  */
@@ -174,24 +167,24 @@
  */
 
 struct	CUSTOM_REG {
-	uclong	fpga_id;		/* FPGA Identification Register */
-	uclong	fpga_version;		/* FPGA Version Number Register */
-	uclong	cpu_start;		/* CPU start Register (write) */
-	uclong	cpu_stop;		/* CPU stop Register (write) */
-	uclong	misc_reg;		/* Miscelaneous Register */
-	uclong	idt_mode;		/* IDT mode Register */
-	uclong	uart_irq_status;	/* UART IRQ status Register */
-	uclong	clear_timer0_irq;	/* Clear timer interrupt Register */
-	uclong	clear_timer1_irq;	/* Clear timer interrupt Register */
-	uclong	clear_timer2_irq;	/* Clear timer interrupt Register */
-	uclong	test_register;		/* Test Register */
-	uclong	test_count;		/* Test Count Register */
-	uclong	timer_select;		/* Timer select register */
-	uclong	pr_uart_irq_status;	/* Prioritized UART IRQ stat Reg */
-	uclong	ram_wait_state;		/* RAM wait-state Register */
-	uclong	uart_wait_state;	/* UART wait-state Register */
-	uclong	timer_wait_state;	/* timer wait-state Register */
-	uclong	ack_wait_state;		/* ACK wait State Register */
+	__u32	fpga_id;		/* FPGA Identification Register */
+	__u32	fpga_version;		/* FPGA Version Number Register */
+	__u32	cpu_start;		/* CPU start Register (write) */
+	__u32	cpu_stop;		/* CPU stop Register (write) */
+	__u32	misc_reg;		/* Miscelaneous Register */
+	__u32	idt_mode;		/* IDT mode Register */
+	__u32	uart_irq_status;	/* UART IRQ status Register */
+	__u32	clear_timer0_irq;	/* Clear timer interrupt Register */
+	__u32	clear_timer1_irq;	/* Clear timer interrupt Register */
+	__u32	clear_timer2_irq;	/* Clear timer interrupt Register */
+	__u32	test_register;		/* Test Register */
+	__u32	test_count;		/* Test Count Register */
+	__u32	timer_select;		/* Timer select register */
+	__u32	pr_uart_irq_status;	/* Prioritized UART IRQ stat Reg */
+	__u32	ram_wait_state;		/* RAM wait-state Register */
+	__u32	uart_wait_state;	/* UART wait-state Register */
+	__u32	timer_wait_state;	/* timer wait-state Register */
+	__u32	ack_wait_state;		/* ACK wait State Register */
 };
 
 /*
@@ -201,34 +194,34 @@
  */
 
 struct RUNTIME_9060 {
-	uclong	loc_addr_range;	/* 00h - Local Address Range */
-	uclong	loc_addr_base;	/* 04h - Local Address Base */
-	uclong	loc_arbitr;	/* 08h - Local Arbitration */
-	uclong	endian_descr;	/* 0Ch - Big/Little Endian Descriptor */
-	uclong	loc_rom_range;	/* 10h - Local ROM Range */
-	uclong	loc_rom_base;	/* 14h - Local ROM Base */
-	uclong	loc_bus_descr;	/* 18h - Local Bus descriptor */
-	uclong	loc_range_mst;	/* 1Ch - Local Range for Master to PCI */
-	uclong	loc_base_mst;	/* 20h - Local Base for Master PCI */
-	uclong	loc_range_io;	/* 24h - Local Range for Master IO */
-	uclong	pci_base_mst;	/* 28h - PCI Base for Master PCI */
-	uclong	pci_conf_io;	/* 2Ch - PCI configuration for Master IO */
-	uclong	filler1;	/* 30h */
-	uclong	filler2;	/* 34h */
-	uclong	filler3;	/* 38h */
-	uclong	filler4;	/* 3Ch */
-	uclong	mail_box_0;	/* 40h - Mail Box 0 */
-	uclong	mail_box_1;	/* 44h - Mail Box 1 */
-	uclong	mail_box_2;	/* 48h - Mail Box 2 */
-	uclong	mail_box_3;	/* 4Ch - Mail Box 3 */
-	uclong	filler5;	/* 50h */
-	uclong	filler6;	/* 54h */
-	uclong	filler7;	/* 58h */
-	uclong	filler8;	/* 5Ch */
-	uclong	pci_doorbell;	/* 60h - PCI to Local Doorbell */
-	uclong	loc_doorbell;	/* 64h - Local to PCI Doorbell */
-	uclong	intr_ctrl_stat;	/* 68h - Interrupt Control/Status */
-	uclong	init_ctrl;	/* 6Ch - EEPROM control, Init Control, etc */
+	__u32	loc_addr_range;	/* 00h - Local Address Range */
+	__u32	loc_addr_base;	/* 04h - Local Address Base */
+	__u32	loc_arbitr;	/* 08h - Local Arbitration */
+	__u32	endian_descr;	/* 0Ch - Big/Little Endian Descriptor */
+	__u32	loc_rom_range;	/* 10h - Local ROM Range */
+	__u32	loc_rom_base;	/* 14h - Local ROM Base */
+	__u32	loc_bus_descr;	/* 18h - Local Bus descriptor */
+	__u32	loc_range_mst;	/* 1Ch - Local Range for Master to PCI */
+	__u32	loc_base_mst;	/* 20h - Local Base for Master PCI */
+	__u32	loc_range_io;	/* 24h - Local Range for Master IO */
+	__u32	pci_base_mst;	/* 28h - PCI Base for Master PCI */
+	__u32	pci_conf_io;	/* 2Ch - PCI configuration for Master IO */
+	__u32	filler1;	/* 30h */
+	__u32	filler2;	/* 34h */
+	__u32	filler3;	/* 38h */
+	__u32	filler4;	/* 3Ch */
+	__u32	mail_box_0;	/* 40h - Mail Box 0 */
+	__u32	mail_box_1;	/* 44h - Mail Box 1 */
+	__u32	mail_box_2;	/* 48h - Mail Box 2 */
+	__u32	mail_box_3;	/* 4Ch - Mail Box 3 */
+	__u32	filler5;	/* 50h */
+	__u32	filler6;	/* 54h */
+	__u32	filler7;	/* 58h */
+	__u32	filler8;	/* 5Ch */
+	__u32	pci_doorbell;	/* 60h - PCI to Local Doorbell */
+	__u32	loc_doorbell;	/* 64h - Local to PCI Doorbell */
+	__u32	intr_ctrl_stat;	/* 68h - Interrupt Control/Status */
+	__u32	init_ctrl;	/* 6Ch - EEPROM control, Init Control, etc */
 };
 
 /* Values for the Local Base Address re-map register */
@@ -270,8 +263,8 @@
 #define	ZF_TINACT	ZF_TINACT_DEF
 
 struct	FIRM_ID {
-	uclong	signature;		/* ZFIRM/U signature */
-	uclong	zfwctrl_addr;		/* pointer to ZFW_CTRL structure */
+	__u32	signature;		/* ZFIRM/U signature */
+	__u32	zfwctrl_addr;		/* pointer to ZFW_CTRL structure */
 };
 
 /* Op. System id */
@@ -408,24 +401,24 @@
  */
 
 struct CH_CTRL {
-	uclong	op_mode;	/* operation mode */
-	uclong	intr_enable;	/* interrupt masking */
-	uclong	sw_flow;	/* SW flow control */
-	uclong	flow_status;	/* output flow status */
-	uclong	comm_baud;	/* baud rate  - numerically specified */
-	uclong	comm_parity;	/* parity */
-	uclong	comm_data_l;	/* data length/stop */
-	uclong	comm_flags;	/* other flags */
-	uclong	hw_flow;	/* HW flow control */
-	uclong	rs_control;	/* RS-232 outputs */
-	uclong	rs_status;	/* RS-232 inputs */
-	uclong	flow_xon;	/* xon char */
-	uclong	flow_xoff;	/* xoff char */
-	uclong	hw_overflow;	/* hw overflow counter */
-	uclong	sw_overflow;	/* sw overflow counter */
-	uclong	comm_error;	/* frame/parity error counter */
-	uclong ichar;
-	uclong filler[7];
+	__u32	op_mode;	/* operation mode */
+	__u32	intr_enable;	/* interrupt masking */
+	__u32	sw_flow;	/* SW flow control */
+	__u32	flow_status;	/* output flow status */
+	__u32	comm_baud;	/* baud rate  - numerically specified */
+	__u32	comm_parity;	/* parity */
+	__u32	comm_data_l;	/* data length/stop */
+	__u32	comm_flags;	/* other flags */
+	__u32	hw_flow;	/* HW flow control */
+	__u32	rs_control;	/* RS-232 outputs */
+	__u32	rs_status;	/* RS-232 inputs */
+	__u32	flow_xon;	/* xon char */
+	__u32	flow_xoff;	/* xoff char */
+	__u32	hw_overflow;	/* hw overflow counter */
+	__u32	sw_overflow;	/* sw overflow counter */
+	__u32	comm_error;	/* frame/parity error counter */
+	__u32 ichar;
+	__u32 filler[7];
 };
 
 
@@ -435,18 +428,18 @@
  */
 
 struct	BUF_CTRL	{
-	uclong	flag_dma;	/* buffers are in Host memory */
-	uclong	tx_bufaddr;	/* address of the tx buffer */
-	uclong	tx_bufsize;	/* tx buffer size */
-	uclong	tx_threshold;	/* tx low water mark */
-	uclong	tx_get;		/* tail index tx buf */
-	uclong	tx_put;		/* head index tx buf */
-	uclong	rx_bufaddr;	/* address of the rx buffer */
-	uclong	rx_bufsize;	/* rx buffer size */
-	uclong	rx_threshold;	/* rx high water mark */
-	uclong	rx_get;		/* tail index rx buf */
-	uclong	rx_put;		/* head index rx buf */
-	uclong	filler[5];	/* filler to align structures */
+	__u32	flag_dma;	/* buffers are in Host memory */
+	__u32	tx_bufaddr;	/* address of the tx buffer */
+	__u32	tx_bufsize;	/* tx buffer size */
+	__u32	tx_threshold;	/* tx low water mark */
+	__u32	tx_get;		/* tail index tx buf */
+	__u32	tx_put;		/* head index tx buf */
+	__u32	rx_bufaddr;	/* address of the rx buffer */
+	__u32	rx_bufsize;	/* rx buffer size */
+	__u32	rx_threshold;	/* rx high water mark */
+	__u32	rx_get;		/* tail index rx buf */
+	__u32	rx_put;		/* head index rx buf */
+	__u32	filler[5];	/* filler to align structures */
 };
 
 /*
@@ -457,27 +450,27 @@
 struct BOARD_CTRL {
 
 	/* static info provided by the on-board CPU */
-	uclong	n_channel;	/* number of channels */
-	uclong	fw_version;	/* firmware version */
+	__u32	n_channel;	/* number of channels */
+	__u32	fw_version;	/* firmware version */
 
 	/* static info provided by the driver */
-	uclong	op_system;	/* op_system id */
-	uclong	dr_version;	/* driver version */
+	__u32	op_system;	/* op_system id */
+	__u32	dr_version;	/* driver version */
 
 	/* board control area */
-	uclong	inactivity;	/* inactivity control */
+	__u32	inactivity;	/* inactivity control */
 
 	/* host to FW commands */
-	uclong	hcmd_channel;	/* channel number */
-	uclong	hcmd_param;	/* pointer to parameters */
+	__u32	hcmd_channel;	/* channel number */
+	__u32	hcmd_param;	/* pointer to parameters */
 
 	/* FW to Host commands */
-	uclong	fwcmd_channel;	/* channel number */
-	uclong	fwcmd_param;	/* pointer to parameters */
-	uclong	zf_int_queue_addr; /* offset for INT_QUEUE structure */
+	__u32	fwcmd_channel;	/* channel number */
+	__u32	fwcmd_param;	/* pointer to parameters */
+	__u32	zf_int_queue_addr; /* offset for INT_QUEUE structure */
 
 	/* filler so the structures are aligned */
-	uclong	filler[6];
+	__u32	filler[6];
 };
 
 /* Host Interrupt Queue */
--- drivers/char/cyclades.c.orig	2007-03-15 23:45:08.000000000 +0100
+++ drivers/char/cyclades.c	2007-03-15 23:48:00.000000000 +0100
@@ -669,7 +669,6 @@
 		spin_unlock_irqrestore(&cy_card[info->card].card_lock, flags); \
 		} while (0)
 
-#include <linux/types.h>
 #include <linux/kernel.h>
 #include <linux/pci.h>
 
@@ -844,7 +843,7 @@
 
 static void cy_start(struct tty_struct *);
 static void set_line_char(struct cyclades_port *);
-static int cyz_issue_cmd(struct cyclades_card *, uclong, ucchar, uclong);
+static int cyz_issue_cmd(struct cyclades_card *, __u32, __u8, __u32);
 #ifdef CONFIG_ISA
 static unsigned detect_isa_irq(void __iomem *);
 #endif				/* CONFIG_ISA */
@@ -1497,7 +1496,7 @@
 
 static int
 cyz_fetch_msg(struct cyclades_card *cinfo,
-		uclong * channel, ucchar * cmd, uclong * param)
+		__u32 * channel, __u8 * cmd, __u32 * param)
 {
 	struct FIRM_ID __iomem *firm_id;
 	struct ZFW_CTRL __iomem *zfw_ctrl;
@@ -1517,7 +1516,7 @@
 	if (loc_doorbell) {
 		*cmd = (char)(0xff & loc_doorbell);
 		*channel = cy_readl(&board_ctrl->fwcmd_channel);
-		*param = (uclong) cy_readl(&board_ctrl->fwcmd_param);
+		*param = (__u32) cy_readl(&board_ctrl->fwcmd_param);
 		cy_writel(&((struct RUNTIME_9060 __iomem *)(cinfo->ctl_addr))->
 			  loc_doorbell, 0xffffffff);
 		return 1;
@@ -1527,12 +1526,12 @@
 
 static int
 cyz_issue_cmd(struct cyclades_card *cinfo,
-		uclong channel, ucchar cmd, uclong param)
+		__u32 channel, __u8 cmd, __u32 param)
 {
 	struct FIRM_ID __iomem *firm_id;
 	struct ZFW_CTRL __iomem *zfw_ctrl;
 	struct BOARD_CTRL __iomem *board_ctrl;
-	unsigned long __iomem *pci_doorbell;
+	__u32 __iomem *pci_doorbell;
 	int index;
 
 	firm_id = cinfo->base_addr + ID_ADDRESS;
@@ -1573,7 +1572,7 @@
 #else
 	char data;
 #endif
-	volatile uclong rx_put, rx_get, new_rx_get, rx_bufsize, rx_bufaddr;
+	volatile __u32 rx_put, rx_get, new_rx_get, rx_bufsize, rx_bufaddr;
 
 	rx_get = new_rx_get = cy_readl(&buf_ctrl->rx_get);
 	rx_put = cy_readl(&buf_ctrl->rx_put);
@@ -1669,7 +1668,7 @@
 #ifdef BLOCKMOVE
 	int small_count;
 #endif
-	volatile uclong tx_put, tx_get, tx_bufsize, tx_bufaddr;
+	volatile __u32 tx_put, tx_get, tx_bufsize, tx_bufaddr;
 
 	if (info->xmit_cnt <= 0)	/* Nothing to transmit */
 		return;
@@ -1754,10 +1753,10 @@
 	static volatile struct BOARD_CTRL __iomem *board_ctrl;
 	static volatile struct CH_CTRL __iomem *ch_ctrl;
 	static volatile struct BUF_CTRL __iomem *buf_ctrl;
-	uclong channel;
-	ucchar cmd;
-	uclong param;
-	uclong hw_ver, fw_ver;
+	__u32 channel;
+	__u8 cmd;
+	__u32 param;
+	__u32 hw_ver, fw_ver;
 	int special_count;
 	int delta_count;
 
@@ -1891,7 +1890,7 @@
 	struct cyclades_port *info = (struct cyclades_port *)arg;
 	int retval;
 	int card = info->card;
-	uclong channel = (info->line) - (cy_card[card].first_line);
+	__u32 channel = (info->line) - (cy_card[card].first_line);
 	unsigned long flags;
 
 	CY_LOCK(info, flags);
@@ -2288,7 +2287,7 @@
 
 		if (!info->tty || (info->tty->termios->c_cflag & HUPCL)) {
 			cy_writel(&ch_ctrl[channel].rs_control,
-				(uclong)(cy_readl(&ch_ctrl[channel].rs_control)&
+				(__u32)(cy_readl(&ch_ctrl[channel].rs_control)&
 					~(C_RS_RTS | C_RS_DTR)));
 			retval = cyz_issue_cmd(&cy_card[info->card], channel,
 					C_CM_IOCTLM, 0L);
@@ -3025,7 +3024,7 @@
 		static volatile struct CH_CTRL *ch_ctrl;
 		static volatile struct BUF_CTRL *buf_ctrl;
 		int char_count;
-		volatile uclong tx_put, tx_get, tx_bufsize;
+		volatile __u32 tx_put, tx_get, tx_bufsize;
 
 		firm_id = cy_card[card].base_addr + ID_ADDRESS;
 		zfw_ctrl = cy_card[card].base_addr +
@@ -3054,10 +3053,10 @@
  * ------------------------------------------------------------
  */
 
-static void cyy_baud_calc(struct cyclades_port *info, uclong baud)
+static void cyy_baud_calc(struct cyclades_port *info, __u32 baud)
 {
 	int co, co_val, bpr;
-	uclong cy_clock = ((info->chip_rev >= CD1400_REV_J) ? 60000000 :
+	__u32 cy_clock = ((info->chip_rev >= CD1400_REV_J) ? 60000000 :
 			25000000);
 
 	if (baud == 0) {
@@ -3347,7 +3346,7 @@
 		struct BOARD_CTRL __iomem *board_ctrl;
 		struct CH_CTRL __iomem *ch_ctrl;
 		struct BUF_CTRL __iomem *buf_ctrl;
-		uclong sw_flow;
+		__u32 sw_flow;
 		int retval;
 
 		firm_id = cy_card[card].base_addr + ID_ADDRESS;
@@ -4720,7 +4719,7 @@
 #endif				/* CONFIG_ISA */
 }				/* cy_detect_isa */
 
-static void plx_init(void __iomem * addr, uclong initctl)
+static void plx_init(void __iomem * addr, __u32 initctl)
 {
 	/* Reset PLX */
 	cy_writel(addr + initctl, cy_readl(addr + initctl) | 0x40000000);
@@ -4746,14 +4745,14 @@
 	struct pci_dev *pdev = NULL;
 	unsigned char cyy_rev_id;
 	unsigned char cy_pci_irq = 0;
-	uclong cy_pci_phys0, cy_pci_phys2;
+	__u32 cy_pci_phys0, cy_pci_phys2;
 	void __iomem *cy_pci_addr0, *cy_pci_addr2;
 	unsigned short i, j, cy_pci_nchan, plx_ver;
 	unsigned short device_id, dev_index = 0;
-	uclong mailbox;
-	uclong ZeIndex = 0;
+	__u32 mailbox;
+	__u32 ZeIndex = 0;
 	void __iomem *Ze_addr0[NR_CARDS], *Ze_addr2[NR_CARDS];
-	uclong Ze_phys0[NR_CARDS], Ze_phys2[NR_CARDS];
+	__u32 Ze_phys0[NR_CARDS], Ze_phys2[NR_CARDS];
 	unsigned char Ze_irq[NR_CARDS];
 	struct pci_dev *Ze_pdev[NR_CARDS];
 
@@ -4958,7 +4957,7 @@
 						cy_pci_irq);
 
 			mailbox =
-			    (uclong)cy_readl(&((struct RUNTIME_9060 __iomem *)
+			    (__u32)cy_readl(&((struct RUNTIME_9060 __iomem *)
 						cy_pci_addr0)->mail_box_0);
 
 			if (pci_resource_flags(pdev, 2) & IORESOURCE_IO) {
@@ -5121,7 +5120,7 @@
 			Ze_pdev[j] = Ze_pdev[j + 1];
 		}
 		ZeIndex--;
-		mailbox = (uclong)cy_readl(&((struct RUNTIME_9060 __iomem *)
+		mailbox = (__u32)cy_readl(&((struct RUNTIME_9060 __iomem *)
 						cy_pci_addr0)->mail_box_0);
 #ifdef CY_PCI_DEBUG
 		printk("Cyclades-Z/PCI: relocate winaddr=0x%lx ctladdr=0x%lx\n",

--VS++wcV0S1rZb1Fb--
