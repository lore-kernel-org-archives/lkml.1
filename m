Return-Path: <linux-kernel-owner+w=401wt.eu-S1760159AbYACCQn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760159AbYACCQn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2008 21:16:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754592AbYACCQg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jan 2008 21:16:36 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:33539 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753905AbYACCQg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2008 21:16:36 -0500
Date: Thu, 3 Jan 2008 13:16:24 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Clifford Wolf <clifford@clifford.at>
Cc: lkml <linux-kernel@vger.kernel.org>, linuxppc-dev@ozlabs.org,
       stable@vger.kernel.org
Subject: Re: [patch] powerpc systbl.h broken
Message-Id: <20080103131624.5a3e98e8.sfr@canb.auug.org.au>
In-Reply-To: <20080102141127.GA11870@clifford.at>
References: <20080102141127.GA11870@clifford.at>
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.12.3; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Clifford,

Thanks for the report.

PowerPC problems should be reported to linuxppc-dev@ozlabs.org.

This has been fixed in the current (approaching 2.6.24) kernel.  It
should be fixed in 2.6.23.xx, so I have cc'd this to
stable@vger.kernel.org (and linuxppc-dev, of course).

(Also, please post patches inline, don't attach them.  And you need to
reply to this with a Signed-off-by: line.)

-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
------------------------------------------------------------------------
From:	Clifford Wolf <clifford@clifford.at>

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


