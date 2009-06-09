Return-Path: <linux-kernel-owner+w=401wt.eu-S1760251AbZFIKXi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760251AbZFIKXi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jun 2009 06:23:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760319AbZFIKTA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Jun 2009 06:19:00 -0400
Received: from kroah.org ([198.145.64.141]:54694 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760622AbZFIKS7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jun 2009 06:18:59 -0400
X-Mailbox-Line: From greg@blue.kroah.org Tue Jun  9 02:40:59 2009
Message-Id: <20090609094059.003720718@blue.kroah.org>
User-Agent: quilt/0.48-1
Date: Tue, 09 Jun 2009 02:39:18 -0700
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
       alan@lxorguk.ukuu.org.uk, Roel Kluin <roel.kluin@gmail.com>,
       Wolfram Sang <w.sang@pengutronix.de>,
       Grant Likely <grant.likely@secretlab.ca>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [patch 30/87] drivers/serial/mpc52xx_uart.c: fix array overindexing check
References: <20090609093848.204935043@blue.kroah.org>
Content-Disposition: inline; filename=drivers-serial-mpc52xx_uart.c-fix-array-overindexing-check.patch
In-Reply-To: <20090609094451.GA26439@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.29-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Roel Kluin <roel.kluin@gmail.com>

commit b898f4f869da5b9d41f297fff87aca4cd42d80b3 upstream.

The check for an overindexing of mpc52xx_uart_{ports,nodes} has an
off-by-one.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
Acked-by: Wolfram Sang <w.sang@pengutronix.de>
Acked-by: Grant Likely <grant.likely@secretlab.ca>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/serial/mpc52xx_uart.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/serial/mpc52xx_uart.c
+++ b/drivers/serial/mpc52xx_uart.c
@@ -988,7 +988,7 @@ mpc52xx_console_setup(struct console *co
 	pr_debug("mpc52xx_console_setup co=%p, co->index=%i, options=%s\n",
 		 co, co->index, options);
 
-	if ((co->index < 0) || (co->index > MPC52xx_PSC_MAXNUM)) {
+	if ((co->index < 0) || (co->index >= MPC52xx_PSC_MAXNUM)) {
 		pr_debug("PSC%x out of range\n", co->index);
 		return -EINVAL;
 	}


