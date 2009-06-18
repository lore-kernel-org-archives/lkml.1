Return-Path: <linux-kernel-owner+w=401wt.eu-S1753822AbZFRSwU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753822AbZFRSwU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jun 2009 14:52:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752779AbZFRSwM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Jun 2009 14:52:12 -0400
Received: from mx2.redhat.com ([66.187.237.31]:54015 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751548AbZFRSwM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jun 2009 14:52:12 -0400
Date: Thu, 18 Jun 2009 20:47:08 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Roland McGrath <roland@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Stanislaw Gruszka <sgruszka@redhat.com>,
       Vitaly Mayatskikh <vmayatsk@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH]
	ptrace-wait_task_zombie-do-not-account-traced-sub-threads-fix
Message-ID: <20090618184708.GA15790@redhat.com>
References: <20090615212648.GA22751@redhat.com> <20090616004510.2885FFC3D3@magilla.sf.frob.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090616004510.2885FFC3D3@magilla.sf.frob.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/15, Roland McGrath wrote:
>
> ACK, but I think it warrants a comment explaining that task_detached() here
> always means "ptrace'd but not reparented".

Please see below. Not sure my comment is more clear...

Signed-off-by: Oleg Nesterov <oleg@redhat.com>

--- PTRACE/kernel/exit.c~1_WAIT_REPARENTED_COMMENT	2009-06-18 20:39:07.000000000 +0200
+++ PTRACE/kernel/exit.c	2009-06-18 20:42:05.000000000 +0200
@@ -1188,7 +1188,10 @@ static int wait_task_zombie(struct wait_
 	}
 
 	traced = ptrace_reparented(p);
-
+	/*
+	 * It can be ptraced but not reparented, check
+	 * !task_detached() to filter out sub-threads.
+	 */
 	if (likely(!traced) && likely(!task_detached(p))) {
 		struct signal_struct *psig;
 		struct signal_struct *sig;

