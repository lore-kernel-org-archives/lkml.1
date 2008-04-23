Return-Path: <linux-kernel-owner+w=401wt.eu-S1752533AbYDWGsv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752533AbYDWGsv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2008 02:48:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750873AbYDWGsm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Apr 2008 02:48:42 -0400
Received: from smtp-out.google.com ([216.239.33.17]:57934 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750747AbYDWGsl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2008 02:48:41 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=LPFJ5xLBHP3vM2q4gvT0s+P0/MJYWGL9M9adC60mmfaoTB3jEG5Fgh29G5qo+ZYyH
	csLqQ0YXM+LJrqchTkKUQ==
Message-ID: <6599ad830804222348u2b3b6e8coc753fd798c750e26@mail.gmail.com>
Date: Tue, 22 Apr 2008 23:48:28 -0700
From: "Paul Menage" <menage@google.com>
To: "Li Zefan" <lizf@cn.fujitsu.com>
Subject: Re: [PATCH] cgroup: use read lock to guard find_existing_css_set()
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "Linux Containers" <containers@lists.linux-foundation.org>
In-Reply-To: <480EA744.2050300@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <480EA744.2050300@cn.fujitsu.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 22, 2008 at 8:04 PM, Li Zefan <lizf@cn.fujitsu.com> wrote:
> The function does not modify anything (except the temporary
>  css template), so it's sufficient to hold read lock.
>
>  Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>

Acked-by: Paul Menage <menage@google.com>

Thanks.

>  ---
>   kernel/cgroup.c |    4 ++--
>   1 files changed, 2 insertions(+), 2 deletions(-)
>
>  diff --git a/kernel/cgroup.c b/kernel/cgroup.c
>  index 2727f92..e9eb5da 100644
>  --- a/kernel/cgroup.c
>  +++ b/kernel/cgroup.c
>  @@ -406,11 +406,11 @@ static struct css_set *find_css_set(
>
>         /* First see if we already have a cgroup group that matches
>          * the desired set */
>  -       write_lock(&css_set_lock);
>  +       read_lock(&css_set_lock);
>         res = find_existing_css_set(oldcg, cgrp, template);
>         if (res)
>                 get_css_set(res);
>  -       write_unlock(&css_set_lock);
>  +       read_unlock(&css_set_lock);
>
>         if (res)
>                 return res;
>  -- 1.5.4.rc3
>
>
