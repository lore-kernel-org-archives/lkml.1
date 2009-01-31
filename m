Return-Path: <linux-kernel-owner+w=401wt.eu-S1752486AbZAaGZy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752486AbZAaGZy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Jan 2009 01:25:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751144AbZAaGZq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 Jan 2009 01:25:46 -0500
Received: from e23smtp03.au.ibm.com ([202.81.31.145]:36149 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751066AbZAaGZp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Jan 2009 01:25:45 -0500
Message-ID: <4983EEE3.3080208@in.ibm.com>
Date: Sat, 31 Jan 2009 11:55:39 +0530
From: "Sachin P. Sant" <sachinp@in.ibm.com>
User-Agent: Thunderbird 2.0.0.17 (X11/20080915)
MIME-Version: 1.0
To: linuxppc-dev@ozlabs.org
CC: davem@davemloft.net, yoshfuji@linux-ipv6.org,
       Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
       Mel Gorman <mel@csn.ul.ie>, linux-kernel <linux-kernel@vger.kernel.org>
Subject: [Patch] 2.6.29-rc3-git2 - Fix net/ipv6/ip6mr.o build break
Content-Type: multipart/mixed;
 boundary="------------040102010908060506040102"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------040102010908060506040102
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

allmodconfig build breaks with following error.

 CHK     include/linux/version.h
 CHK     include/linux/utsrelease.h
 SYMLINK include/asm -> include/asm-powerpc
 CALL    scripts/checksyscalls.sh
 CHK     include/linux/compile.h
 CALL    arch/powerpc/kernel/systbl_chk.sh
 CALL    arch/powerpc/kernel/prom_init_check.sh
 CC [M]  net/ipv6/ip6mr.o
net/ipv6/ip6mr.c: In function pim6_rcv:
net/ipv6/ip6mr.c:366: error: implicit declaration of function csum_ipv6_magic
make[2]: *** [net/ipv6/ip6mr.o] Error 1
make[1]: *** [net/ipv6] Error 2
make: *** [net] Error 2

Following patch fixes this issue.

thanks
-Sachin


Signed-off-by : Sachin Sant <sachinp@in.ibm.com>
---



--------------040102010908060506040102
Content-Type: text/x-patch;
 name="fix-ipv6-ip6mr-build-break.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="fix-ipv6-ip6mr-build-break.patch"

* Fix ip6mr build break (undefined csum_ipv6_magic symbol)

Signed-off-by : Sachin Sant (sachinp@in.ibm.com)
---

diff -Naurp a/net/ipv6/ip6mr.c b/net/ipv6/ip6mr.c
--- a/net/ipv6/ip6mr.c	2009-01-31 13:58:00.000000000 +0530
+++ b/net/ipv6/ip6mr.c	2009-01-31 13:59:16.000000000 +0530
@@ -43,6 +43,7 @@
 #include <net/netlink.h>
 
 #include <net/ipv6.h>
+#include <net/ip6_checksum.h>
 #include <net/ip6_route.h>
 #include <linux/mroute6.h>
 #include <linux/pim.h>

--------------040102010908060506040102--
