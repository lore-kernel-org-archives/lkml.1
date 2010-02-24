Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757233Ab0BXQEQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Feb 2010 11:04:16 -0500
Received: from smtp-out.google.com ([216.239.33.17]:8434 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757171Ab0BXQEO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Feb 2010 11:04:14 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=dKs3yPLDzy/yOIFZOxXMrOs5ah6FOa8dYIv6Yho8b+SDRnfTKNg6Wxsa3RR5qJ11s
	HfQGDTHAIAsjuU8+U+zVA==
MIME-Version: 1.0
In-Reply-To: <1267018268-16254-1-git-send-email-kirill@shutemov.name>
References: <1267018268-16254-1-git-send-email-kirill@shutemov.name>
Date: Wed, 24 Feb 2010 08:04:08 -0800
Message-ID: <6599ad831002240804m66adc27fy253e2b10d9867465@mail.gmail.com>
Subject: Re: [PATCH -mmotm] cgroup: fix typo in error handling in 
	cgroup_write_event_control()
From: Paul Menage <menage@google.com>
To: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: containers@lists.linux-foundation.org, Li Zefan <lizf@cn.fujitsu.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 24, 2010 at 5:31 AM, Kirill A. Shutemov
<kirill@shutemov.name> wrote:
> Actually, we want to fput() cfile, if cfile is not NULL.
>
> Signed-off-by: Kirill A. Shutemov <kirill@shutemov.name>

Thanks.

Acked-by: Paul Menage <menage@google.com>

> ---
>  kernel/cgroup.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/kernel/cgroup.c b/kernel/cgroup.c
> index d142524..049ce0d 100644
> --- a/kernel/cgroup.c
> +++ b/kernel/cgroup.c
> @@ -3117,7 +3117,7 @@ static int cgroup_write_event_control(struct cgroup *cgrp, struct cftype *cft,
>        return 0;
>
>  fail:
> -       if (!cfile)
> +       if (cfile)
>                fput(cfile);
>
>        if (event && event->eventfd && !IS_ERR(event->eventfd))
> --
> 1.6.6.2
>
>
