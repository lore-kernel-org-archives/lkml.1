Return-Path: <linux-kernel-owner+w=401wt.eu-S1762207AbZBDSxx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762207AbZBDSxx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 13:53:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760256AbZBDStN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 13:49:13 -0500
Received: from kroah.org ([198.145.64.141]:34314 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758767AbZBDStF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 13:49:05 -0500
Date: Wed, 4 Feb 2009 10:46:00 -0800
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
       alan@lxorguk.ukuu.org.uk, Scott Kilau <Scott.Kilau@digi.com>,
       Paul Larson <pl@linux.vnet.ibm.com>
Subject: [patch 06/41] Add enable_ms to jsm driver
Message-ID: <20090204184600.GG25246@kroah.com>
References: <20090204184029.881610776@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="add-enable_ms-to-jsm-driver.patch"
In-Reply-To: <20090204184539.GA25246@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Paul Larson <pl@linux.vnet.ibm.com>

commit 0461ec5bc7745b89a8ab67ba0ea497abd58a6301 upstream.

This fixes a crash observed when non-existant enable_ms function is
called for jsm driver.

Signed-off-by: Scott Kilau <Scott.Kilau@digi.com>
Signed-off-by: Paul Larson <pl@linux.vnet.ibm.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/serial/jsm/jsm_tty.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/drivers/serial/jsm/jsm_tty.c
+++ b/drivers/serial/jsm/jsm_tty.c
@@ -161,6 +161,11 @@ static void jsm_tty_stop_rx(struct uart_
 	channel->ch_bd->bd_ops->disable_receiver(channel);
 }
 
+static void jsm_tty_enable_ms(struct uart_port *port)
+{
+	/* Nothing needed */
+}
+
 static void jsm_tty_break(struct uart_port *port, int break_state)
 {
 	unsigned long lock_flags;
@@ -345,6 +350,7 @@ static struct uart_ops jsm_ops = {
 	.start_tx	= jsm_tty_start_tx,
 	.send_xchar	= jsm_tty_send_xchar,
 	.stop_rx	= jsm_tty_stop_rx,
+	.enable_ms	= jsm_tty_enable_ms,
 	.break_ctl	= jsm_tty_break,
 	.startup	= jsm_tty_open,
 	.shutdown	= jsm_tty_close,

