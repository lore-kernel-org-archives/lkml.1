Return-Path: <linux-kernel-owner+w=401wt.eu-S1758964AbYBEQXZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758964AbYBEQXZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2008 11:23:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757438AbYBEQXO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Feb 2008 11:23:14 -0500
Received: from smtp3-g19.free.fr ([212.27.42.29]:45258 "EHLO smtp3-g19.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758841AbYBEQXN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2008 11:23:13 -0500
From: Jim Meyering <jim@meyering.net>
To: Jeff Dike <jdike@addtoit.com>, linux-kernel@vger.kernel.org
Subject: [PATCH] uml: Handle failed malloc.
Date: Tue, 05 Feb 2008 17:23:11 +0100
Message-ID: <87ir138j9s.fsf@rho.meyering.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* arch/um/os-Linux/mem.c (make_tempfile): Don't deref NULL upon failed malloc.

Signed-off-by: Jim Meyering <meyering@redhat.com>
---
diff --git a/arch/um/os-Linux/mem.c b/arch/um/os-Linux/mem.c
index 436f8d2..e114d09 100644
--- a/arch/um/os-Linux/mem.c
+++ b/arch/um/os-Linux/mem.c
@@ -172,6 +172,8 @@ int __init make_tempfile(const char *template, char **out_tempname,

 	which_tmpdir();
 	tempname = malloc(MAXPATHLEN);
+	if (tempname == NULL)
+	  return -1;

 	find_tempdir();
 	if (template[0] != '/')
