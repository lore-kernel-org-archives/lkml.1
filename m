Return-Path: <linux-kernel-owner+w=401wt.eu-S1765505AbXJXQ7u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765505AbXJXQ7u (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 12:59:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764351AbXJXQqZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 12:46:25 -0400
Received: from smtp-out.google.com ([216.239.33.17]:30036 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757050AbXJXQqX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 12:46:23 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=hNw0SKV63/HDf4wwCSHmAEgsMjgs/i4kOOt/cZhMzJbga0ZegPmUlbnumeYkVyxoX
	9j06W67qGfRcAltBvRaEw==
Message-ID: <6599ad830710240946u2eb97013u4ad967ec7d801188@mail.gmail.com>
Date: Wed, 24 Oct 2007 09:46:15 -0700
From: "Paul Menage" <menage@google.com>
To: "Adrian Bunk" <bunk@kernel.org>
Subject: Re: [2.6 patch] kernel/cgroup.c: make 2 functions static
Cc: "Paul Jackson" <pj@sgi.com>, linux-kernel@vger.kernel.org
In-Reply-To: <20071024162339.GT30533@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20071024162339.GT30533@stusta.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/24/07, Adrian Bunk <bunk@kernel.org> wrote:
> cgroup_is_releasable() and notify_on_release() should be static,
> not global inline.
>
> Signed-off-by: Adrian Bunk <bunk@kernel.org>

Acked-by: Paul Menage <menage@google.com>

>
> ---
>
>  kernel/cgroup.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> 626d10ec224de07fc7906b0aa82e035e153709ce
> diff --git a/kernel/cgroup.c b/kernel/cgroup.c
> index 5987dcc..fec1726 100644
> --- a/kernel/cgroup.c
> +++ b/kernel/cgroup.c
> @@ -143,7 +143,7 @@ enum {
>         ROOT_NOPREFIX, /* mounted subsystems have no named prefix */
>  };
>
> -inline int cgroup_is_releasable(const struct cgroup *cgrp)
> +static int cgroup_is_releasable(const struct cgroup *cgrp)
>  {
>         const int bits =
>                 (1 << CGRP_RELEASABLE) |
> @@ -151,7 +151,7 @@ inline int cgroup_is_releasable(const struct cgroup *cgrp)
>         return (cgrp->flags & bits) == bits;
>  }
>
> -inline int notify_on_release(const struct cgroup *cgrp)
> +static int notify_on_release(const struct cgroup *cgrp)
>  {
>         return test_bit(CGRP_NOTIFY_ON_RELEASE, &cgrp->flags);
>  }
>
>
