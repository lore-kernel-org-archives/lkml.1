Return-Path: <linux-kernel-owner+w=401wt.eu-S1755994AbXHRAoX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755994AbXHRAoX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2007 20:44:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759448AbXHRAmx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Aug 2007 20:42:53 -0400
Received: from saraswathi.solana.com ([198.99.130.12]:57734 "EHLO
	saraswathi.solana.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758349AbXHRAmU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2007 20:42:20 -0400
Date: Fri, 17 Aug 2007 15:43:40 -0400
From: Jeff Dike <jdike@addtoit.com>
To: Andrew Morton <akpm@osdl.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       uml-devel <user-mode-linux-devel@lists.sourceforge.net>,
       Nicolas George <nicolas.george@normalesup.org>
Subject: [PATCH 2/6] UML - Use 64-bits for block size on x86_64
Message-ID: <20070817194340.GA8739@c2.user-mode-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The BLKGETSIZE ioctl expects a pointer to a long, os_file_size was providing
an int. Therefore, ubd access to host block devices caused a segmentation
fault on 64 bits systems.

Signed-off-by: Nicolas George <nicolas.george@normalesup.org>
Signed-off-by: Jeff Dike <jdike@linux.intel.com>
--
 arch/um/os-Linux/file.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

Index: linux-2.6.22/arch/um/os-Linux/file.c
===================================================================
--- linux-2.6.22.orig/arch/um/os-Linux/file.c	2007-08-17 13:36:35.000000000 -0400
+++ linux-2.6.22/arch/um/os-Linux/file.c	2007-08-17 13:37:55.000000000 -0400
@@ -296,7 +296,8 @@ int os_file_size(char *file, unsigned lo
 	}
 
 	if(S_ISBLK(buf.ust_mode)){
-		int fd, blocks;
+		int fd;
+		long blocks;
 
 		fd = os_open_file(file, of_read(OPENFLAGS()), 0);
 		if(fd < 0){
