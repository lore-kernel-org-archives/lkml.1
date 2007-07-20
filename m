Return-Path: <linux-kernel-owner+w=401wt.eu-S941405AbXGTQee@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S941405AbXGTQee (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2007 12:34:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S939521AbXGTQe0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jul 2007 12:34:26 -0400
Received: from mail.screens.ru ([213.234.233.54]:48476 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932220AbXGTQeZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2007 12:34:25 -0400
Date: Fri, 20 Jul 2007 20:36:06 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Kristian Hoegsberg <krh@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH] idr_remove_all: kill unused variable
Message-ID: <20070720163606.GA2672@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

"error" is always equal to 0.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>

--- t/lib/idr.c~	2007-07-20 20:18:09.000000000 +0400
+++ t/lib/idr.c	2007-07-20 20:19:27.000000000 +0400
@@ -405,7 +405,7 @@ EXPORT_SYMBOL(idr_remove);
  */
 void idr_remove_all(struct idr *idp)
 {
-	int n, id, max, error = 0;
+	int n, id, max;
 	struct idr_layer *p;
 	struct idr_layer *pa[MAX_LEVEL];
 	struct idr_layer **paa = &pa[0];
@@ -415,7 +415,7 @@ void idr_remove_all(struct idr *idp)
 	max = 1 << n;
 
 	id = 0;
-	while (id < max && !error) {
+	while (id < max) {
 		while (n > IDR_BITS && p) {
 			n -= IDR_BITS;
 			*paa++ = p;

