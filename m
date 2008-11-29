Return-Path: <linux-kernel-owner+w=401wt.eu-S1751041AbYK2KI7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751041AbYK2KI7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Nov 2008 05:08:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751101AbYK2KIv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Nov 2008 05:08:51 -0500
Received: from e28smtp01.in.ibm.com ([59.145.155.1]:40089 "EHLO
	e28smtp01.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751047AbYK2KIu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Nov 2008 05:08:50 -0500
Date: Sat, 29 Nov 2008 15:38:30 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: jdike@addtoit.com
Cc: linux-kernel@vger.kernel.org, user-mode-linux-devel@lists.sourceforge.net
Subject: [PATCH][UML] Boot broken due to buffer overrun
Message-ID: <20081129100830.GA24128@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Mail-Followup-To: jdike@addtoit.com, linux-kernel@vger.kernel.org,
	user-mode-linux-devel@lists.sourceforge.net
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


mconsole_init() passed 256 bytes as length in os_create_unix_socket, while
the sizeof UNIX_PATH_MAX is 108. This patch fixes that problem and avoids
a big overrun bug reported on UML bootup.

Reported-by: Vikas K Managutte <vikki.km@gmail.com>
Reported-by: Sarvesh Kumar Lal Das <skldas@gmail.com>
Signed-off-by: Balbir Singh <balbir@linux.vnet.ibm.com>
---

 arch/um/drivers/mconsole_kern.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff -puN arch/um/drivers/mconsole_kern.c~fix-uml-buggy-socket-creation arch/um/drivers/mconsole_kern.c
--- linux-2.6.28-rc6/arch/um/drivers/mconsole_kern.c~fix-uml-buggy-socket-creation	2008-11-29 15:29:04.000000000 +0530
+++ linux-2.6.28-rc6-balbir/arch/um/drivers/mconsole_kern.c	2008-11-29 15:32:23.000000000 +0530
@@ -16,6 +16,8 @@
 #include <linux/slab.h>
 #include <linux/syscalls.h>
 #include <linux/utsname.h>
+#include <linux/socket.h>
+#include <linux/un.h>
 #include <linux/workqueue.h>
 #include <linux/mutex.h>
 #include <asm/uaccess.h>
@@ -785,7 +787,7 @@ static int __init mconsole_init(void)
 	/* long to avoid size mismatch warnings from gcc */
 	long sock;
 	int err;
-	char file[256];
+	char file[UNIX_PATH_MAX];
 
 	if (umid_file_name("mconsole", file, sizeof(file)))
 		return -1;
_

-- 
	Balbir
