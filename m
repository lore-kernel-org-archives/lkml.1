Return-Path: <linux-kernel-owner+w=401wt.eu-S1752062AbXCEWu6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752062AbXCEWu6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2007 17:50:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752068AbXCEWun
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Mar 2007 17:50:43 -0500
Received: from [198.99.130.12] ([198.99.130.12]:49605 "EHLO
	saraswathi.solana.com" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1752044AbXCEWuk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2007 17:50:40 -0500
Message-Id: <200703052241.l25MfLh5008435@ccure.user-mode-linux.org>
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.0.4
To: akpm@osdl.org
cc: linux-kernel@vger.kernel.org, user-mode-linux-devel@lists.sourceforge.net
Subject: [PATCH 3/4] UML - Add a debugging message
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Date: Mon, 05 Mar 2007 17:41:21 -0500
From: Jeff Dike <jdike@addtoit.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add a debugging message in the case that mapping a stub fails.

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
--
 arch/um/os-Linux/skas/process.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

Index: test/arch/um/os-Linux/skas/process.c
===================================================================
--- test.orig/arch/um/os-Linux/skas/process.c	2007-03-05 15:08:18.000000000 -0500
+++ test/arch/um/os-Linux/skas/process.c	2007-03-05 16:14:56.000000000 -0500
@@ -419,9 +419,12 @@ void map_stub_pages(int fd, unsigned lon
 					  .offset  = code_offset
 	} } });
 	n = os_write_file(fd, &mmop, sizeof(mmop));
-	if(n != sizeof(mmop))
+	if(n != sizeof(mmop)){
+		printk("mmap args - addr = 0x%lx, fd = %d, offset = %llx\n",
+		       code, code_fd, (unsigned long long) code_offset);
 		panic("map_stub_pages : /proc/mm map for code failed, "
 		      "err = %d\n", -n);
+	}
 
 	if ( stack ) {
 		__u64 map_offset;

