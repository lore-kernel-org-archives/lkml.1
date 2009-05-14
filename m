Return-Path: <linux-kernel-owner+w=401wt.eu-S1762623AbZENXJ3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762623AbZENXJ3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 May 2009 19:09:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762301AbZENW6w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 May 2009 18:58:52 -0400
Received: from kroah.org ([198.145.64.141]:46161 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761706AbZENW6s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 May 2009 18:58:48 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Thu May 14 15:52:40 2009
Message-Id: <20090514225240.378799790@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Thu, 14 May 2009 15:51:50 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Grant Likely <grant.likely@secretlab.ca>
Subject: [patch 24/28] powerpc/5200: Dont specify IRQF_SHARED in PSC UART driver
References: <20090514225126.907908936@mini.kroah.org>
Content-Disposition: inline; filename=powerpc-5200-don-t-specify-irqf_shared-in-psc-uart-driver.patch
In-Reply-To: <20090514225413.GA705@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Grant Likely <grant.likely@secretlab.ca>

commit d9f0c5f9bc74f16d0ea0f6c518b209e48783a796 upstream.

The MPC5200 PSC device is wired up to a dedicated interrupt line
which is never shared.  This patch removes the IRQF_SHARED flag
from the request_irq() call which eliminates the "IRQF_DISABLED
is not guaranteed on shared IRQs" warning message from the console
output.

Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
Reviewed-by: Wolfram Sang <w.sang@pengutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/serial/mpc52xx_uart.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/serial/mpc52xx_uart.c
+++ b/drivers/serial/mpc52xx_uart.c
@@ -515,7 +515,7 @@ mpc52xx_uart_startup(struct uart_port *p
 
 	/* Request IRQ */
 	ret = request_irq(port->irq, mpc52xx_uart_int,
-		IRQF_DISABLED | IRQF_SAMPLE_RANDOM | IRQF_SHARED,
+		IRQF_DISABLED | IRQF_SAMPLE_RANDOM,
 		"mpc52xx_psc_uart", port);
 	if (ret)
 		return ret;


