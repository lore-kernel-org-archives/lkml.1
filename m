Return-Path: <linux-kernel-owner+w=401wt.eu-S1755079AbZBGUxV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755079AbZBGUxV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Feb 2009 15:53:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753216AbZBGUxN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Feb 2009 15:53:13 -0500
Received: from mx2.redhat.com ([66.187.237.31]:58043 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753204AbZBGUxN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Feb 2009 15:53:13 -0500
Date: Sat, 7 Feb 2009 15:50:39 -0500
From: Chuck Ebbert <cebbert@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Chris Mason <chris.mason@oracle.com>, Ingo Molnar <mingo@elte.hu>
Subject: Build failure with latest -git: btrfs on ppc64
Message-ID: <20090207155039.3b6a7429@dhcp-100-2-144.bos.redhat.com>
Organization: Red Hat, Inc.
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fs/btrfs/locking.c: In function 'btrfs_path_lock_waiting':
fs/btrfs/locking.c:254: error: implicit declaration of function '__raw_spin_is_contended'

Looks like spin_is_contended() is only available on mips and x86??

$ grep -R spin_is_contended *
arch/x86/include/asm/spinlock.h:static inline int __ticket_spin_is_contended(raw_spinlock_t *lock)
arch/x86/include/asm/spinlock.h: * __byte_spin_is_contended.
arch/x86/include/asm/spinlock.h:static inline int __byte_spin_is_contended(raw_spinlock_t *lock)
arch/x86/include/asm/spinlock.h:static inline int __raw_spin_is_contended(raw_spinlock_t *lock)
arch/x86/include/asm/spinlock.h:	return __ticket_spin_is_contended(lock);
arch/x86/include/asm/paravirt.h:	int (*spin_is_contended)(struct raw_spinlock *lock);
arch/x86/include/asm/paravirt.h:static inline int __raw_spin_is_contended(struct raw_spinlock *lock)
arch/x86/include/asm/paravirt.h:	return PVOP_CALL1(int, pv_lock_ops.spin_is_contended, lock);
arch/x86/kernel/paravirt-spinlocks.c:	.spin_is_contended = __ticket_spin_is_contended,
arch/x86/kernel/paravirt-spinlocks.c:	pv_lock_ops.spin_is_contended = __byte_spin_is_contended;
arch/x86/xen/spinlock.c:static int xen_spin_is_contended(struct raw_spinlock *lock)
arch/x86/xen/spinlock.c:	pv_lock_ops.spin_is_contended = xen_spin_is_contended;
arch/mips/include/asm/spinlock.h:static inline int __raw_spin_is_contended(raw_spinlock_t *lock)
fs/btrfs/locking.c:		if (spin_is_contended(&eb->lock) ||
include/linux/spinlock.h:#define spin_is_contended(lock) ((lock)->break_lock)
include/linux/spinlock.h:#define spin_is_contended(lock)	__raw_spin_is_contended(&(lock)->raw_lock)
include/linux/sched.h:	return spin_is_contended(lock);
include/linux/spinlock_up.h:#define __raw_spin_is_contended(lock)	(((void)(lock), 0))
