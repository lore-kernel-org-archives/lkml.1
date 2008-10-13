Return-Path: <linux-kernel-owner+w=401wt.eu-S1762465AbYJMJmy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762465AbYJMJmy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2008 05:42:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760510AbYJMJg0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Oct 2008 05:36:26 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:48618 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1760496AbYJMJgZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2008 05:36:25 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 28/80] 8250: remove a few inlines of dubious value
To: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
Date: Mon, 13 Oct 2008 10:36:21 +0100
Message-ID: <20081013093616.21645.80710.stgit@localhost.localdomain>
In-Reply-To: <20081013092758.21645.2359.stgit@localhost.localdomain>
References: <20081013092758.21645.2359.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: \\\"Will Newton\\\" <will.newton@gmail.com>

Remove some inlines from various functions that are called once, are too
big to inline, or are called only from slow path code.  This saves around
300 bytes of code for me.

Signed-off-by: Will Newton <will.newton@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Alan Cox <alan@redhat.com>
---

 drivers/serial/8250.c |    9 ++++-----
 1 files changed, 4 insertions(+), 5 deletions(-)


diff --git a/drivers/serial/8250.c b/drivers/serial/8250.c
index 9ccc563..ed593c4 100644
--- a/drivers/serial/8250.c
+++ b/drivers/serial/8250.c
@@ -536,7 +536,7 @@ static unsigned int serial_icr_read(struct uart_8250_port *up, int offset)
 /*
  * FIFO support.
  */
-static inline void serial8250_clear_fifos(struct uart_8250_port *p)
+static void serial8250_clear_fifos(struct uart_8250_port *p)
 {
 	if (p->capabilities & UART_CAP_FIFO) {
 		serial_outp(p, UART_FCR, UART_FCR_ENABLE_FIFO);
@@ -551,7 +551,7 @@ static inline void serial8250_clear_fifos(struct uart_8250_port *p)
  * capability" bit enabled.  Note that on XR16C850s, we need to
  * reset LCR to write to IER.
  */
-static inline void serial8250_set_sleep(struct uart_8250_port *p, int sleep)
+static void serial8250_set_sleep(struct uart_8250_port *p, int sleep)
 {
 	if (p->capabilities & UART_CAP_SLEEP) {
 		if (p->capabilities & UART_CAP_EFR) {
@@ -1424,8 +1424,7 @@ static unsigned int check_modem_status(struct uart_8250_port *up)
 /*
  * This handles the interrupt from one port.
  */
-static inline void
-serial8250_handle_port(struct uart_8250_port *up)
+static void serial8250_handle_port(struct uart_8250_port *up)
 {
 	unsigned int status;
 	unsigned long flags;
@@ -1719,7 +1718,7 @@ static void serial8250_break_ctl(struct uart_port *port, int break_state)
 /*
  *	Wait for transmitter & holding register to empty
  */
-static inline void wait_for_xmitr(struct uart_8250_port *up, int bits)
+static void wait_for_xmitr(struct uart_8250_port *up, int bits)
 {
 	unsigned int status, tmout = 10000;
 

