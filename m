Return-Path: <linux-kernel-owner+w=401wt.eu-S1754434AbZJESEu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754434AbZJESEu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Oct 2009 14:04:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754424AbZJESEt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Oct 2009 14:04:49 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:59595 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754374AbZJESEt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Oct 2009 14:04:49 -0400
Date: Mon, 5 Oct 2009 11:04:28 -0700
From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Daniel Lezcano <dlezcano@fr.ibm.com>,
       Sukadev Bhattiprolu <sukadev@us.ibm.com>,
       Linux Containers <containers@lists.osdl.org>, roland@redhat.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/4] signals: kill force_sig_specific()
Message-ID: <20091005180428.GD30442@us.ibm.com>
References: <4AC608BE.9020805@fr.ibm.com> <20091003171029.GA30442@us.ibm.com> <20091004021844.GA21006@redhat.com> <20091004022050.GE21006@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091004022050.GE21006@redhat.com>
X-Operating-System: Linux 2.0.32 on an i486
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oleg Nesterov [oleg@redhat.com] wrote:
| Kill force_sig_specific(), this trivial wrapper has no callers.
| 
| Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Reviewed-by: Sukadev Bhattiprolu <sukadev@us.ibm.com>
| ---
| 
|  include/linux/sched.h |    1 -
|  kernel/signal.c       |    6 ------
|  2 files changed, 7 deletions(-)
| 
| --- TTT_32/include/linux/sched.h~4_KILL_force_sig_specific	2009-10-04 02:21:49.000000000 +0200
| +++ TTT_32/include/linux/sched.h	2009-10-04 04:08:01.000000000 +0200
| @@ -2062,7 +2062,6 @@ extern int kill_proc_info(int, struct si
|  extern int do_notify_parent(struct task_struct *, int);
|  extern void __wake_up_parent(struct task_struct *p, struct task_struct *parent);
|  extern void force_sig(int, struct task_struct *);
| -extern void force_sig_specific(int, struct task_struct *);
|  extern int send_sig(int, struct task_struct *, int);
|  extern void zap_other_threads(struct task_struct *p);
|  extern struct sigqueue *sigqueue_alloc(void);
| --- TTT_32/kernel/signal.c~4_KILL_force_sig_specific	2009-10-04 03:48:48.000000000 +0200
| +++ TTT_32/kernel/signal.c	2009-10-04 04:08:36.000000000 +0200
| @@ -1032,12 +1032,6 @@ force_sig_info(int sig, struct siginfo *
|  	return ret;
|  }
| 
| -void
| -force_sig_specific(int sig, struct task_struct *t)
| -{
| -	force_sig_info(sig, SEND_SIG_FORCED, t);
| -}
| -
|  /*
|   * Nuke all other threads in the group.
|   */
