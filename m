Return-Path: <linux-kernel-owner+w=401wt.eu-S932181AbZACCU2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932181AbZACCU2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2009 21:20:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758662AbZACCUQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Jan 2009 21:20:16 -0500
Received: from one.firstfloor.org ([213.235.205.2]:33542 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758559AbZACCUP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2009 21:20:15 -0500
From: Andi Kleen <andi@firstfloor.org>
References: <20090103321.351399938@firstfloor.org>
In-Reply-To: <20090103321.351399938@firstfloor.org>
To: linux-kbuild@vger.kernel.org, sam@ravnborg.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH] [2/3] KBUILD: Add a symlink to the source for separate objdirs
Message-Id: <20090103022142.684153E6651@basil.firstfloor.org>
Date: Sat,  3 Jan 2009 03:21:42 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I have some scripts which need to map back to the source directory
from an objdir. This was so far done by parsing the Makefile,
but the Makefile format changes occasionally and breaks my scripts
then.

To make this more reliable add a "source" symlink back. 

Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 Makefile |    1 +
 1 file changed, 1 insertion(+)

Index: linux-2.6.28-kbuild/Makefile
===================================================================
--- linux-2.6.28-kbuild.orig/Makefile	2008-12-27 16:45:43.000000000 +0100
+++ linux-2.6.28-kbuild/Makefile	2008-12-31 20:26:27.000000000 +0100
@@ -936,6 +936,7 @@
 	    mkdir -p include2;                                          \
 	    ln -fsn $(srctree)/include/asm-$(SRCARCH) include2/asm;     \
 	fi
+	ln -fsn $(srctree) source
 endif
 
 # prepare2 creates a makefile if using a separate output directory
