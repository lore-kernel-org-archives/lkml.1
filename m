Return-Path: <linux-kernel-owner+w=401wt.eu-S939578AbXFHHwV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S939578AbXFHHwV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2007 03:52:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S938332AbXFHHZL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jun 2007 03:25:11 -0400
Received: from 216-99-217-87.dsl.aracnet.com ([216.99.217.87]:55339 "EHLO
	sous-sol.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967765AbXFHHZE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2007 03:25:04 -0400
Message-Id: <20070608072235.126164000@sous-sol.org>
References: <20070608072127.352723000@sous-sol.org>
User-Agent: quilt/0.46-1
Date: Fri, 08 Jun 2007 00:22:15 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       David Miller <davem@davemloft.net>, bunk@stusta.de,
       Jan Engelhardt <jengelh@gmx.de>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [patch 48/54] SPARC: Linux always started with 9600 8N1
Content-Disposition: inline; filename=sparc-linux-always-started-with-9600-8n1.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.
---------------------

From: Jan Engelhardt <jengelh@gmx.de>

The Linux kernel ignored the PROM's serial settings (115200,n,8,1 in
my case). This was because mode_prop remained "ttyX-mode" (expected:
"ttya-mode") due to the constness of string literals when used with
"char *". Since there is no "ttyX-mode" property in the PROM, Linux
always used the default 9600.

[ Investigation of the suncore.s assembler reveals that gcc optimizied
  away the stores, yet did not emit a warning, which is a pretty
  anti-social thing to do and is the only reason this bug lived for
  so long -DaveM ]

Signed-off-by: Jan Engelhardt <jengelh@gmx.de>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/serial/suncore.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- linux-2.6.21.4.orig/drivers/serial/suncore.c
+++ linux-2.6.21.4/drivers/serial/suncore.c
@@ -30,9 +30,9 @@ void
 sunserial_console_termios(struct console *con)
 {
 	char mode[16], buf[16], *s;
-	char *mode_prop = "ttyX-mode";
-	char *cd_prop = "ttyX-ignore-cd";
-	char *dtr_prop = "ttyX-rts-dtr-off";
+	char mode_prop[] = "ttyX-mode";
+	char cd_prop[]   = "ttyX-ignore-cd";
+	char dtr_prop[]  = "ttyX-rts-dtr-off";
 	char *ssp_console_modes_prop = "ssp-console-modes";
 	int baud, bits, stop, cflag;
 	char parity;

-- 
