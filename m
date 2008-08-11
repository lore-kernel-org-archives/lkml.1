Return-Path: <linux-kernel-owner+w=401wt.eu-S1752524AbYHKI4l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752524AbYHKI4l (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2008 04:56:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751335AbYHKI4d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Aug 2008 04:56:33 -0400
Received: from smtp-out.google.com ([216.239.33.17]:38487 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751093AbYHKI4c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2008 04:56:32 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=fv3cptOpsgOGXGa9lBuPA1lRtwGVa1cD+4f3ZgF6Ui39Bfc9esL/ltL4m4SpMd0aC
	yK1/JAmTyIIl7WHIqeMpA==
Message-ID: <6599ad830808110156j3ad0aeacjbd00739a4e7bb906@mail.gmail.com>
Date: Mon, 11 Aug 2008 01:56:26 -0700
From: "Paul Menage" <menage@google.com>
To: "Adrian Bunk" <bunk@kernel.org>
Subject: Re: [2.6 patch] make cgroup_is_removed() static
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20080810211530.GB5480@cs181140183.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080810211530.GB5480@cs181140183.pp.htv.fi>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 10, 2008 at 2:15 PM, Adrian Bunk <bunk@kernel.org> wrote:
> cgroup_is_removed() can now become static.
>
> Additionally, make it no longer "inline" but let gcc decide whether or
> not to inline it.
>
> Signed-off-by: Adrian Bunk <bunk@kernel.org>

Acked-by: Paul Menage <menage@google.com>

It might become non-static again in some future changes that I'm
planning for the locking, but we can make that change if/when it
arises.

>
> ---
> 8e37a5ecc6f51b3904d5be693c16324bad6923c5
> diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
> index c98dd7c..f5df0ae 100644
> --- a/include/linux/cgroup.h
> +++ b/include/linux/cgroup.h
> @@ -295,8 +295,6 @@ int cgroup_add_files(struct cgroup *cgrp,
>                        const struct cftype cft[],
>                        int count);
>
> -int cgroup_is_removed(const struct cgroup *cgrp);
> -
>  int cgroup_path(const struct cgroup *cgrp, char *buf, int buflen);
>
>  int cgroup_task_count(const struct cgroup *cgrp);
> diff --git a/kernel/cgroup.c b/kernel/cgroup.c
> index 13932ab..e6d6d40 100644
> --- a/kernel/cgroup.c
> +++ b/kernel/cgroup.c
> @@ -119,7 +119,7 @@ static int need_forkexit_callback __read_mostly;
>  static int need_mm_owner_callback __read_mostly;
>
>  /* convenient tests for these bits */
> -inline int cgroup_is_removed(const struct cgroup *cgrp)
> +static int cgroup_is_removed(const struct cgroup *cgrp)
>  {
>        return test_bit(CGRP_REMOVED, &cgrp->flags);
>  }
>
>
