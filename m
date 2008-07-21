Return-Path: <linux-kernel-owner+w=401wt.eu-S1754907AbYGUWA6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754907AbYGUWA6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2008 18:00:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752307AbYGUWAt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jul 2008 18:00:49 -0400
Received: from mx1.redhat.com ([66.187.233.31]:48228 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751214AbYGUWAt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2008 18:00:49 -0400
Date: Mon, 21 Jul 2008 17:16:59 -0400
From: Dave Jones <davej@redhat.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Cc: alan@redhat.com
Subject: Fix serial_txx9 compile.
Message-ID: <20080721211659.GA29106@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>, alan@redhat.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

drivers/serial/serial_txx9.c: In function 'receive_chars':
drivers/serial/serial_txx9.c:275: error: 'struct uart_info' has no member named 'tty'

Signed-off-by: Dave Jones <davej@redhat.com>

--- linux-2.6.26.noarch/drivers/serial/serial_txx9.c~	2008-07-21 17:13:21.000000000 -0400
+++ linux-2.6.26.noarch/drivers/serial/serial_txx9.c	2008-07-21 17:13:37.000000000 -0400
@@ -272,7 +272,7 @@ static void serial_txx9_initialize(struc
 static inline void
 receive_chars(struct uart_txx9_port *up, unsigned int *status)
 {
-	struct tty_struct *tty = up->port.info->tty;
+	struct tty_struct *tty = up->port.info->port.tty;
 	unsigned char ch;
 	unsigned int disr = *status;
 	int max_count = 256;

-- 
http://www.codemonkey.org.uk
