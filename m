Return-Path: <linux-kernel-owner+w=401wt.eu-S1752201AbZGZISe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752201AbZGZISe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Jul 2009 04:18:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752077AbZGZISd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Jul 2009 04:18:33 -0400
Received: from www.tglx.de ([62.245.132.106]:57745 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752044AbZGZISb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Jul 2009 04:18:31 -0400
Message-Id: <20090726081459.455111897@linutronix.de>
User-Agent: quilt/0.47-1
Date: Sun, 26 Jul 2009 08:17:05 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>
Subject: [Patch RFC 00/37]  Cleanup init_MUTEX[_LOCKED] / DECLARE_MUTEX
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are still semaphores left which are used as mutexes. Many of
them are not mutexes; they are used as completions and serialization
object at the same time. Some others are simple mutexes and nobody
bothered to clean them up.

Most of the cases have been identified in the preempt-rt patch. The
conversion to mutexes has been tested with both lockdep and mutex
debugging for quite a time. The other semaphore style users are simply
converted to semaphores and the init_MUTEX[_LOCKED] / DECLARE_MUTEX
confusion is removed.

Andrew: it would be great if we could merge the infrastructure patch
[1/n] right away. It does not change any code as it just adds
DEFINE_SEMAPHORE, semaphore_init() and semaphore_init_locked(). The
latter is marked deprecated as well as the locked init usually points
to a completion like use case. Merging it now would allow the
maintainers to queue up the cleanup patches for .32

Thanks,

	tglx



