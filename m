Return-Path: <linux-kernel-owner+w=401wt.eu-S1758684AbYELLGR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758684AbYELLGR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2008 07:06:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760747AbYELLFp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 May 2008 07:05:45 -0400
Received: from serv2.oss.ntt.co.jp ([222.151.198.100]:40813 "EHLO
	serv2.oss.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758814AbYELLFn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2008 07:05:43 -0400
X-Greylist: delayed 1810 seconds by postgrey-1.27 at vger.kernel.org; Mon, 12 May 2008 07:05:43 EDT
Subject: [PATCH] Fix c67x00-ll-hpi compilation failure (bug #10627)
From: Fernando Luis =?ISO-8859-1?Q?V=E1zquez?= Cao 
	<fernando@oss.ntt.co.jp>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, samuel.thibault@ens-lyon.org, rjw@sisk.pl,
       gregkh@suse.de
Content-Type: text/plain
Organization: NTT Open Source Software Center
Date: Mon, 12 May 2008 19:35:31 +0900
Message-Id: <1210588531.3058.31.camel@sebastian.kern.oss.ntt.co.jp>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes bug #10627 which caused the compilation error below.

CC [M]  drivers/usb/c67x00/c67x00-ll-hpi.o
drivers/usb/c67x00/c67x00-ll-hpi.c: In function `ll_recv_msg':
drivers/usb/c67x00/c67x00-ll-hpi.c:243: erreur: `HZ' undeclared (first use in this function)
drivers/usb/c67x00/c67x00-ll-hpi.c:243: erreur: (Each undeclared identifier is reported only once
drivers/usb/c67x00/c67x00-ll-hpi.c:243: erreur: for each function it appears in.)

Signed-off-by: Fernando Luis Vazquez Cao <fernando@oss.ntt.co.jp>
---

--- linux-2.6.26-rc2-orig/drivers/usb/c67x00/c67x00-ll-hpi.c	2008-05-12 19:18:32.000000000 +0900
+++ linux-2.6.26-rc2/drivers/usb/c67x00/c67x00-ll-hpi.c	2008-05-12 19:03:02.000000000 +0900
@@ -23,6 +23,7 @@
 
 #include <asm/byteorder.h>
 #include <linux/io.h>
+#include <linux/jiffies.h>
 #include <linux/usb/c67x00.h>
 #include "c67x00.h"
 


