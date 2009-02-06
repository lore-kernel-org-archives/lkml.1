Return-Path: <linux-kernel-owner+w=401wt.eu-S1755855AbZBFNIP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755855AbZBFNIP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Feb 2009 08:08:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753512AbZBFNH7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Feb 2009 08:07:59 -0500
Received: from tundra.namei.org ([65.99.196.166]:1567 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752528AbZBFNH6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Feb 2009 08:07:58 -0500
Date: Sat, 7 Feb 2009 00:06:56 +1100 (EST)
From: James Morris <jmorris@namei.org>
To: David Howells <dhowells@redhat.com>
cc: torvalds@osdl.org, akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org
Subject: Re: [PATCH] fork.c: fix NULL pointer dereference when nr_threads ==
 threads-max
In-Reply-To: <20090206081719.20378.39341.stgit@warthog.procyon.org.uk>
Message-ID: <alpine.LRH.1.10.0902070006370.18789@tundra.namei.org>
References: <20090206081719.20378.39341.stgit@warthog.procyon.org.uk>
User-Agent: Alpine 1.10 (LRH 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 6 Feb 2009, David Howells wrote:

> From: Li Zefan <lizf@cn.fujitsu.com>
> 
> I happened to forked lots of processes, and hit NULL pointer dereference.
> It is because in copy_process() after checking max_threads, 0 is returned
> but not -EAGAIN.
> 
> The bug is introduced by this patch:
> 
> | commit f1752eec6145c97163dbce62d17cf5d928e28a27
> | Author: David Howells <dhowells@redhat.com>
> | Date:   Fri Nov 14 10:39:17 2008 +1100
> |
> |    CRED: Detach the credentials from task_struct
> 
> Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
> Signed-off-by: David Howells <dhowells@redhat.com>

Acked-by: James Morris <jmorris@namei.org>


> ---
> 
>  kernel/fork.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> 
> diff --git a/kernel/fork.c b/kernel/fork.c
> index bf0cef8..586874d 100644
> --- a/kernel/fork.c
> +++ b/kernel/fork.c
> @@ -1007,6 +1007,7 @@ static struct task_struct *copy_process(unsigned long clone_flags,
>  	 * triggers too late. This doesn't hurt, the check is only there
>  	 * to stop root fork bombs.
>  	 */
> +	retval = -EAGAIN;
>  	if (nr_threads >= max_threads)
>  		goto bad_fork_cleanup_count;
>  
> 

-- 
James Morris
<jmorris@namei.org>
