Return-Path: <linux-kernel-owner+w=401wt.eu-S1756805AbYJWPtr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756805AbYJWPtr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2008 11:49:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752563AbYJWPtf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Oct 2008 11:49:35 -0400
Received: from smtp-out.google.com ([216.239.33.17]:54634 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751704AbYJWPte (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2008 11:49:34 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=X2wTgfKYpKXjOhfVivTT20bkHg2XC3Q5yvXRqtYfWCOZxcjBC4634o4I5N8EglWK1
	I7jRKVLuWP25Oy3podNpQ==
Message-ID: <6599ad830810230849x71961a0asd7f00d3baa2f2271@mail.gmail.com>
Date: Thu, 23 Oct 2008 08:49:19 -0700
From: "Paul Menage" <menage@google.com>
To: bharata@linux.vnet.ibm.com
Subject: Re: [PATCH] Add hierarchical accounting to cpu accounting controller
Cc: linux-kernel@vger.kernel.org,
       "Srivatsa Vaddagiri" <vatsa@linux.vnet.ibm.com>,
       "Peter Zijlstra" <a.p.zijlstra@chello.nl>,
       "Ingo Molnar" <mingo@elte.hu>
In-Reply-To: <20081023054335.GC3280@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20081023054335.GC3280@in.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 22, 2008 at 10:43 PM, Bharata B Rao
<bharata@linux.vnet.ibm.com> wrote:
> ---
>  kernel/sched.c |   30 ++++++++++++++++++++++++------
>  1 file changed, 24 insertions(+), 6 deletions(-)
>
> --- a/kernel/sched.c
> +++ b/kernel/sched.c
> @@ -9131,10 +9131,15 @@ struct cpuacct {
>        struct cgroup_subsys_state css;
>        /* cpuusage holds pointer to a u64-type object on every cpu */
>        u64 *cpuusage;
> +       struct cpuacct *parent;
>  };
>
> +static struct cpuacct init_cpuacct_group;

Why are you making the root state static?

>  struct cgroup_subsys cpuacct_subsys;
>
> +#define for_each_cpuacct_group(ca) \
> +               for (; ca; ca = ca->parent)
> +

This is only used once, so doesn't seem worth creating a new macro for.

>
> +       if (cgrp->parent) {
> +               ca->css.cgroup = cgrp;

The cgroup pointer in the css is maintained by cgroups - you don't
need to set it.

Paul
