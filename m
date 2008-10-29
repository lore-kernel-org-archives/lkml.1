Return-Path: <linux-kernel-owner+w=401wt.eu-S1753104AbYJ2Hpj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753104AbYJ2Hpj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2008 03:45:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752133AbYJ2Hpa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Oct 2008 03:45:30 -0400
Received: from serv2.oss.ntt.co.jp ([222.151.198.100]:45913 "EHLO
	serv2.oss.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752018AbYJ2Hpa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2008 03:45:30 -0400
Subject: [PATCH -mm] spi: fix compile error
From: Fernando Luis =?ISO-8859-1?Q?V=E1zquez?= Cao 
	<fernando@oss.ntt.co.jp>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, dbrownell@users.sourceforge.net
In-Reply-To: <20081028233836.8b1ff9ae.akpm@linux-foundation.org>
References: <20081028233836.8b1ff9ae.akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Organization: NTT Open Source Software Center
Date: Wed, 29 Oct 2008 16:45:28 +0900
Message-Id: <1225266328.5858.17.camel@sebastian.kern.oss.ntt.co.jp>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix compile error below:

     LD      drivers/spi/built-in.o
     CC [M]  drivers/spi/spi_gpio.o
   In file included from drivers/spi/spi_gpio.c:26:
   include/linux/spi/spi_bitbang.h:23: error: field ‘work’ has incomplete type
   make[2]: *** [drivers/spi/spi_gpio.o] Error 1
   make[1]: *** [drivers/spi] Error 2
   make: *** [drivers] Error 2

Signed-off-by: Fernando Luis Vazquez Cao <fernando@oss.ntt.co.jp>
---

diff -urNp linux-2.6.28-rc2-mm1-orig/include/linux/spi/spi_bitbang.h linux-2.6.28-rc2-mm1/include/linux/spi/spi_bitbang.h
--- linux-2.6.28-rc2-mm1-orig/include/linux/spi/spi_bitbang.h	2008-10-10 07:13:53.000000000 +0900
+++ linux-2.6.28-rc2-mm1/include/linux/spi/spi_bitbang.h	2008-10-29 16:25:31.000000000 +0900
@@ -18,6 +18,9 @@
  *	duplex (MicroWire) controllers.  Provide chipslect() and txrx_bufs(),
  *	and custom setup()/cleanup() methods.
  */
+
+#include <linux/workqueue.h>
+
 struct spi_bitbang {
 	struct workqueue_struct	*workqueue;
 	struct work_struct	work;


