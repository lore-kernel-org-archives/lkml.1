Return-Path: <linux-kernel-owner+w=401wt.eu-S1757191AbZDXOlV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757191AbZDXOlV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Apr 2009 10:41:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752769AbZDXOlI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Apr 2009 10:41:08 -0400
Received: from mx2.redhat.com ([66.187.237.31]:48328 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752354AbZDXOlH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Apr 2009 10:41:07 -0400
Date: Fri, 24 Apr 2009 16:34:46 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Hugh Dickins <hugh@veritas.com>
Cc: Al Viro <viro@ZenIV.linux.org.uk>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Joe Malicki <jmalicki@metacarta.com>, Michael Itz <mitz@metacarta.com>,
       Kenneth Baker <bakerk@metacarta.com>,
       Chris Wright <chrisw@sous-sol.org>, David Howells <dhowells@redhat.com>,
       Alexey Dobriyan <adobriyan@gmail.com>,
       Greg Kroah-Hartman <gregkh@suse.de>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, Roland McGrath <roland@redhat.com>
Subject: Re: [PATCH 3/2] check_unsafe_exec: rcu_read_unlock
Message-ID: <20090424143446.GA6849@redhat.com>
References: <20090406153127.GA21220@redhat.com> <Pine.LNX.4.64.0904191710320.9099@blonde.anvils> <20090421161006.GC5402@redhat.com> <alpine.LFD.2.00.0904210924270.2199@localhost.localdomain> <20090421171530.GA12014@redhat.com> <alpine.LFD.2.00.0904211032191.2199@localhost.localdomain> <Pine.LNX.4.64.0904212031120.10256@blonde.anvils> <20090423230156.GA31302@redhat.com> <20090423233157.GA22981@ZenIV.linux.org.uk> <Pine.LNX.4.64.0904241255580.20196@blonde.anvils>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0904241255580.20196@blonde.anvils>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/24, Hugh Dickins wrote:
>
> --- 2.6.30-rc3-next-20090424/fs/exec.c	2009-04-24 12:23:43.000000000 +0100
> +++ linux/fs/exec.c	2009-04-24 12:26:10.000000000 +0100
> @@ -1043,7 +1043,7 @@ int check_unsafe_exec(struct linux_binpr
>  		if (t->fs == p->fs)
>  			n_fs++;
>  	}
> -	rcu_read_lock();
> +	rcu_read_unlock();

I'd say this change is not bad. Except it discloses the fact I didn't
bother to test my trivial patch.

Thanks a lot Hugh!!!

And my apologies to all.

Oleg.

