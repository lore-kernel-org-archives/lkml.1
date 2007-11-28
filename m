Return-Path: <linux-kernel-owner+w=401wt.eu-S1760685AbXK1Mrf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760685AbXK1Mrf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2007 07:47:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754170AbXK1Mr0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Nov 2007 07:47:26 -0500
Received: from fxip-0047f.externet.hu ([88.209.222.127]:48297 "EHLO
	dorka.pomaz.szeredi.hu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751864AbXK1MrZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2007 07:47:25 -0500
To: mingo@elte.hu
CC: jdike@addtoit.com, user-mode-linux-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
Subject: -rt doesn't compile for UML
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Message-Id: <E1IxMK0-0006ae-2s@dorka.pomaz.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Wed, 28 Nov 2007 13:47:20 +0100
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

When writing a big file to a ubd disk, everything in uml slows down to
a crawl, even though CPU usage is minimal.

So I wanted to try the latency tracer from -rt, but it doesn't compile
with UML:

  CC      arch/um/kernel/asm-offsets.s
In file included from arch/um/include/sysdep/kernel-offsets.h:2,
                 from arch/um/kernel/asm-offsets.c:1:
include/linux/sched.h: In function ‘set_tsk_need_resched_delayed’:
include/linux/sched.h:2105: error: ‘TIF_NEED_RESCHED_DELAYED’ undeclared (first use in this function)
include/linux/sched.h:2105: error: (Each undeclared identifier is reported only once
include/linux/sched.h:2105: error: for each function it appears in.)
include/linux/sched.h: In function ‘clear_tsk_need_resched_delayed’:
include/linux/sched.h:2110: error: ‘TIF_NEED_RESCHED_DELAYED’ undeclared (first use in this function)
include/linux/sched.h: In function ‘need_resched_delayed’:
include/linux/sched.h:2115: error: ‘TIF_NEED_RESCHED_DELAYED’ undeclared (first use in this function)
make[1]: *** [arch/um/kernel/asm-offsets.s] Error 1
make: *** [prepare0] Error 2

Ingo, do you think this route is worthwhile pursuing, or is it too
difficult to make -rt work for UML?

Thanks,
Miklos
