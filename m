Return-Path: <linux-kernel-owner+w=401wt.eu-S1751295AbXCJWVU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751295AbXCJWVU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Mar 2007 17:21:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751299AbXCJWVU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Mar 2007 17:21:20 -0500
Received: from nic.NetDirect.CA ([216.16.235.2]:50696 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751295AbXCJWVT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Mar 2007 17:21:19 -0500
X-Originating-Ip: 74.109.98.130
Date: Sat, 10 Mar 2007 17:18:31 -0500 (EST)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@CPE00045a9c397f-CM001225dbafb6
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
cc: Andrew Morton <akpm@osdl.org>, starvik@axis.com
Subject: [PATCH] CRIS: Delete unused header file.
Message-ID: <Pine.LNX.4.64.0703101717140.28739@CPE00045a9c397f-CM001225dbafb6>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Net-Direct-Inc-MailScanner-Information: Please contact the ISP for more information
X-Net-Direct-Inc-MailScanner: Found to be clean
X-Net-Direct-Inc-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
	score=-16.8, required 5, autolearn=not spam, ALL_TRUSTED -1.80,
	BAYES_00 -15.00)
X-Net-Direct-Inc-MailScanner-From: rpjday@mindspring.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


  Delete apparently unused header file drivers/serial/crisv10.h.

Signed-off-by: Robert P. J. Day <rpjday@mindspring.com>

---

diff --git a/drivers/serial/crisv10.h b/drivers/serial/crisv10.h
deleted file mode 100644
index 4a23340..0000000
--- a/drivers/serial/crisv10.h
+++ /dev/null
@@ -1,136 +0,0 @@
-/*
- * serial.h: Arch-dep definitions for the Etrax100 serial driver.
- *
- * Copyright (C) 1998, 1999, 2000 Axis Communications AB
- */
-
-#ifndef _ETRAX_SERIAL_H
-#define _ETRAX_SERIAL_H
-
-#include <linux/circ_buf.h>
-#include <asm/termios.h>
-
-/* Software state per channel */
-
-#ifdef __KERNEL__
-/*
- * This is our internal structure for each serial port's state.
- *
- * Many fields are paralleled by the structure used by the serial_struct
- * structure.
- *
- * For definitions of the flags field, see tty.h
- */
-
-#define SERIAL_RECV_DESCRIPTORS 8
-
-struct etrax_recv_buffer {
-	struct etrax_recv_buffer *next;
-	unsigned short length;
-	unsigned char error;
-	unsigned char pad;
-
-	unsigned char buffer[0];
-};
-
-struct e100_serial {
-	int			baud;
-	volatile u8		*port; /* R_SERIALx_CTRL */
-	u32			irq;  /* bitnr in R_IRQ_MASK2 for dmaX_descr */
-
-	/* Output registers */
-	volatile u8		*oclrintradr; /* adr to R_DMA_CHx_CLR_INTR */
-	volatile u32		*ofirstadr;   /* adr to R_DMA_CHx_FIRST */
-	volatile u8		*ocmdadr;     /* adr to R_DMA_CHx_CMD */
-	const volatile u8	*ostatusadr;  /* adr to R_DMA_CHx_STATUS */
-
-	/* Input registers */
-	volatile u8		*iclrintradr; /* adr to R_DMA_CHx_CLR_INTR */
-	volatile u32		*ifirstadr;   /* adr to R_DMA_CHx_FIRST */
-	volatile u8		*icmdadr;     /* adr to R_DMA_CHx_CMD */
-	volatile u32		*idescradr;   /* adr to R_DMA_CHx_DESCR */
-
-	int			flags;	/* defined in tty.h */
-
-	u8			rx_ctrl; /* shadow for R_SERIALx_REC_CTRL */
-	u8			tx_ctrl; /* shadow for R_SERIALx_TR_CTRL */
-	u8			iseteop; /* bit number for R_SET_EOP for the input dma */
-	int			enabled; /* Set to 1 if the port is enabled in HW config */
-
-	u8		dma_out_enabled:1; /* Set to 1 if DMA should be used */
-	u8		dma_in_enabled:1;  /* Set to 1 if DMA should be used */
-
-	/* end of fields defined in rs_table[] in .c-file */
-	u8		uses_dma_in;  /* Set to 1 if DMA is used */
-	u8		uses_dma_out; /* Set to 1 if DMA is used */
-	u8		forced_eop;   /* a fifo eop has been forced */
-	int			baud_base;     /* For special baudrates */
-	int			custom_divisor; /* For special baudrates */
-	struct etrax_dma_descr	tr_descr;
-	struct etrax_dma_descr	rec_descr[SERIAL_RECV_DESCRIPTORS];
-	int			cur_rec_descr;
-
-	volatile int		tr_running; /* 1 if output is running */
-
-	struct tty_struct	*tty;
-	int			read_status_mask;
-	int			ignore_status_mask;
-	int			x_char;	/* xon/xoff character */
-	int			close_delay;
-	unsigned short		closing_wait;
-	unsigned short		closing_wait2;
-	unsigned long		event;
-	unsigned long		last_active;
-	int			line;
-	int			type;  /* PORT_ETRAX */
-	int			count;	    /* # of fd on device */
-	int			blocked_open; /* # of blocked opens */
-	struct circ_buf		xmit;
-	struct etrax_recv_buffer *first_recv_buffer;
-	struct etrax_recv_buffer *last_recv_buffer;
-	unsigned int		recv_cnt;
-	unsigned int		max_recv_cnt;
-
-	struct work_struct	work;
-	struct async_icount	icount;   /* error-statistics etc.*/
-	struct ktermios		normal_termios;
-	struct ktermios		callout_termios;
-#ifdef DECLARE_WAITQUEUE
-	wait_queue_head_t	open_wait;
-	wait_queue_head_t	close_wait;
-#else
-	struct wait_queue	*open_wait;
-	struct wait_queue	*close_wait;
-#endif
-
-	unsigned long		char_time_usec;       /* The time for 1 char, in usecs */
-	unsigned long		flush_time_usec;      /* How often we should flush */
-	unsigned long		last_tx_active_usec;  /* Last tx usec in the jiffies */
-	unsigned long		last_tx_active;       /* Last tx time in jiffies */
-	unsigned long		last_rx_active_usec;  /* Last rx usec in the jiffies */
-	unsigned long		last_rx_active;       /* Last rx time in jiffies */
-
-	int			break_detected_cnt;
-	int			errorcode;
-
-#ifdef CONFIG_ETRAX_RS485
-	struct rs485_control	rs485;  /* RS-485 support */
-#endif
-};
-
-/* this PORT is not in the standard serial.h. it's not actually used for
- * anything since we only have one type of async serial-port anyway in this
- * system.
- */
-
-#define PORT_ETRAX 1
-
-/*
- * Events are used to schedule things to happen at timer-interrupt
- * time, instead of at rs interrupt time.
- */
-#define RS_EVENT_WRITE_WAKEUP	0
-
-#endif /* __KERNEL__ */
-
-#endif /* !_ETRAX_SERIAL_H */
-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://fsdev.net/wiki/index.php?title=Main_Page
========================================================================
