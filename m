Return-Path: <linux-kernel-owner+w=401wt.eu-S1755491AbYIIGIq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755491AbYIIGIq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2008 02:08:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753550AbYIIGIj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Sep 2008 02:08:39 -0400
Received: from nwd2mail11.analog.com ([137.71.25.57]:27928 "EHLO
	nwd2mail11.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753444AbYIIGIi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2008 02:08:38 -0400
X-IronPort-AV: E=Sophos;i="4.32,363,1217822400"; 
   d="scan'208";a="59245906"
Subject: [PATCH][kgdb] Make mem access function weak in kgdb.c.
From: sonic zhang <sonic.adi@gmail.com>
To: Jason Wessel <jason.wessel@windriver.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
       kgdb mailing list <kgdb-bugreport@lists.sourceforge.net>
Content-Type: text/plain
Date: Tue, 09 Sep 2008 14:03:40 +0800
Message-Id: <1220940220.30906.6.camel@eight.analog.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

L1 instruction memory and MMR memory on blackfin can not be accessed by
common functions probe_kernel_read() and probe_kernel_write().
Blackfin asks for 2/4 byte align access to MMR memory and DMA access to L1
instruction memory. These functions need to be reimplemented in
architecture specific kgdb.c.


Signed-off-by: Sonic Zhang <sonic.adi@gmail.com>
---
 kernel/kgdb.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/kernel/kgdb.c b/kernel/kgdb.c
index eaa21fc..88fbab6 100644
--- a/kernel/kgdb.c
+++ b/kernel/kgdb.c
@@ -363,7 +363,7 @@ static void put_packet(char *buffer)
  * Convert the memory pointed to by mem into hex, placing result in buf.
  * Return a pointer to the last char put in buf (null). May return an error.
  */
-int kgdb_mem2hex(char *mem, char *buf, int count)
+int __weak kgdb_mem2hex(char *mem, char *buf, int count)
 {
 	char *tmp;
 	int err;
@@ -393,7 +393,7 @@ int kgdb_mem2hex(char *mem, char *buf, int count)
  * 0x7d escaped with 0x7d.  Return a pointer to the character after
  * the last byte written.
  */
-static int kgdb_ebin2mem(char *buf, char *mem, int count)
+int __weak kgdb_ebin2mem(char *buf, char *mem, int count)
 {
 	int err = 0;
 	char c;
@@ -418,7 +418,7 @@ static int kgdb_ebin2mem(char *buf, char *mem, int count)
  * Return a pointer to the character AFTER the last byte written.
  * May return an error.
  */
-int kgdb_hex2mem(char *buf, char *mem, int count)
+int __weak kgdb_hex2mem(char *buf, char *mem, int count)
 {
 	char *tmp_raw;
 	char *tmp_hex;
-- 
1.6.0

