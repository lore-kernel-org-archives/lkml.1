Return-Path: <linux-kernel-owner+w=401wt.eu-S1763595AbXHVPP2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763595AbXHVPP2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2007 11:15:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759968AbXHVPPU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Aug 2007 11:15:20 -0400
Received: from ftp.linux-mips.org ([194.74.144.162]:56503 "EHLO
	ftp.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758571AbXHVPPT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2007 11:15:19 -0400
Date: Wed, 22 Aug 2007 16:15:18 +0100
From: Ralf Baechle <ralf@linux-mips.org>
To: adaplas@gmail.com, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: [PATCH] Fix warnings in selection.h
Message-ID: <20070822151518.GA19320@linux-mips.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

<linux/selection.h> assumes that struct tty_struct has previously been
included.  If not, this pile of warnings will result:

  CC [M]  drivers/video/console/newport_con.o
In file included from drivers/video/console/newport_con.c:18:
include/linux/selection.h:16: warning: 'struct tty_struct' declared inside param
eter list
include/linux/selection.h:16: warning: its scope is only this definition or decl
aration, which is probably not what you want
include/linux/selection.h:17: warning: 'struct tty_struct' declared inside param
eter list
include/linux/selection.h:20: warning: 'struct tty_struct' declared inside param
eter list

Fixed by adding a forward declaration of struct tty_struct.

Signed-off-by: Ralf Baechle <ralf@linux-mips.org>

diff --git a/include/linux/selection.h b/include/linux/selection.h
index ed3408b..16184d6 100644
--- a/include/linux/selection.h
+++ b/include/linux/selection.h
@@ -11,6 +11,7 @@
 #include <linux/vt_buffer.h>
 
 extern struct vc_data *sel_cons;
+struct tty_struct;
 
 extern void clear_selection(void);
 extern int set_selection(const struct tiocl_selection __user *sel, struct tty_struct *tty);
