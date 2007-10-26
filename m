Return-Path: <linux-kernel-owner+w=401wt.eu-S1762003AbXJZBPs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762003AbXJZBPs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2007 21:15:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752068AbXJZBPh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Oct 2007 21:15:37 -0400
Received: from smtp-out.google.com ([216.239.45.13]:26231 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752723AbXJZBPf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2007 21:15:35 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=lXIqqjJ1KfijoFSXcr90yLCtcg+YobinT9L0f/P8RVXeKzXB9/7Vkxb7w3Vi8KJsc
	KEbTCXqSW2JRIsReAdeiA==
Message-ID: <6599ad830710251815u6faaab53hab7f0b741a7a6ce5@mail.gmail.com>
Date: Thu, 25 Oct 2007 18:15:32 -0700
From: "Paul Menage" <menage@google.com>
To: "Paul Jackson" <pj@sgi.com>
Subject: Re: [RFC] cgroup brace coding style fix
Cc: "Adrian Bunk" <bunk@kernel.org>, linux-kernel@vger.kernel.org,
       "Andrew Morton" <akpm@linux-foundation.org>
In-Reply-To: <20071024173620.24359.59915.sendpatchset@jackhammer.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20071024173620.24359.59915.sendpatchset@jackhammer.engr.sgi.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/24/07, Paul Jackson <pj@sgi.com> wrote:
> From: Paul Jackson <pj@sgi.com>
>
> Coding style fix - one line conditionals don't get braces.
>
> Signed-off-by: Paul Jackson <pj@sgi.com>

Not a coding style that I'm in favor of, but I suppose it is the
kernel standard.

Acked-by: Paul Menage <menage@google.com>

>
> ---
>
> This patch applies --after-- Adrian Bunk's patch:
>     [2.6 patch] kernel/cgroup.c: remove dead code
>
>  kernel/cgroup.c |   15 +++++----------
>  1 file changed, 5 insertions(+), 10 deletions(-)
>
> --- 2.6.23-mm1.orig/kernel/cgroup.c     2007-10-24 09:51:20.289137770 -0700
> +++ 2.6.23-mm1/kernel/cgroup.c  2007-10-24 09:51:52.153617193 -0700
> @@ -1182,9 +1182,8 @@ static int attach_task(struct cgroup *cg
>         for_each_subsys(root, ss) {
>                 if (ss->can_attach) {
>                         retval = ss->can_attach(ss, cgrp, tsk);
> -                       if (retval) {
> +                       if (retval)
>                                 return retval;
> -                       }
>                 }
>         }
>
> @@ -1193,9 +1192,8 @@ static int attach_task(struct cgroup *cg
>          * based on its final set of cgroups
>          */
>         newcg = find_css_set(cg, cgrp);
> -       if (!newcg) {
> +       if (!newcg)
>                 return -ENOMEM;
> -       }
>
>         task_lock(tsk);
>         if (tsk->flags & PF_EXITING) {
> @@ -1215,9 +1213,8 @@ static int attach_task(struct cgroup *cg
>         write_unlock(&css_set_lock);
>
>         for_each_subsys(root, ss) {
> -               if (ss->attach) {
> +               if (ss->attach)
>                         ss->attach(ss, cgrp, oldcgrp, tsk);
> -               }
>         }
>         set_bit(CGRP_RELEASABLE, &oldcgrp->flags);
>         synchronize_rcu();
> @@ -1353,9 +1350,8 @@ static ssize_t cgroup_common_file_write(
>         {
>                 struct cgroupfs_root *root = cgrp->root;
>                 /* Strip trailing newline */
> -               if (nbytes && (buffer[nbytes-1] == '\n')) {
> +               if (nbytes && (buffer[nbytes-1] == '\n'))
>                         buffer[nbytes-1] = 0;
> -               }
>                 /* We never write anything other than '\0'
>                  * into the last char of release_agent_path,
>                  * so it always remains a NUL-terminated
> @@ -2123,9 +2119,8 @@ static inline int cgroup_has_css_refs(st
>                  * matter, since it can only happen if the cgroup
>                  * has been deleted and hence no longer needs the
>                  * release agent to be called anyway. */
> -               if (css && atomic_read(&css->refcnt)) {
> +               if (css && atomic_read(&css->refcnt))
>                         return 1;
> -               }
>         }
>         return 0;
>  }
>
> --
>                           I won't rest till it's the best ...
>                           Programmer, Linux Scalability
>                           Paul Jackson <pj@sgi.com> 1.650.933.1373
>
