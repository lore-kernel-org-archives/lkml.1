Return-Path: <linux-kernel-owner+w=401wt.eu-S1758467AbYABOv1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758467AbYABOv1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2008 09:51:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752823AbYABOvU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jan 2008 09:51:20 -0500
Received: from phoenix.clifford.at ([88.198.7.52]:37550 "EHLO
	phoenix.clifford.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752677AbYABOvT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2008 09:51:19 -0500
X-Greylist: delayed 2091 seconds by postgrey-1.27 at vger.kernel.org; Wed, 02 Jan 2008 09:51:19 EST
Date: Wed, 2 Jan 2008 15:11:27 +0100
From: Clifford Wolf <clifford@clifford.at>
To: lkml <linux-kernel@vger.kernel.org>
Subject: [patch] powerpc systbl.h broken
Message-ID: <20080102141127.GA11870@clifford.at>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="bp/iNruPH9dso1Pn"
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--bp/iNruPH9dso1Pn
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi,

In current 2.6.23 (I have checked 2.6.23.12 and 2.6.23.9) the end of
include/asm-powerpc/systbl.h reads:

--snip--
SYSCALL_SPU(getcpu)
COMPAT_SYS(epoll_pwait)
COMPAT_SYS_SPU(utimensat)
COMPAT_SYS(fallocate)
COMPAT_SYS_SPU(signalfd)
COMPAT_SYS_SPU(timerfd)
SYSCALL_SPU(eventfd)
COMPAT_SYS_SPU(sync_file_range2)
--snap--

This obviously does not match the definitions in asm-powerpc/unistd.h:

--snip--
#define __NR_getcpu		302
#define __NR_epoll_pwait	303
#define __NR_utimensat		304
#define __NR_signalfd		305
#define __NR_timerfd		306
#define __NR_eventfd		307
#define __NR_sync_file_range2	308
#define __NR_fallocate		309
--snap--

which breaks the system calls 305 to 309 inclusive.

I've attached the simple patch which fixes the problem.

yours,
 - clifford

-- 
"Any sufficiently advanced technology is indistinguishable from magic."
 - Arthur C. Clarke

--bp/iNruPH9dso1Pn
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="powerpc-systbl.h"

--- linux-2.6.23.12/include/asm-powerpc/systbl.h.orig	2008-01-02 15:09:04.000000000 +0100
+++ linux-2.6.23.12/include/asm-powerpc/systbl.h	2008-01-02 15:09:29.000000000 +0100
@@ -308,8 +308,8 @@
 SYSCALL_SPU(getcpu)
 COMPAT_SYS(epoll_pwait)
 COMPAT_SYS_SPU(utimensat)
-COMPAT_SYS(fallocate)
 COMPAT_SYS_SPU(signalfd)
 COMPAT_SYS_SPU(timerfd)
 SYSCALL_SPU(eventfd)
 COMPAT_SYS_SPU(sync_file_range2)
+COMPAT_SYS(fallocate)

--bp/iNruPH9dso1Pn--
