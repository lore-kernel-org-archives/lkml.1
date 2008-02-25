Return-Path: <linux-kernel-owner+w=401wt.eu-S1759632AbYBYGW6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759632AbYBYGW6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2008 01:22:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753660AbYBYGWu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Feb 2008 01:22:50 -0500
Received: from smtp-out.google.com ([216.239.33.17]:36582 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752176AbYBYGWt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2008 01:22:49 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=rkZkHKABj8NOyY8wYq/Mjtazu6vj64AcndbQSUjPEk9sCPsqD+ddUH+Yn896Mt+Os
	nE4S1Ac7RhXuqVM7TD7UQ==
Message-ID: <6599ad830802242222p7d42d2b2ue7c585eae8f3bed@mail.gmail.com>
Date: Sun, 24 Feb 2008 22:22:44 -0800
From: "Paul Menage" <menage@google.com>
To: "Li Zefan" <lizf@cn.fujitsu.com>
Subject: Re: [PATCH] cgroup: fix default notify_on_release setting
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       containers@lists.linux-foundation.org
In-Reply-To: <47C257EB.5060600@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <47C257EB.5060600@cn.fujitsu.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 24, 2008 at 9:53 PM, Li Zefan <lizf@cn.fujitsu.com> wrote:
> The documentation says the default value of notify_on_release of
>  a child cgroup is inherited from its parent, which is reasonable,
>  but the implementation just sets the flag disabled.
>
>  Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>

Acked-by: Paul Menage <menage@google.com>

Yes, I guess it makes sense to follow the original cpusets behaviour.
I think that got lost when the notify-on-release functionality was
temporarily removed during cgroups development.

>  ---
>   kernel/cgroup.c |    4 +++-
>   1 files changed, 3 insertions(+), 1 deletions(-)
>
>  diff --git a/kernel/cgroup.c b/kernel/cgroup.c
>  index d8abe99..e9c2fb0 100644
>  --- a/kernel/cgroup.c
>  +++ b/kernel/cgroup.c
>  @@ -2232,7 +2232,6 @@ static long cgroup_create(struct cgroup *parent, struct dentry *dentry,
>
>         mutex_lock(&cgroup_mutex);
>
>  -       cgrp->flags = 0;
>         INIT_LIST_HEAD(&cgrp->sibling);
>         INIT_LIST_HEAD(&cgrp->children);
>         INIT_LIST_HEAD(&cgrp->css_sets);
>  @@ -2242,6 +2241,9 @@ static long cgroup_create(struct cgroup *parent, struct dentry *dentry,
>         cgrp->root = parent->root;
>         cgrp->top_cgroup = parent->top_cgroup;
>
>  +       if (notify_on_release(parent))
>  +               set_bit(CGRP_NOTIFY_ON_RELEASE, &cgrp->flags);
>  +
>         for_each_subsys(root, ss) {
>                 struct cgroup_subsys_state *css = ss->create(ss, cgrp);
>                 if (IS_ERR(css)) {
>  --
>  1.5.4.rc3
>
>
