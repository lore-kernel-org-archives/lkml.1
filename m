Return-Path: <linux-kernel-owner+w=401wt.eu-S932086AbZD0UKU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932086AbZD0UKU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Apr 2009 16:10:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758703AbZD0UKD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Apr 2009 16:10:03 -0400
Received: from mx2.redhat.com ([66.187.237.31]:59319 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758523AbZD0UKB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Apr 2009 16:10:01 -0400
Date: Mon, 27 Apr 2009 22:05:10 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Roland McGrath <roland@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: [PATCH] ptrace-tracehook_unsafe_exec-remove-the-stale-comment-fix
Message-ID: <20090427200510.GA6792@redhat.com>
References: <20090423212250.GA22537@redhat.com> <20090423232717.975ABFC3C7@magilla.sf.frob.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090423232717.975ABFC3C7@magilla.sf.frob.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(on top of ptrace-tracehook_unsafe_exec-remove-the-stale-comment.patch)

On 04/23, Roland McGrath wrote:
>
> > tracehook_unsafe_exec() doesn't need task_lock(), remove the old comment.
>
> Please make it instead say that cred_exec_mutex is held by the caller
> through the exec.

Thanks.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>

--- PTRACE/include/linux/tracehook.h~COMMENT_FIX	2009-04-23 23:20:20.000000000 +0200
+++ PTRACE/include/linux/tracehook.h	2009-04-27 21:59:54.000000000 +0200
@@ -142,6 +142,8 @@ static inline void tracehook_report_sysc
  * @task:		current task doing exec
  *
  * Return %LSM_UNSAFE_* bits applied to an exec because of tracing.
+ *
+ * task->cred_exec_mutex is held by the caller through the do_execve().
  */
 static inline int tracehook_unsafe_exec(struct task_struct *task)
 {

