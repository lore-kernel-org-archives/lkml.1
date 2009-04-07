Return-Path: <linux-kernel-owner+w=401wt.eu-S1758733AbZDGE03@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758733AbZDGE03 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 00:26:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751894AbZDGE0U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 00:26:20 -0400
Received: from ozlabs.org ([203.10.76.45]:47543 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751202AbZDGE0T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 00:26:19 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PULL] kthread and two misc cleanups (all long in linux-next)
Date: Tue, 7 Apr 2009 13:56:12 +0930
User-Agent: KMail/1.11.2 (Linux/2.6.27-11-generic; KDE/4.2.2; i686; ; )
Cc: linux-kernel@vger.kernel.org, Lai Jiangshan <laijs@cn.fujitsu.com>,
       Vitaliy Gusev <vgusev@openvz.org>, Oleg Nesterov <oleg@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200904071356.13545.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit d508afb437daee7cf07da085b635c44a4ebf9b38:             
  Trond Myklebust (1):                                                                   
        NFS: Fix a double free in nfs_parse_mount_options()                              

are available in the git repository at:

  ssh://master.kernel.org/pub/scm/linux/kernel/git/rusty/linux-2.6-for-linus.git master

Andrew Morton (1):
      work_on_cpu(): rewrite it to create a kernel thread on demand

Lai Jiangshan (1):
      cpuhotplug: remove cpu_hotplug_init()

Oleg Nesterov (1):
      kthread: move sched-realeted initialization from kthreadd context

Rusty Russell (1):
      misc: remove redundant start_kernel prototypes.

Vitaliy Gusev (1):
      kthread: Don't looking for a task in create_kthread() #2

 include/asm-frv/gdb-stub.h     |    1 -
 include/asm-mn10300/gdb-stub.h |    1 -
 include/linux/cpu.h            |    5 -----
 init/main.c                    |    1 -
 kernel/cpu.c                   |   11 +++--------
 kernel/kthread.c               |   26 ++++++++++++--------------
 kernel/workqueue.c             |   36 +++++++++++++++++++-----------------
 7 files changed, 34 insertions(+), 47 deletions(-)

commit 2bb68fd7b6882ec39688d187ad89917ce734e9c8
Author: Rusty Russell <rusty@rustcorp.com.au>
Date:   Tue Apr 7 13:51:33 2009 -0600

    misc: remove redundant start_kernel prototypes.
    
    No need for redeclaration.
    
    Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

 include/asm-frv/gdb-stub.h     |    1 -
 include/asm-mn10300/gdb-stub.h |    1 -
 2 files changed, 0 insertions(+), 2 deletions(-)

commit 49f3e4288e07854308caabe790e8491c2e64faf9
Author: Lai Jiangshan <laijs@cn.fujitsu.com>
Date:   Tue Feb 17 17:08:40 2009 +0800

    cpuhotplug: remove cpu_hotplug_init()
    
    cpu_hotplug_init() is almost equal to a dummy function,
    this patch remove it.
    
    Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
    Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

 include/linux/cpu.h |    5 -----
 init/main.c         |    1 -
 kernel/cpu.c        |   11 +++--------
 3 files changed, 3 insertions(+), 14 deletions(-)

commit f52a0223e95a5f49f028f61902c86b12ad81df5d
Author: Vitaliy Gusev <vgusev@openvz.org>
Date:   Tue Apr 7 13:51:35 2009 -0600

    kthread: Don't looking for a task in create_kthread() #2
    
    Remove the unnecessary find_task_by_pid_ns(). kthread() can just
    use "current" to get the same result.
    
    Signed-off-by: Vitaliy Gusev <vgusev@openvz.org>
    Acked-by: Oleg Nesterov <oleg@redhat.com>
    Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

 kernel/kthread.c |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

commit 5fc789815a655473119ccc8df8199ae39639db91
Author: Oleg Nesterov <oleg@redhat.com>
Date:   Tue Apr 7 13:51:35 2009 -0600

    kthread: move sched-realeted initialization from kthreadd context
    
    kthreadd is the single thread which implements ths "create" request, move
    sched_setscheduler/etc from create_kthread() to kthread_create() to
    improve the scalability.
    
    We should be careful with sched_setscheduler(), use _nochek helper.
    
    Signed-off-by: Oleg Nesterov <oleg@redhat.com>
    Cc: Christoph Hellwig <hch@lst.de>
    Cc: "Eric W. Biederman" <ebiederm@xmission.com>
    Cc: Ingo Molnar <mingo@elte.hu>
    Cc: Pavel Emelyanov <xemul@openvz.org>
    Cc: Vitaliy Gusev <vgusev@openvz.org
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
    Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

 kernel/kthread.c |   22 +++++++++++-----------
 1 files changed, 11 insertions(+), 11 deletions(-)

commit 188b4afa4bc94d7aaefac27fe37263df107f4c2d
Author: Andrew Morton <akpm@linux-foundation.org>
Date:   Tue Apr 7 13:51:35 2009 -0600

    work_on_cpu(): rewrite it to create a kernel thread on demand
    
    The various implemetnations and proposed implemetnations of work_on_cpu()
    are vulnerable to various deadlocks because they all used queues of some
    form.
    
    Unrelated pieces of kernel code thus gained dependencies wherein if one
    work_on_cpu() caller holds a lock which some other work_on_cpu() callback
    also takes, the kernel could rarely deadlock.
    
    Fix this by creating a short-lived kernel thread for each work_on_cpu()
    invokation.
    
    This is not terribly fast, but the only current caller of work_on_cpu() is
    pci_call_probe().
    
    It would be nice to find some other way of doing the node-local
    allocations in the PCI probe code so that we can zap work_on_cpu()
    altogether.  The code there is rather nasty.  I can't think of anything
    simple at this time...
    
    Cc: Rusty Russell <rusty@rustcorp.com.au>
    Cc: Ingo Molnar <mingo@elte.hu>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
    Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

 kernel/workqueue.c |   36 +++++++++++++++++++-----------------
 1 files changed, 19 insertions(+), 17 deletions(-)
