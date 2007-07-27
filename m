Return-Path: <linux-kernel-owner+w=401wt.eu-S937308AbXG0OqT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937308AbXG0OqT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2007 10:46:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932815AbXG0OqI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jul 2007 10:46:08 -0400
Received: from mx2.netapp.com ([216.240.18.37]:32441 "EHLO mx2.netapp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932294AbXG0OqH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2007 10:46:07 -0400
X-IronPort-AV: E=Sophos;i="4.16,589,1175497200"; 
   d="dif'208?scan'208,208";a="86564849"
Subject: Re: NFSv4 poops itself
From: Trond Myklebust <Trond.Myklebust@netapp.com>
To: Jeff Garzik <jeff@garzik.org>
Cc: Marc Dietrich <Marc.Dietrich@ap.physik.uni-giessen.de>,
       kernel list <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <46A9F5D7.4050501@garzik.org>
References: <46A9EAB0.3090306@garzik.org>
	 <200707271537.00647.marc.dietrich@ap.physik.uni-giessen.de>
	 <46A9F5D7.4050501@garzik.org>
Content-Type: multipart/mixed; boundary="=-XXp+zWptCWBMJ1fynpep"
Organization: Network Appliance Inc
Date: Fri, 27 Jul 2007 10:45:50 -0400
Message-Id: <1185547550.6586.24.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
X-OriginalArrivalTime: 27 Jul 2007 14:46:02.0321 (UTC) FILETIME=[DA68AC10:01C7D05C]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-XXp+zWptCWBMJ1fynpep
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

On Fri, 2007-07-27 at 09:40 -0400, Jeff Garzik wrote:
> (please don't drop CC's when you reply to email; you are cutting 
> relevant people out of the loop)
> 
> 
> Marc Dietrich wrote:
> > me too, my server has 2.6.18-? (openSUSE 10.2). On the client 
> > (2.6.23-rc1-mm1), I also see (shortly before the hang)
> > 
> > Jul 26 13:09:19 fb07-iapwap2 kernel: =================================
> > Jul 26 13:09:19 fb07-iapwap2 kernel: [ INFO: inconsistent lock state ]
> > Jul 26 13:09:19 fb07-iapwap2 kernel: 2.6.23-rc1-mm1 #1
> > Jul 26 13:09:19 fb07-iapwap2 kernel: ---------------------------------
> > Jul 26 13:09:19 fb07-iapwap2 kernel: inconsistent {softirq-on-W} -> 
> > {in-softirq-W} usage.
> > Jul 26 13:09:19 fb07-iapwap2 kernel: hald/3873 [HC0[0]:SC1[1]:HE1:SE0] takes:
> > Jul 26 13:09:19 fb07-iapwap2 kernel:  (rpc_credcache_lock){-+..}, at: 
> > [<c01dc166>] _atomic_dec_and_lock+0x16/0x60
> > Jul 26 13:09:19 fb07-iapwap2 kernel: {softirq-on-W} state was registered at:
> > Jul 26 13:09:19 fb07-iapwap2 kernel:   [<c013d4f7>] mark_lock+0x77/0x630
> > Jul 26 13:09:19 fb07-iapwap2 kernel:   [<c013c094>] add_lock_to_list+0x44/0xc0
> > Jul 26 13:09:19 fb07-iapwap2 kernel:   [<c013e8af>] 
> > __lock_acquire+0x65f/0x1020
> > Jul 26 13:09:19 fb07-iapwap2 kernel:   [<c013db0e>] mark_held_locks+0x5e/0x80
> > Jul 26 13:09:19 fb07-iapwap2 kernel:   [<c012448d>] local_bh_enable+0x7d/0x130
> > Jul 26 13:09:19 fb07-iapwap2 kernel:   [<c013f2cf>] lock_acquire+0x5f/0x80
> > Jul 26 13:09:19 fb07-iapwap2 kernel:   [<c01dc166>] 
> > _atomic_dec_and_lock+0x16/0x60
> > Jul 26 13:09:19 fb07-iapwap2 kernel:   [<c02d156a>] _spin_lock+0x2a/0x40
> > Jul 26 13:09:19 fb07-iapwap2 kernel:   [<c01dc166>] 
> > _atomic_dec_and_lock+0x16/0x60
> > Jul 26 13:09:19 fb07-iapwap2 kernel:   [<c01dc166>] 
> > _atomic_dec_and_lock+0x16/0x60
> > Jul 26 13:09:19 fb07-iapwap2 kernel:   [<c02d156a>] _spin_lock+0x2a/0x40
> > Jul 26 13:09:19 fb07-iapwap2 kernel:   [<dcecf770>] put_rpccred+0x60/0x110 
> > [sunrpc]
> > Jul 26 13:09:19 fb07-iapwap2 kernel:   [<dcecf840>] 
> > rpcauth_unbindcred+0x20/0x60 [sunrpc]
> > Jul 26 13:09:19 fb07-iapwap2 kernel:   [<dcece1f4>] rpc_put_task+0x44/0xb0 
> > [sunrpc]
> > Jul 26 13:09:19 fb07-iapwap2 kernel:   [<dcec8ffd>] rpc_call_sync+0x2d/0x40 
> > [sunrpc]
> > Jul 26 13:09:19 fb07-iapwap2 kernel:   [<dced680d>] rpcb_register+0x10d/0x1c0 
> > [sunrpc]
> > Jul 26 13:09:19 fb07-iapwap2 kernel:   [<dced06ef>] svc_register+0x8f/0x160 
> > [sunrpc]
> [continues]

That particular hang in rpciod_down we do have a fix for, but it is not
related to the issue you were seeing Jeff.

Trond


--=-XXp+zWptCWBMJ1fynpep
Content-Disposition: inline; filename=linux-2.6.23-001-fix_rpciod_down_race.dif
Content-Type: message/rfc822; name=linux-2.6.23-001-fix_rpciod_down_race.dif

From: Trond Myklebust <Trond.Myklebust@netapp.com>
Date: Thu, 19 Jul 2007 16:32:20 -0400
SUNRPC: Fix a race in rpciod_down()
Subject: No Subject
Message-Id: <1185547550.6586.25.camel@localhost>
Mime-Version: 1.0

The commit 4ada539ed77c7a2bbcb75cafbbd7bd8d2b9bef7b lead to the unpleasant
possibility of an asynchronous rpc_task being required to call
rpciod_down() when it is complete. This again means that the rpciod
workqueue may get to call destroy_workqueue on itself -> hang...

Change rpciod_up/rpciod_down to just get/put the module, and then
create/destroy the workqueues on module load/unload.

Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
---

 net/sunrpc/sched.c |   57 +++++++++++++++++++++-------------------------------
 1 files changed, 23 insertions(+), 34 deletions(-)

diff --git a/net/sunrpc/sched.c b/net/sunrpc/sched.c
index b5723c2..954d7ec 100644
--- a/net/sunrpc/sched.c
+++ b/net/sunrpc/sched.c
@@ -50,8 +50,6 @@ static RPC_WAITQ(delay_queue, "delayq");
 /*
  * rpciod-related stuff
  */
-static DEFINE_MUTEX(rpciod_mutex);
-static atomic_t rpciod_users = ATOMIC_INIT(0);
 struct workqueue_struct *rpciod_workqueue;
 
 /*
@@ -961,60 +959,49 @@ void rpc_killall_tasks(struct rpc_clnt *clnt)
 	spin_unlock(&clnt->cl_lock);
 }
 
+int rpciod_up(void)
+{
+	return try_module_get(THIS_MODULE) ? 0 : -EINVAL;
+}
+
+void rpciod_down(void)
+{
+	module_put(THIS_MODULE);
+}
+
 /*
- * Start up the rpciod process if it's not already running.
+ * Start up the rpciod workqueue.
  */
-int
-rpciod_up(void)
+static int rpciod_start(void)
 {
 	struct workqueue_struct *wq;
-	int error = 0;
-
-	if (atomic_inc_not_zero(&rpciod_users))
-		return 0;
-
-	mutex_lock(&rpciod_mutex);
 
-	/* Guard against races with rpciod_down() */
-	if (rpciod_workqueue != NULL)
-		goto out_ok;
 	/*
 	 * Create the rpciod thread and wait for it to start.
 	 */
 	dprintk("RPC:       creating workqueue rpciod\n");
-	error = -ENOMEM;
 	wq = create_workqueue("rpciod");
-	if (wq == NULL)
-		goto out;
-
 	rpciod_workqueue = wq;
-	error = 0;
-out_ok:
-	atomic_inc(&rpciod_users);
-out:
-	mutex_unlock(&rpciod_mutex);
-	return error;
+	return rpciod_workqueue != NULL;
 }
 
-void
-rpciod_down(void)
+static void rpciod_stop(void)
 {
-	if (!atomic_dec_and_test(&rpciod_users))
-		return;
+	struct workqueue_struct *wq = NULL;
 
-	mutex_lock(&rpciod_mutex);
+	if (rpciod_workqueue == NULL)
+		return;
 	dprintk("RPC:       destroying workqueue rpciod\n");
 
-	if (atomic_read(&rpciod_users) == 0 && rpciod_workqueue != NULL) {
-		destroy_workqueue(rpciod_workqueue);
-		rpciod_workqueue = NULL;
-	}
-	mutex_unlock(&rpciod_mutex);
+	wq = rpciod_workqueue;
+	rpciod_workqueue = NULL;
+	destroy_workqueue(wq);
 }
 
 void
 rpc_destroy_mempool(void)
 {
+	rpciod_stop();
 	if (rpc_buffer_mempool)
 		mempool_destroy(rpc_buffer_mempool);
 	if (rpc_task_mempool)
@@ -1048,6 +1035,8 @@ rpc_init_mempool(void)
 						      rpc_buffer_slabp);
 	if (!rpc_buffer_mempool)
 		goto err_nomem;
+	if (!rpciod_start())
+		goto err_nomem;
 	return 0;
 err_nomem:
 	rpc_destroy_mempool();

--=-XXp+zWptCWBMJ1fynpep--
