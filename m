Return-Path: <linux-kernel-owner+w=401wt.eu-S1754090AbYFEGgU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754090AbYFEGgU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2008 02:36:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752407AbYFEGgH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jun 2008 02:36:07 -0400
Received: from smtp-out.google.com ([216.239.33.17]:6273 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751931AbYFEGgF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2008 02:36:05 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=nacyJgQd/y0BloCn2AWj6gU78XyELQGJUbvADrFPUBBo+FpEBDAAzYD4mGiJnaKSZ
	E6Tfo6/L71gE+OwHNuGLA==
Message-ID: <6599ad830806042335o7d8b93bdw13072267e4c5b455@mail.gmail.com>
Date: Wed, 4 Jun 2008 23:35:56 -0700
From: "Paul Menage" <menage@google.com>
To: "Li Zefan" <lizf@cn.fujitsu.com>
Subject: Re: [PATCH] cgroup: anotate two variables with __read_mostly
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "Linux Containers" <containers@lists.linux-foundation.org>
In-Reply-To: <48478187.7080204@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <48478187.7080204@cn.fujitsu.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 4, 2008 at 11:02 PM, Li Zefan <lizf@cn.fujitsu.com> wrote:
>
> - need_forkexit_callback will be read only after system boot.
> - use_task_css_set_links will be read only after it's set.
>
> And these 2 variables are checked when a new process is forked.
>
> Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>

Acked-by: Paul Menage <menage@google.com>

Thanks.

Paul

> ---
>  kernel/cgroup.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/kernel/cgroup.c b/kernel/cgroup.c
> index 15ac0e1..f5a1273 100644
> --- a/kernel/cgroup.c
> +++ b/kernel/cgroup.c
> @@ -118,7 +118,7 @@ static int root_count;
>  * extra work in the fork/exit path if none of the subsystems need to
>  * be called.
>  */
> -static int need_forkexit_callback;
> +static int need_forkexit_callback __read_mostly;
>  static int need_mm_owner_callback __read_mostly;
>
>  /* convenient tests for these bits */
> @@ -220,7 +220,7 @@ static struct hlist_head *css_set_hash(struct cgroup_subsys_state *css[])
>  * task until after the first call to cgroup_iter_start(). This
>  * reduces the fork()/exit() overhead for people who have cgroups
>  * compiled into their kernel but not actually in use */
> -static int use_task_css_set_links;
> +static int use_task_css_set_links __read_mostly;
>
>  /* When we create or destroy a css_set, the operation simply
>  * takes/releases a reference count on all the cgroups referenced
> --
> 1.5.4.rc3
>
