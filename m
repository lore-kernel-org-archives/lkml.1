Return-Path: <linux-kernel-owner+w=401wt.eu-S1752590AbZDXEdf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752590AbZDXEdf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Apr 2009 00:33:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756767AbZDXEcT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Apr 2009 00:32:19 -0400
Received: from extu-mxob-1.symantec.com ([216.10.194.28]:42254 "EHLO
	extu-mxob-1.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756595AbZDXEcS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Apr 2009 00:32:18 -0400
Date: Fri, 24 Apr 2009 05:29:51 +0100 (BST)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.anvils
To: Oleg Nesterov <oleg@redhat.com>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Al Viro <viro@ZenIV.linux.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       Joe Malicki <jmalicki@metacarta.com>, Michael Itz <mitz@metacarta.com>,
       Kenneth Baker <bakerk@metacarta.com>,
       Chris Wright <chrisw@sous-sol.org>, David Howells <dhowells@redhat.com>,
       Alexey Dobriyan <adobriyan@gmail.com>,
       Greg Kroah-Hartman <gregkh@suse.de>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, Roland McGrath <roland@redhat.com>
Subject: Re: [PATCH 2/2] check_unsafe_exec: s/lock_task_sighand/rcu_read_lock/
In-Reply-To: <20090423230245.GB31302@redhat.com>
Message-ID: <Pine.LNX.4.64.0904240526080.15735@blonde.anvils>
References: <Pine.LNX.4.64.0904010106310.16500@blonde.anvils>
 <20090401023849.GW28946@ZenIV.linux.org.uk> <20090401030339.GX28946@ZenIV.linux.org.uk>
 <20090406153127.GA21220@redhat.com> <Pine.LNX.4.64.0904191710320.9099@blonde.anvils>
 <20090421161006.GC5402@redhat.com> <alpine.LFD.2.00.0904210924270.2199@localhost.localdomain>
 <20090421171530.GA12014@redhat.com> <alpine.LFD.2.00.0904211032191.2199@localhost.localdomain>
 <Pine.LNX.4.64.0904212031120.10256@blonde.anvils> <20090423230245.GB31302@redhat.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 23 Apr 2009, Oleg Nesterov wrote:
>  	write_lock(&p->fs->lock);
> -	lock_task_sighand(p, &flags);
> +	rcu_read_lock();
>  	for (t = next_thread(p); t != p; t = next_thread(t)) {
>  		if (t->fs == p->fs)
>  			n_fs++;
>  	}
> +	rcu_read_lock();

Not quite! if second rcu_read_lock() changed to rcu_read_unlock(), then
Acked-by: Hugh Dickins <hugh@veritas.com>
