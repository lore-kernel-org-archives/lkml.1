Return-Path: <linux-kernel-owner+w=401wt.eu-S1752675AbXJWKYF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752675AbXJWKYF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2007 06:24:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751684AbXJWKXz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Oct 2007 06:23:55 -0400
Received: from mail-gw3.sa.ew.hu ([212.108.200.82]:35135 "EHLO
	mail-gw3.sa.ew.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751605AbXJWKXz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2007 06:23:55 -0400
To: xemul@openvz.org
CC: riel@redhat.com, akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       xemul@openvz.org, raven@themaw.net
In-reply-to: <471DB710.1060603@openvz.org> (message from Pavel Emelyanov on
	Tue, 23 Oct 2007 12:55:44 +0400)
Subject: Re: futex strangeness in 2.6.23-mm1/UML
References: <E1Ik15P-0001wg-00@dorka.pomaz.szeredi.hu>	<20071022145321.195d929b@bree.surriel.com>	<E1Ik4Ch-000273-00@dorka.pomaz.szeredi.hu>	<20071022172926.03ca122a@bree.surriel.com>	<20071022200742.6f3acbb2@bree.surriel.com> <20071022171624.0c00f8da.akpm@linux-foundation.org> <E1IkEJP-0004Qp-00@dorka.pomaz.szeredi.hu> <471DB710.1060603@openvz.org>
Message-Id: <E1IkGut-0004X1-00@dorka.pomaz.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Tue, 23 Oct 2007 12:23:19 +0200
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> >> I guess we can debug it in the old-fashioned ways.  The first of which is
> >> to palm the problem off on Pavel ;)
> 
> I look at the 2.6.23-mm1 and see that there's one hunk lost. This
> is the one Oleg re-sent some days ago (the mail thread subject was
> 2.6.23-mm1 thread exit_group issue). Here it is (sent 13 oct 2007):
> 
> --- kernel/fork.c~	2007-10-13 15:41:35.000000000 +0400
> +++ kernel/fork.c	2007-10-13 15:41:41.000000000 +0400
> @@ -1443,6 +1443,9 @@ long do_fork(unsigned long clone_flags,
>  			task_pid_nr_ns(p, current->nsproxy->pid_ns) :
>  				task_pid_vnr(p);
>  
> +		if (clone_flags & CLONE_PARENT_SETTID)
> +			put_user(nr, parent_tidptr);
> +
>  		if (clone_flags & CLONE_VFORK) {
>  			p->vfork_done = &vfork;
>  			init_completion(&vfork);
> 
> Please, try with this patch.

Thanks.  This patch does indeed seem to solve the problem.

Miklos
