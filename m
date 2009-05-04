Return-Path: <linux-kernel-owner+w=401wt.eu-S1757833AbZEDPpb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757833AbZEDPpb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 May 2009 11:45:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754441AbZEDPpW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 May 2009 11:45:22 -0400
Received: from mx2.redhat.com ([66.187.237.31]:45633 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753692AbZEDPpW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 May 2009 11:45:22 -0400
Message-ID: <49FF0D90.1010107@redhat.com>
Date: Mon, 04 May 2009 11:45:20 -0400
From: William Cohen <wcohen@redhat.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH 29/29] perfcounters: updating kerneltop documentation
X-Enigmail-Version: 0.95.7
Content-Type: multipart/mixed;
 boundary="------------030801090807070504030201"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------030801090807070504030201
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit

Hi,

I built the kernel-tip kernel from a git tree checkout successful. I have not
installed the kernel headers on the machine, so __NR_perf_counter_open is not
going to be defined in an installed include file. When I tried to build the the
user-space programs in Documentation/perf_counter:


$ make V=1 -C Documentation/perf_counter/
make: Entering directory
`/home/wcohen/kernel/mingo/linux-2.6/Documentation/perf_counter'
gcc -o builtin-record.o -c -g -O2 -Wall  -DSHA1_HEADER='<openssl/sha.h>'
builtin-record.c
In file included from builtin-record.c:35:
perf.h: In function ‘sys_perf_counter_open’:
perf.h:53: error: ‘__NR_perf_counter_open’ undeclared (first use in this function)
perf.h:53: error: (Each undeclared identifier is reported only once
perf.h:53: error: for each function it appears in.)
make: *** [builtin-record.o] Error 1
make: Leaving directory
`/home/wcohen/kernel/mingo/linux-2.6/Documentation/perf_counter'

Is it possible to change the make so that it will compile without having
to install the kernel headers? I ended using the attached hack to make it use
the includes with the kernel. However, there is surely a better way to implement
this.

-Will



--------------030801090807070504030201
Content-Type: text/plain;
 name="includes.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="includes.patch"

diff --git a/Documentation/perf_counter/Makefile b/Documentation/perf_counter/Makefile
index 481e4c2..3bc49bc 100644
--- a/Documentation/perf_counter/Makefile
+++ b/Documentation/perf_counter/Makefile
@@ -159,7 +159,7 @@ uname_V := $(shell sh -c 'uname -v 2>/dev/null || echo not')
 
 # CFLAGS and LDFLAGS are for the users to override from the command line.
 
-CFLAGS = -g -O2 -Wall
+CFLAGS = -g -O2 -Wall -I../../include -I../../arch/x86/include
 LDFLAGS = -lpthread -lrt
 ALL_CFLAGS = $(CFLAGS)
 ALL_LDFLAGS = $(LDFLAGS)

--------------030801090807070504030201--
