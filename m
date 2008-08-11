Return-Path: <linux-kernel-owner+w=401wt.eu-S1752280AbYHKJfh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752280AbYHKJfh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2008 05:35:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751079AbYHKJf3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Aug 2008 05:35:29 -0400
Received: from smtp-out.google.com ([216.239.33.17]:44652 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751014AbYHKJf3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2008 05:35:29 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=uIWUFk/rcqRrI/dgIB7RzP2ZAyJxeF33sCzS/+S2A2gELClLYoDwTlWVm5K1nytWA
	VfO4+ywSflwLbTbkQeGvQ==
Message-ID: <6599ad830808110235s1ba7bcf0y9fa23908479d20d1@mail.gmail.com>
Date: Mon, 11 Aug 2008 02:35:21 -0700
From: "Paul Menage" <menage@google.com>
To: "Rakib Mullick" <rakib.mullick@gmail.com>
Subject: Re: [PATCH] cgroup.c: remove goto statement from cgroup_init.
Cc: "Paul Jackson" <pj@sgi.com>, linux-kernel@vger.kernel.org
In-Reply-To: <b9df5fa10808110225r2772ab62w155fdec7af5759d8@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <b9df5fa10808110225r2772ab62w155fdec7af5759d8@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 11, 2008 at 2:25 AM, Rakib Mullick <rakib.mullick@gmail.com> wrote:
> Hello everyone, following patch removes the use of goto statement.
> Actually, we don't need it. Beacuse, if "err < 0", then it will never
> be TRUE.

"err" will be regarded by the compiler as true if it's anything other
than 0. So this patch introduces breakage.

Paul

> So, we can skip the goto statement and can just return.
> Thanks.
>
> Signed-off-by: Rakib Mullick (rakib.mullick@gmail.com)
>
> --- linux-2.6.27-rc2.orig/kernel/cgroup.c       2008-08-11 15:16:49.000000000 +0600
> +++ linux-2.6.27-rc2/kernel/cgroup.c    2008-08-11 15:16:26.000000000 +0600
> @@ -2562,11 +2562,10 @@ int __init cgroup_init(void)
>
>        err = register_filesystem(&cgroup_fs_type);
>        if (err < 0)
> -               goto out;
> +               return err;
>
>        proc_create("cgroups", 0, NULL, &proc_cgroupstats_operations);
>
> -out:
>        if (err)
>                bdi_destroy(&cgroup_backing_dev_info);
>
