Return-Path: <linux-kernel-owner+w=401wt.eu-S1759126AbYGRMWr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759126AbYGRMWr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2008 08:22:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758813AbYGRMW2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jul 2008 08:22:28 -0400
Received: from x346.tv-sign.ru ([89.108.83.215]:59641 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758815AbYGRMW1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2008 08:22:27 -0400
Date: Fri, 18 Jul 2008 16:25:53 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: David Howells <dhowells@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] coredump: make the coredumping process visible to oom kill
Message-ID: <20080718122553.GA131@tv-sign.ru>
References: <20080716135358.GA1213@tv-sign.ru> <16025.1216378932@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <16025.1216378932@redhat.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/18, David Howells wrote:
>
> Oleg Nesterov <oleg@tv-sign.ru> wrote:
>
> > I am worried the recent changes can break elf_fdpic_core_dump(), I can't
> > test it. Hopefully, in that case the fixes should be trivial.
>
> I can't apply your patch 2/2.  Is there another patch missing?

Yes, the full series is

	coredump-zap_threads-comments-use-while_each_thread.patch
	introduce-pf_kthread-flag.patch
	kill-pf_borrowed_mm-in-favour-of-pf_kthread.patch
	coredump-zap_threads-must-skip-kernel-threads.patch
	coredump-elf_core_dump-skip-kernel-threads.patch
	coredump-turn-mm-core_startup_done-into-the-pointer-to-struct-core_state.patch
	coredump-move-mm-core_waiters-into-struct-core_state.patch
	coredump-simplify-core_state-nr_threads-calculation.patch
	coredump-turn-core_state-nr_threads-into-atomic_t.patch
	coredump-make-mm-core_state-visible-to-core_dump.patch
	coredump-construct-the-list-of-coredumping-threads-at-startup-time.patch
	coredump-elf_core_dump-use-core_state-dumper-list.patch
	coredump-elf_fdpic_core_dump-use-core_state-dumper-list.patch
	coredump-kill-mm-core_done.patch
	coredump-binfmt_elf_fdpic-dont-use-sub-threads-mm.patch
	coredump-exit_mm-clear-mm-first-then-play-with-core_state.patch

The first 5 patches are only needed to avoid the conflicts.

I'll send you this series off-list.

Oleg.

