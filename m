Return-Path: <linux-kernel-owner+w=401wt.eu-S1760355AbZKFW2D@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760355AbZKFW2D (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Nov 2009 17:28:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760278AbZKFW1p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Nov 2009 17:27:45 -0500
Received: from kroah.org ([198.145.64.141]:57118 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932651AbZKFWXe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Nov 2009 17:23:34 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Fri Nov  6 14:15:50 2009
Message-Id: <20091106221550.359541615@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Fri, 06 Nov 2009 14:15:21 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Trond Myklebust <Trond.Myklebust@netapp.com>
Subject: [83/99] NFSv4: Fix two unbalanced put_rpccred() issues.
References: <20091106221358.309857998@mini.kroah.org>
Content-Disposition: inline; filename=nfsv4-fix-two-unbalanced-put_rpccred-issues.patch
In-Reply-To: <20091106221850.GA15408@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Trond Myklebust <Trond.Myklebust@netapp.com>

commit 141aeb9f26f9f12f1584c128ce8697cdffb046e7 upstream.

Commits 29fba38b (nfs41: lease renewal) and fc01cea9 (nfs41: sequence
operation) introduce a couple of put_rpccred() calls on credentials for
which there is no corresponding get_rpccred().

See http://bugzilla.kernel.org/show_bug.cgi?id=14249

Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/nfs/nfs4proc.c |    4 ----
 1 file changed, 4 deletions(-)

--- a/fs/nfs/nfs4proc.c
+++ b/fs/nfs/nfs4proc.c
@@ -3038,9 +3038,6 @@ static void nfs4_renew_done(struct rpc_t
 	if (time_before(clp->cl_last_renewal,timestamp))
 		clp->cl_last_renewal = timestamp;
 	spin_unlock(&clp->cl_lock);
-	dprintk("%s calling put_rpccred on rpc_cred %p\n", __func__,
-				task->tk_msg.rpc_cred);
-	put_rpccred(task->tk_msg.rpc_cred);
 }
 
 static const struct rpc_call_ops nfs4_renew_ops = {
@@ -4855,7 +4852,6 @@ void nfs41_sequence_call_done(struct rpc
 	nfs41_sequence_free_slot(clp, task->tk_msg.rpc_resp);
 	dprintk("%s rpc_cred %p\n", __func__, task->tk_msg.rpc_cred);
 
-	put_rpccred(task->tk_msg.rpc_cred);
 	kfree(task->tk_msg.rpc_argp);
 	kfree(task->tk_msg.rpc_resp);
 


