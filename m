Return-Path: <linux-kernel-owner+w=401wt.eu-S1759280AbZDOIeB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759280AbZDOIeB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Apr 2009 04:34:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759170AbZDOIdf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Apr 2009 04:33:35 -0400
Received: from mailbox-us-s-12.mailhostingserver.com ([75.125.101.9]:50195
	"EHLO mailbox-us-s-12.mailhostingserver.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758854AbZDOIdc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Apr 2009 04:33:32 -0400
Date: Wed, 15 Apr 2009 10:33:26 +0200
From: Matthias Kaehlcke <matthias@kaehlcke.net>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.arm.linux.org.uk,
       Bill Gatliff <bgat@billgatliff.com>
Subject: re: Linux 2.6.30-rc2: [PATCH] ARM OABI compatibility: fix build
	error
Message-ID: <20090415083326.GA12921@traven>
Mail-Followup-To: Matthias Kaehlcke <matthias@kaehlcke.net>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.arm.linux.org.uk,
	Bill Gatliff <bgat@billgatliff.com>
References: <alpine.LFD.2.00.0904141628570.4132@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0904141628570.4132@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Building for ARM with CONFIG_OABI_COMPAT enabled fails due to a
missing include:

arch/arm/kernel/sys_oabi-compat.c: In function 'sys_oabi_epoll_wait':
arch/arm/kernel/sys_oabi-compat.c:288: error: implicit declaration of
function 'kmalloc'
arch/arm/kernel/sys_oabi-compat.c:288: error: 'GFP_KERNEL' undeclared
(first use in this function)
arch/arm/kernel/sys_oabi-compat.c:288: error: (Each undeclared
identifier is reported only once
arch/arm/kernel/sys_oabi-compat.c:288: error: for each function it
appears in.)
arch/arm/kernel/sys_oabi-compat.c:288: warning: assignment makes
pointer from integer without a cast
arch/arm/kernel/sys_oabi-compat.c:301: error: implicit declaration of
function 'kfree'
arch/arm/kernel/sys_oabi-compat.c: In function 'sys_oabi_semtimedop':
arch/arm/kernel/sys_oabi-compat.c:324: error: 'GFP_KERNEL' undeclared
(first use in this function)
arch/arm/kernel/sys_oabi-compat.c:324: warning: assignment makes
pointer from integer without a cast
make[1]: *** [arch/arm/kernel/sys_oabi-compat.o] Error 1
make: *** [arch/arm/kernel] Error 2

including linux/mm.h fixes this (thanks to Bill Gatliff for the pointer)

--

ARM: Fix build error when CONFIG_OABI_COMPAT is selected

Signed-off-by: Matthias Kaehlcke <matthias@kaehlcke.net>

---
 arch/arm/kernel/sys_oabi-compat.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/arm/kernel/sys_oabi-compat.c b/arch/arm/kernel/sys_oabi-compat.c
index 42623db..5d666ac 100644
--- a/arch/arm/kernel/sys_oabi-compat.c
+++ b/arch/arm/kernel/sys_oabi-compat.c
@@ -80,6 +80,7 @@
 #include <linux/eventpoll.h>
 #include <linux/sem.h>
 #include <linux/socket.h>
+#include <linux/mm.h>
 #include <linux/net.h>
 #include <linux/ipc.h>
 #include <linux/uaccess.h>
-- 
1.6.2.1

