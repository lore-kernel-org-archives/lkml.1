Return-Path: <linux-kernel-owner+w=401wt.eu-S1756043AbXL2RFT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756043AbXL2RFT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Dec 2007 12:05:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754255AbXL2RFG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Dec 2007 12:05:06 -0500
Received: from fg-out-1718.google.com ([72.14.220.157]:65303 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754240AbXL2RFF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Dec 2007 12:05:05 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type:content-disposition:user-agent;
        b=oYpYQDfboyjx3tlMoDPsLOrEe8tugCRROJUcq4VVHu4D8bmsmj1ob1OOGT7bAlPVgnbETUXp0HVnBnuLmMUJRYd7wX1QWd6cwnikA6AbNxcuvkdKmtkEhSvxasc4MCUXP1bAatzPj38Nx1otz5+YAfFgWZ/QD4FThBc1ZD7Dw6k=
Date: Sat, 29 Dec 2007 18:06:28 +0100
From: Marcin Slusarz <marcin.slusarz@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>
Subject: WARNING: at kernel/lockdep.c:2658 check_flags()
Message-ID: <20071229170554.GA21506@joi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi
Today I've got this (while i was upgrading my gentoo box):

WARNING: at kernel/lockdep.c:2658 check_flags()
Pid: 21680, comm: conftest Not tainted 2.6.24-rc6 #63

Call Trace:
 [<ffffffff80253457>] check_flags+0x1c7/0x1d0
 [<ffffffff80257217>] lock_acquire+0x57/0xc0
 [<ffffffff8024d5c0>] __atomic_notifier_call_chain+0x60/0xd0
 [<ffffffff8024d641>] atomic_notifier_call_chain+0x11/0x20
 [<ffffffff8024d67e>] notify_die+0x2e/0x30
 [<ffffffff8020da0a>] do_divide_error+0x5a/0xa0
 [<ffffffff80522bdd>] trace_hardirqs_on_thunk+0x35/0x3a
 [<ffffffff80255b89>] trace_hardirqs_on+0xd9/0x180
 [<ffffffff80522bdd>] trace_hardirqs_on_thunk+0x35/0x3a
 [<ffffffff80523c2d>] error_exit+0x0/0xa9

possible reason: unannotated irqs-off.
irq event stamp: 4693
hardirqs last  enabled at (4693): [<ffffffff80522bdd>] trace_hardirqs_on_thunk+0x35/0x3a
hardirqs last disabled at (4692): [<ffffffff80522c17>] trace_hardirqs_off_thunk+0x35/0x37
softirqs last  enabled at (3546): [<ffffffff80238343>] __do_softirq+0xb3/0xd0
softirqs last disabled at (3521): [<ffffffff8020c97c>] call_softirq+0x1c/0x30

This is 11ee29577cc1637f94d903a6ea322cf1ed8ce1b3:
Merge git://git.kernel.org/pub/scm/linux/kernel/git/bart/ide-2.6
from 25 Dec + some patches for udf (but I didn't mount it) and simple
patch for slab: http://lkml.org/lkml/2007/12/27/110

Marcin
