Return-Path: <linux-kernel-owner+w=401wt.eu-S1762569AbYFDVxT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762569AbYFDVxT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2008 17:53:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751934AbYFDVxL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jun 2008 17:53:11 -0400
Received: from mtiwmhc12.worldnet.att.net ([204.127.131.116]:43937 "EHLO
	mtiwmhc12.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751797AbYFDVxK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2008 17:53:10 -0400
Message-ID: <48470ED2.6030307@lwfinger.net>
Date: Wed, 04 Jun 2008 16:53:22 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Linus Torvalds <torvalds@linux-foundation.org>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: Compiler warning in v2.6.26-rc4-213-ge97dcb0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With the version given in the subject, I get the following warning:

   CC      drivers/serial/serial_core.o
drivers/serial/serial_core.c:2300: warning: initialization from incompatible 
pointer type

The problem arises in commit 64e9159f5d2c which has uart_set_ldisc as follows:

static void uart_set_ldisc(struct tty_struct *tty, int ldisc)

The set_ldisc routine has only one argument:

        void            (*set_ldisc)(struct uart_port *);

I think this additional patch fixes the problem:

Index: linux-2.6/drivers/serial/serial_core.c
===================================================================
--- linux-2.6.orig/drivers/serial/serial_core.c
+++ linux-2.6/drivers/serial/serial_core.c
@@ -1165,7 +1165,7 @@ out:
         return ret;
  }

-static void uart_set_ldisc(struct tty_struct *tty, int ldisc)
+static void uart_set_ldisc(struct tty_struct *tty)
  {
         struct uart_state *state = tty->driver_data;
         struct uart_port *port = state->port;


Larry
