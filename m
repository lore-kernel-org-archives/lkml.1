Return-Path: <linux-kernel-owner+w=401wt.eu-S1763990AbYBTC6P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763990AbYBTC6P (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 21:58:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757656AbYBTC57
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 21:57:59 -0500
Received: from smtp-out.google.com ([216.239.45.13]:28395 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757473AbYBTC56 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 21:57:58 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=orKfov/pHFvLD7cnm7DR1sVQorl/Cimpb5MQLD1Z3PFpjS2GhqanP4SBXHC8geSke
	GtMe7mMO+Wy1w1BALTLfA==
Message-ID: <6599ad830802191857w13387324ja5d8327d1ff2343d@mail.gmail.com>
Date: Tue, 19 Feb 2008 18:57:54 -0800
From: "Paul Menage" <menage@google.com>
To: "Li Zefan" <lizf@cn.fujitsu.com>
Subject: Re: [PATCH 5/7] cgroup: fix subsys bitops
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       "KAMEZAWA Hiroyuki" <kamezawa.hiroyu@jp.fujitsu.com>,
       LKML <linux-kernel@vger.kernel.org>,
       containers@lists.linux-foundation.org
In-Reply-To: <47B91C82.7010407@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <47B91C82.7010407@cn.fujitsu.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Feb 17, 2008 9:49 PM, Li Zefan <lizf@cn.fujitsu.com> wrote:
> Cgroup uses unsigned long for subsys bitops, not unsigned long long.
>
> Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>

Acked-by: Paul Menage <menage@google.com>

> ---
>  kernel/cgroup.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/kernel/cgroup.c b/kernel/cgroup.c
> index aa76bbd..e8c8e58 100644
> --- a/kernel/cgroup.c
> +++ b/kernel/cgroup.c
> @@ -320,7 +320,7 @@ static struct css_set *find_existing_css_set(
>         /* Built the set of subsystem state objects that we want to
>          * see in the new css_set */
>         for (i = 0; i < CGROUP_SUBSYS_COUNT; i++) {
> -               if (root->subsys_bits & (1ull << i)) {
> +               if (root->subsys_bits & (1UL << i)) {
>                         /* Subsystem is in this hierarchy. So we want
>                          * the subsystem state from the new
>                          * cgroup */
> @@ -696,7 +696,7 @@ static int rebind_subsystems(struct cgroupfs_root *root,
>         added_bits = final_bits & ~root->actual_subsys_bits;
>         /* Check that any added subsystems are currently free */
>         for (i = 0; i < CGROUP_SUBSYS_COUNT; i++) {
> -               unsigned long long bit = 1ull << i;
> +               unsigned long bit = 1UL << i;
>                 struct cgroup_subsys *ss = subsys[i];
>                 if (!(bit & added_bits))
>                         continue;
> --
> 1.5.4.rc3
>
>
