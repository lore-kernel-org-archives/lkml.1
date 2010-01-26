Return-Path: <linux-kernel-owner+w=401wt.eu-S1752644Ab0AZXBd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752644Ab0AZXBd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jan 2010 18:01:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751916Ab0AZXBc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jan 2010 18:01:32 -0500
Received: from smtp-out.google.com ([216.239.33.17]:41521 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751012Ab0AZXBc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jan 2010 18:01:32 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=LYF17cCRtjzlYRiw10HWlfk2naaoq68eGw4Y4Xe4KBQkP4flnzSp0bDBWKGfaI3An
	m/gxZdWymmuWtEmPzffdw==
MIME-Version: 1.0
In-Reply-To: <4B5EA4EC.8020700@cn.fujitsu.com>
References: <4B5EA4EC.8020700@cn.fujitsu.com>
Date: Tue, 26 Jan 2010 15:01:26 -0800
Message-ID: <6599ad831001261501q2e6e54bckebb3d2d225ecc126@mail.gmail.com>
Subject: Re: [PATCH 1/2] cgroups: Fix to return errno in a failure path
From: Paul Menage <menage@google.com>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       LKML <linux-kernel@vger.kernel.org>,
       "containers@lists.osdl.org" <containers@lists.osdl.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 26, 2010 at 12:16 AM, Li Zefan <lizf@cn.fujitsu.com> wrote:
>
> Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>

Acked-by: Paul Menage <menage@google.com>

> ---
>  cgroup.c |    7 +++++--
>  1 file changed, 5 insertions(+), 2 deletions(-)
>
> --- a/kernel/cgroup.c.orig      2010-01-19 16:37:37.000000000 +0800
> +++ a/kernel/cgroup.c   2010-01-19 16:39:07.000000000 +0800
> @@ -3279,14 +3279,17 @@ static long cgroup_create(struct cgroup
>
>        for_each_subsys(root, ss) {
>                struct cgroup_subsys_state *css = ss->create(ss, cgrp);
> +
>                if (IS_ERR(css)) {
>                        err = PTR_ERR(css);
>                        goto err_destroy;
>                }
>                init_cgroup_css(css, ss, cgrp);
> -               if (ss->use_id)
> -                       if (alloc_css_id(ss, parent, cgrp))
> +               if (ss->use_id) {
> +                       err = alloc_css_id(ss, parent, cgrp);
> +                       if (err)
>                                goto err_destroy;
> +               }
>                /* At error, ->destroy() callback has to free assigned ID. */
>        }
>
>
