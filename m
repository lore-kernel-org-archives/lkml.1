Return-Path: <linux-kernel-owner+w=401wt.eu-S1755570AbYGUWVG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755570AbYGUWVG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2008 18:21:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752821AbYGUWUz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jul 2008 18:20:55 -0400
Received: from mx1.redhat.com ([66.187.233.31]:56927 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752787AbYGUWUz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2008 18:20:55 -0400
Date: Mon, 21 Jul 2008 18:13:55 -0400
From: Dave Jones <davej@redhat.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: Fix icom serial compile.
Message-ID: <20080721221355.GD3472@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>
References: <20080721211659.GA29106@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080721211659.GA29106@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

drivers/serial/icom.c: In function 'recv_interrupt':
drivers/serial/icom.c:733: error: 'struct uart_info' has no member named 'tty'

Signed-off-by: Dave Jones <davej@redhat.com>

--- linux-2.6.26.noarch/drivers/serial/icom.c~	2008-07-21 18:08:30.000000000 -0400
+++ linux-2.6.26.noarch/drivers/serial/icom.c	2008-07-21 18:13:00.000000000 -0400
@@ -730,7 +730,7 @@ static void xmit_interrupt(u16 port_int_
 static void recv_interrupt(u16 port_int_reg, struct icom_port *icom_port)
 {
 	short int count, rcv_buff;
-	struct tty_struct *tty = icom_port->uart_port.info->tty;
+	struct tty_struct *tty = icom_port->uart_port.info->port.tty;
 	unsigned short int status;
 	struct uart_icount *icount;
 	unsigned long offset;

-- 
http://www.codemonkey.org.uk
