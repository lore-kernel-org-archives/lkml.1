Return-Path: <linux-kernel-owner+w=401wt.eu-S1764272AbYBTDEw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764272AbYBTDEw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 22:04:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756889AbYBTDEn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 22:04:43 -0500
Received: from smtp-out.google.com ([216.239.45.13]:28606 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755546AbYBTDEm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 22:04:42 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=rTy3d7u9Tuk2c1PfBE0t4SvNXGxXUAgXQxFCD3LXtq6mLDPeKc3cE2ZsjsCO4gx3h
	GmnVnaBPlpVtTGoY3xhEw==
Message-ID: <6599ad830802191904y5bdc78bbm8a1bb61b4e2c3e5c@mail.gmail.com>
Date: Tue, 19 Feb 2008 19:04:39 -0800
From: "Paul Menage" <menage@google.com>
To: "Li Zefan" <lizf@cn.fujitsu.com>
Subject: Re: [PATCH 4/7] cgroup: fix memory leak in cgroup_get_sb()
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       "KAMEZAWA Hiroyuki" <kamezawa.hiroyu@jp.fujitsu.com>,
       LKML <linux-kernel@vger.kernel.org>,
       containers@lists.linux-foundation.org
In-Reply-To: <47B91C7F.6080602@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <47B91C7F.6080602@cn.fujitsu.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Feb 17, 2008 9:49 PM, Li Zefan <lizf@cn.fujitsu.com> wrote:
> opts.release_agent is not kfree()ed in all necessary places.
>
> Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>

Acked-by: Paul Menage <menage@google.com>

Good catch, although hopefully something that would be extremely rare
in practice.

Thanks,

Paul

> ---
>  kernel/cgroup.c |    5 ++++-
>  1 files changed, 4 insertions(+), 1 deletions(-)
>
> diff --git a/kernel/cgroup.c b/kernel/cgroup.c
> index 0c35022..aa76bbd 100644
> --- a/kernel/cgroup.c
> +++ b/kernel/cgroup.c
> @@ -961,8 +961,11 @@ static int cgroup_get_sb(struct file_system_type *fs_type,
>         }
>
>         root = kzalloc(sizeof(*root), GFP_KERNEL);
> -       if (!root)
> +       if (!root) {
> +               if (opts.release_agent)
> +                       kfree(opts.release_agent);
>                 return -ENOMEM;
> +       }
>
>         init_cgroup_root(root);
>         root->subsys_bits = opts.subsys_bits;
> --
> 1.5.4.rc3
>
>
