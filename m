Return-Path: <linux-kernel-owner+w=401wt.eu-S1757024AbYJEQPc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757024AbYJEQPc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Oct 2008 12:15:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755639AbYJEQIz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Oct 2008 12:08:55 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:48472 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756745AbYJEQIx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Oct 2008 12:08:53 -0400
From: Alan Cox <alan@redhat.com>
Subject: [PATCH 30/76] 8250: remove a few inlines of dubious value
To: linux-kernel@vger.kernel.org
Date: Sun, 05 Oct 2008 17:08:53 +0100
Message-ID: <20081005160846.1997.43165.stgit@localhost.localdomain>
In-Reply-To: <20081005160231.1997.10462.stgit@localhost.localdomain>
References: <20081005160231.1997.10462.stgit@localhost.localdomain>
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
index 9f5e60d..e898edf 100644
--- a/drivers/serial/8250.c
+++ b/drivers/serial/8250.c
@@ -540,7 +540,7 @@ static unsigned int serial_icr_read(struct uart_8250_port *up, int offset)
 /*
  * FIFO support.
  */
-static inline void serial8250_clear_fifos(struct uart_8250_port *p)
+static void serial8250_clear_fifos(struct uart_8250_port *p)
 {
 	if (p->capabilities & UART_CAP_FIFO) {
 		serial_outp(p, UART_FCR, UART_FCR_ENABLE_FIFO);
@@ -555,7 +555,7 @@ static inline void serial8250_clear_fifos(struct uart_8250_port *p)
  * capability" bit enabled.  Note that on XR16C850s, we need to
  * reset LCR to write to IER.
  */
-static inline void serial8250_set_sleep(struct uart_8250_port *p, int sleep)
+static void serial8250_set_sleep(struct uart_8250_port *p, int sleep)
 {
 	if (p->capabilities & UART_CAP_SLEEP) {
 		if (p->capabilities & UART_CAP_EFR) {
@@ -1428,8 +1428,7 @@ static unsigned int check_modem_status(struct uart_8250_port *up)
 /*
  * This handles the interrupt from one port.
  */
-static inline void
-serial8250_handle_port(struct uart_8250_port *up)
+static void serial8250_handle_port(struct uart_8250_port *up)
 {
 	unsigned int status;
 	unsigned long flags;
@@ -1764,7 +1763,7 @@ static void serial8250_break_ctl(struct uart_port *port, int break_state)
 /*
  *	Wait for transmitter & holding register to empty
  */
-static inline void wait_for_xmitr(struct uart_8250_port *up, int bits)
+static void wait_for_xmitr(struct uart_8250_port *up, int bits)
 {
 	unsigned int status, tmout = 10000;
 

