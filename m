Return-Path: <linux-kernel-owner+w=401wt.eu-S1762016AbYEPVAs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762016AbYEPVAs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2008 17:00:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757636AbYEPVAU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 May 2008 17:00:20 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:34817 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755081AbYEPVAP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2008 17:00:15 -0400
Date: Fri, 16 May 2008 22:00:13 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jeff Dike <jdike@addtoit.com>, linux-kernel@vger.kernel.org
Subject: [PATCH] fix include order in sys-i386/registers.c
Message-ID: <20080516210013.GW13907@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

	We want sys/ptrace.h before any includes of linux/ptrace.h and
asm/user.h pulls the latter.

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Acked-by: Jeff Dike <jdike@addtoit.com>
---
diff --git a/arch/um/os-Linux/sys-i386/registers.c b/arch/um/os-Linux/sys-i386/registers.c
index c6183e7..b487cbe 100644
--- a/arch/um/os-Linux/sys-i386/registers.c
+++ b/arch/um/os-Linux/sys-i386/registers.c
@@ -5,6 +5,7 @@
  */
 
 #include <errno.h>
+#include <sys/ptrace.h>
 #include <asm/user.h>
 #include "kern_constants.h"
 #include "longjmp.h"
