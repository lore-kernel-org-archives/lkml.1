Return-Path: <linux-kernel-owner+w=401wt.eu-S1752641AbXJWNw1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752641AbXJWNw1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2007 09:52:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751682AbXJWNwU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Oct 2007 09:52:20 -0400
Received: from mx1.redhat.com ([66.187.233.31]:39182 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751564AbXJWNwT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2007 09:52:19 -0400
Date: Tue, 23 Oct 2007 09:52:08 -0400
From: Rik van Riel <riel@redhat.com>
To: Pavel Emelyanov <xemul@openvz.org>
Cc: Miklos Szeredi <miklos@szeredi.hu>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, xemul@openvz.org, raven@themaw.net
Subject: Re: futex strangeness in 2.6.23-mm1/UML
Message-ID: <20071023095208.06c62f59@bree.surriel.com>
In-Reply-To: <471DB710.1060603@openvz.org>
References: <E1Ik15P-0001wg-00@dorka.pomaz.szeredi.hu>
	<20071022145321.195d929b@bree.surriel.com>
	<E1Ik4Ch-000273-00@dorka.pomaz.szeredi.hu>
	<20071022172926.03ca122a@bree.surriel.com>
	<20071022200742.6f3acbb2@bree.surriel.com>
	<20071022171624.0c00f8da.akpm@linux-foundation.org>
	<E1IkEJP-0004Qp-00@dorka.pomaz.szeredi.hu>
	<471DB710.1060603@openvz.org>
Organization: Red Hat, Inc.
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.4; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 23 Oct 2007 12:55:44 +0400
Pavel Emelyanov <xemul@openvz.org> wrote:

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

The patch above fixes the issue for me.

Autofs works again as expected.

-- 
"Debugging is twice as hard as writing the code in the first place.
Therefore, if you write the code as cleverly as possible, you are,
by definition, not smart enough to debug it." - Brian W. Kernighan
