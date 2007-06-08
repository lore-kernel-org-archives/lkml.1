Return-Path: <linux-kernel-owner+w=401wt.eu-S939197AbXFHHpi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S939197AbXFHHpi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2007 03:45:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S938373AbXFHHYo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jun 2007 03:24:44 -0400
Received: from 216-99-217-87.dsl.aracnet.com ([216.99.217.87]:55257 "EHLO
	sous-sol.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S938319AbXFHHYm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2007 03:24:42 -0400
Message-Id: <20070608072155.755822000@sous-sol.org>
References: <20070608072127.352723000@sous-sol.org>
User-Agent: quilt/0.46-1
Date: Fri, 08 Jun 2007 00:21:39 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: linux-kernel@vger.kernel.org, stable@kernel.org,
       torvalds@linux-foundation.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, jirislaby@gmail.com,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [patch 12/54] Char: cyclades, fix deadlock
Content-Disposition: inline; filename=char-cyclades-fix-deadlock.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.
---------------------

From: Jiri Slaby <jirislaby@gmail.com>

An omitted unlock.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---

 drivers/char/cyclades.c |    1 +
 1 file changed, 1 insertion(+)

--- linux-2.6.21.4.orig/drivers/char/cyclades.c
+++ linux-2.6.21.4/drivers/char/cyclades.c
@@ -1103,6 +1103,7 @@ static void cyy_intr_chip(struct cyclade
 
 				if (data & info->ignore_status_mask) {
 					info->icount.rx++;
+					spin_unlock(&cinfo->card_lock);
 					return;
 				}
 				if (tty_buffer_request_room(tty, 1)) {

-- 
