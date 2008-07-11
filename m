Return-Path: <linux-kernel-owner+w=401wt.eu-S1752232AbYGKOwU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752232AbYGKOwU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2008 10:52:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751017AbYGKOwK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jul 2008 10:52:10 -0400
Received: from mx1.redhat.com ([66.187.233.31]:42448 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751470AbYGKOwJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2008 10:52:09 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH] MN10300: Fix MN10300's serial port driver to get at its
	tty_struct
To: alan@redhat.com, akpm@linux-foundation.org
Cc: dhowells@redhat.com, linux-am33-list@redhat.com,
       linux-kernel@vger.kernel.org
Date: Fri, 11 Jul 2008 15:52:01 +0100
Message-ID: <20080711145201.24870.13609.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix MN10300's serial port driver to get at its tty_struct as this moved from
struct uart_info into struct tty_port in patch:

	commit 2500487cb5b4dbee56e127d699d14101016c5031
	Author: Alan Cox <alan@redhat.com>
	Date:   Fri Jul 11 17:23:39 2008 +1000

	    07-serial-core-use-tty_port

	    Switch the serial_core based drivers to use the new tty_port
	    structure. We can't quite use all of it yet because of the
	    dynamically allocated extras in the serial_core layer.

	    Signed-off-by: Alan Cox <alan@redhat.com>

Signed-off-by: David Howells <dhowells@redhat.com>
---

 arch/mn10300/kernel/mn10300-serial.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)


diff --git a/arch/mn10300/kernel/mn10300-serial.c b/arch/mn10300/kernel/mn10300-serial.c
index b9c268c..8b054e7 100644
--- a/arch/mn10300/kernel/mn10300-serial.c
+++ b/arch/mn10300/kernel/mn10300-serial.c
@@ -392,7 +392,7 @@ static int mask_test_and_clear(volatile u8 *ptr, u8 mask)
 static void mn10300_serial_receive_interrupt(struct mn10300_serial_port *port)
 {
 	struct uart_icount *icount = &port->uart.icount;
-	struct tty_struct *tty = port->uart.info->tty;
+	struct tty_struct *tty = port->uart.info->port.tty;
 	unsigned ix;
 	int count;
 	u8 st, ch, push, status, overrun;

