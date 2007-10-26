Return-Path: <linux-kernel-owner+w=401wt.eu-S1761417AbXJZU4o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761417AbXJZU4o (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2007 16:56:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754163AbXJZU4h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Oct 2007 16:56:37 -0400
Received: from ns2.uludag.org.tr ([193.140.100.220]:58583 "EHLO uludag.org.tr"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753607AbXJZU4h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2007 16:56:37 -0400
From: "=?utf-8?q?S=2E=C3=87a=C4=9Flar?= Onur" <caglar@pardus.org.tr>
Reply-To: caglar@pardus.org.tr
Organization: =?utf-8?q?T=C3=9CB=C4=B0TAK_/?= UEKAE
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH] error: implicit declaration of function `get_softnet_dma'
Date: Fri, 26 Oct 2007 23:55:35 +0300
User-Agent: KMail/1.9.6 (enterprise 0.20071012.724442)
Cc: Jeff Garzik <jeff@garzik.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200710262355.36890.caglar@pardus.org.tr>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi;

Following trivial patch corrects 

caglar@zangetsu linux-2.6 $ make
  CHK     include/linux/version.h
  CHK     include/linux/utsrelease.h
  CALL    scripts/checksyscalls.sh
  CHK     include/linux/compile.h
  LD      net/ipv6/built-in.o
  CC [M]  net/ipv6/tcp_ipv6.o
net/ipv6/tcp_ipv6.c: In function `tcp_v6_rcv':
net/ipv6/tcp_ipv6.c:1736: error: implicit declaration of function `get_softnet_dma'
net/ipv6/tcp_ipv6.c:1736: warning: assignment makes pointer from integer without a cast
make[2]: *** [net/ipv6/tcp_ipv6.o] Hata 1
make[1]: *** [net/ipv6] Hata 2
make: *** [net] Hata 2

compiliation error for current Linus's git tree

Signed-off-by: S.Çağlar Onur <caglar@pardus.org.tr>

diff --git a/net/ipv6/tcp_ipv6.c b/net/ipv6/tcp_ipv6.c
index 06fa4ba..8520802 100644
--- a/net/ipv6/tcp_ipv6.c
+++ b/net/ipv6/tcp_ipv6.c
@@ -59,6 +59,7 @@
 #include <net/snmp.h>
 #include <net/dsfield.h>
 #include <net/timewait_sock.h>
+#include <net/netdma.h>
 
 #include <asm/uaccess.h>
 
Cheers
-- 
S.Çağlar Onur <caglar@pardus.org.tr>
http://cekirdek.pardus.org.tr/~caglar/

Linux is like living in a teepee. No Windows, no Gates and an Apache in house!
