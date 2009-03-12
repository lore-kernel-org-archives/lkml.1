Return-Path: <linux-kernel-owner+w=401wt.eu-S1756043AbZCLCle@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756043AbZCLCle (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Mar 2009 22:41:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755930AbZCLClO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Mar 2009 22:41:14 -0400
Received: from smtp-out.google.com ([216.239.45.13]:50155 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755960AbZCLClM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Mar 2009 22:41:12 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=EUmRJaE8SU/X2xlXhn8m9YjFPZ9sg2JoMqeUR/7uWlu1JSZe9XmzzzyZb2WH/CdlB
	Sr+LfHZo2noQe8T95hchQ==
MIME-Version: 1.0
In-Reply-To: <49B869B2.1020303@cn.fujitsu.com>
References: <49B869B2.1020303@cn.fujitsu.com>
Date: Wed, 11 Mar 2009 19:41:06 -0700
Message-ID: <6599ad830903111941n5f244bb1n6d4df9268fe18fcb@mail.gmail.com>
Subject: Re: [PATCH] cls_cgroup: remove unneeded cgroup_lock
From: Paul Menage <menage@google.com>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: David Miller <davem@davemloft.net>, Thomas Graf <tgraf@suug.ch>,
       LKML <linux-kernel@vger.kernel.org>,
       Linux Containers <containers@lists.linux-foundation.org>,
       netdev@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 11, 2009 at 6:47 PM, Li Zefan <lizf@cn.fujitsu.com> wrote:
> We can remove this lock here, since we are in cgroup write handler
> and thus the cgrp is guaranteed to be valid, and no lock is needed
> when writing a u32 variable.

There's no guarantee that the group isn't dead, so we could be writing
into a value that's never going to be used again, but I guess that's
not really a big deal.

Acked-by: Paul Menage <menage@google.com>

>
> Signed-off-by: Li Zefan <lizf@cn.fujitsuc.com>
> ---
>  net/sched/cls_cgroup.c |    6 ------
>  1 files changed, 0 insertions(+), 6 deletions(-)
>
> diff --git a/net/sched/cls_cgroup.c b/net/sched/cls_cgroup.c
> index 91a3db4..1ab4542 100644
> --- a/net/sched/cls_cgroup.c
> +++ b/net/sched/cls_cgroup.c
> @@ -62,13 +62,7 @@ static u64 read_classid(struct cgroup *cgrp, struct cftype *cft)
>
>  static int write_classid(struct cgroup *cgrp, struct cftype *cft, u64 value)
>  {
> -       if (!cgroup_lock_live_group(cgrp))
> -               return -ENODEV;
> -
>        cgrp_cls_state(cgrp)->classid = (u32) value;
> -
> -       cgroup_unlock();
> -
>        return 0;
>  }
>
> --
> 1.5.4.rc3
>
>
