Return-Path: <linux-kernel-owner+w=401wt.eu-S1753496AbYKDMY3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753496AbYKDMY3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2008 07:24:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751565AbYKDMYV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Nov 2008 07:24:21 -0500
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:60067 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751481AbYKDMYU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2008 07:24:20 -0500
Message-Id: <20081104122405.046233722@attica.americas.sgi.com>
User-Agent: quilt/0.47-1
Date: Tue, 04 Nov 2008 06:24:05 -0600
From: holt@sgi.com
To: linux-kernel@vger.kernel.org, linux-ia64@vger.kernel.org
Cc: Petr Tesarik <ptesarik@suse.cz>, Tony Ernst <tee@sgi.com>,
       Robin Holt <holt@sgi.com>, Peter Zijlstra <peterz@infradead.org>,
       Ingo Molnar <mingo@elte.hu>
Subject: [Patch V3 0/3] Enable irqs when waiting for rwlocks
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

New in V3:
 * Handle rearrangement of some arch's include/asm directories.

New in V2:
 * get rid of ugly #ifdef's in kernel/spinlock.h
 * convert __raw_{read|write}_lock_flags to an inline func

SGI has observed that on large systems, interrupts are not serviced for
a long period of time when waiting for a rwlock. The following patch
series re-enables irqs while waiting for the lock, resembling the code
which is already there for spinlocks.

I only made the ia64 version, because the patch adds some overhead to
the fast path. I assume there is currently no demand to have this for
other architectures, because the systems are not so large. Of course,
the possibility to implement raw_{read|write}_lock_flags for any
architecture is still there.

Robin Holt
