Return-Path: <linux-kernel-owner+w=401wt.eu-S1757475AbYFPCR0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757475AbYFPCR0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jun 2008 22:17:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751891AbYFPCRS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Jun 2008 22:17:18 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:33408 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751380AbYFPCRR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jun 2008 22:17:17 -0400
Date: Mon, 16 Jun 2008 11:16:54 +0900
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Li Zefan <lizf@cn.fujitsu.com>
Subject: Re: [PATCH] introduce task cgroup v2
Cc: kosaki.motohiro@jp.fujitsu.com, containers@lists.osdl.org,
       LKML <linux-kernel@vger.kernel.org>, Paul Menage <menage@google.com>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <484E0F7F.3000606@cn.fujitsu.com>
References: <20080607195733.9C77.KOSAKI.MOTOHIRO@jp.fujitsu.com> <484E0F7F.3000606@cn.fujitsu.com>
Message-Id: <20080616111410.7896.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

> > v1 -> v2
> >   o implement can_attach() and attach() method.
> >   o remvoe can_fork member from cgroup_subsys.
> >     instead, copy_process() call task_cgroup_can_fork() directly.
> >   o fixed dead lock bug.
> >   o add Documentation/contoroller/task.txt
> > 
> 
> I think Documentation/kernel-parameters.txt should also be updated.
> 
> 	cgroup_disable= [KNL] Disable a particular controller
> 			Format: {name of the controller(s) to disable}
> 				{Currently supported controllers - "memory"}

Yup, You are right.
I'll fix it.

> > +config CGROUP_TASK
> > +	bool "Simple number of task accounting cgroup subsystem"
> > +	depends on CGROUPS && EXPERIMENTAL
> > +	default n
> > +	help
> > +          Provides a simple number of task accounting cgroup subsystem for
> 
> should use TAB

Ah, Thanks.


> > +static void task_cgroup_destroy(struct cgroup_subsys *ss, struct cgroup *cgrp)
> > +{
> > +	kfree(cgrp->subsys[task_cgroup_subsys_id]);
> 
> You should kfree task_cgroup* instead of cgroup_subsys_state*.

There point to the same address.
but, your opinion has better code clearness, of cource.

Thanks.



