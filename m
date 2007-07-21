Return-Path: <linux-kernel-owner+w=401wt.eu-S935087AbXGUDDK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935087AbXGUDDK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2007 23:03:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757181AbXGUDC5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jul 2007 23:02:57 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:54538 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756241AbXGUDC4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2007 23:02:56 -0400
Date: Fri, 20 Jul 2007 20:02:54 -0700
From: sukadev@us.ibm.com
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Containers <containers@lists.osdl.org>,
       Oleg Nesterov <oleg@tv-sign.ru>, Pavel Emelianov <xemul@openvz.org>
Subject: Re: [PATCH 4/5] [V2] Define is_global_init() and is_container_init()
Message-ID: <20070721030254.GA5344@us.ibm.com>
References: <20070719071206.GE10195@us.ibm.com> <20070719072158.GD28216@us.ibm.com> <20070720154113.db9fb8a4.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070720154113.db9fb8a4.akpm@linux-foundation.org>
User-Agent: Mutt/1.4.2.2i
X-Operating-System: Linux 2.0.32 on an i486
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton [akpm@linux-foundation.org] wrote:
| On Thu, 19 Jul 2007 00:21:58 -0700
| sukadev@us.ibm.com wrote:
| 
| > --- lx26-22-rc6-mm1a.orig/kernel/pid.c	2007-07-16 12:55:15.000000000 -0700
| > +++ lx26-22-rc6-mm1a/kernel/pid.c	2007-07-16 13:10:48.000000000 -0700
| > @@ -69,6 +69,13 @@ struct pid_namespace init_pid_ns = {
| >  	.last_pid = 0,
| >  	.child_reaper = &init_task
| >  };
| > +EXPORT_SYMBOL(init_pid_ns);
| > +
| > +int is_global_init(struct task_struct *tsk)
| > +{
| > +	return tsk == init_pid_ns.child_reaper;
| > +}
| > +EXPORT_SYMBOL(is_global_init);
| 
| I don't immediately see why init_pid_ns was exported to modules.

| 
| It would need to be exported if is_global_init() was made static inline in a
| header (which seems like a sensible thing to do), but it wasn't.

It did not need to be exported in this patch.

I have a couple of follow-on patches that cleaned up some header-file
dependencies and made is_global_init() inline. Those patches are
changing a bit as I merge them with Pavel Emelianov's pid ns changes.

I will send a separate patch to inline is_global_init().

Suka
