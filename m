Return-Path: <linux-kernel-owner+w=401wt.eu-S1758970AbYAQVpu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758970AbYAQVpu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2008 16:45:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755932AbYAQVlm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jan 2008 16:41:42 -0500
Received: from saraswathi.solana.com ([198.99.130.12]:44787 "EHLO
	saraswathi.solana.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755652AbYAQVlh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2008 16:41:37 -0500
Date: Thu, 17 Jan 2008 16:40:39 -0500
From: Jeff Dike <jdike@addtoit.com>
To: Andrew Morton <akpm@osdl.org>
Cc: uml-devel <user-mode-linux-devel@lists.sourceforge.net>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 4/20] UML - Implement O_APPEND
Message-ID: <20080117214039.GA6702@c2.user-mode-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The .a flags in openflags never had an implementation.

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
---
 arch/um/os-Linux/file.c |    2 ++
 1 file changed, 2 insertions(+)

Index: linux-2.6.22/arch/um/os-Linux/file.c
===================================================================
--- linux-2.6.22.orig/arch/um/os-Linux/file.c	2007-12-13 13:50:52.000000000 -0500
+++ linux-2.6.22/arch/um/os-Linux/file.c	2007-12-13 15:23:13.000000000 -0500
@@ -191,6 +191,8 @@ int os_open_file(const char *file, struc
 		f |= O_TRUNC;
 	if (flags.e)
 		f |= O_EXCL;
+	if (flags.a)
+		f |= O_APPEND;
 
 	fd = open64(file, f, mode);
 	if (fd < 0)
