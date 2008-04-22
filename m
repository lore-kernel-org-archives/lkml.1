Return-Path: <linux-kernel-owner+w=401wt.eu-S1756545AbYDVQRN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756545AbYDVQRN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2008 12:17:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753231AbYDVQQ6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Apr 2008 12:16:58 -0400
Received: from gv-out-0910.google.com ([216.239.58.190]:56521 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753178AbYDVQQ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2008 12:16:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=VpBcQlqp5Sr+CFJeDt4BSebs+4F/7hCSUxK1Gu06ZM4s8lpojqh0BKolt853FgVIb+SnlqOyfFG2pZLZfw5NllE+Qenc9Gc433RSVT91vaUHYtOdlL3q+iWld5iRHkK8BJkO9LiICGlWmwFxJS0L2kekv3s5A4UzjIbIKbgDQG4=
Message-ID: <12c511ca0804220916i5c181202pecf8fee7153e54fc@mail.gmail.com>
Date: Tue, 22 Apr 2008 09:16:49 -0700
From: "Tony Luck" <tony.luck@intel.com>
To: "Mike Travis" <travis@sgi.com>
Subject: Re: [PATCH 04/12] sched: Remove fixed NR_CPUS sized arrays in kernel_sched_c v2
Cc: "Ingo Molnar" <mingo@elte.hu>, "Thomas Gleixner" <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
In-Reply-To: <20080405011101.534396000@polaris-admin.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080405011100.720014000@polaris-admin.engr.sgi.com>
	 <20080405011101.534396000@polaris-admin.engr.sgi.com>
X-Google-Sender-Auth: 6e56d56c0de24fc2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 4, 2008 at 6:11 PM, Mike Travis <travis@sgi.com> wrote:
>  @@ -7297,6 +7287,11 @@ void __init sched_init_smp(void)
>   #else
>   void __init sched_init_smp(void)
>   {
>  +#if defined(CONFIG_NUMA)
>  +       sched_group_nodes_bycpu = kzalloc(nr_cpu_ids * sizeof(void **),
>  +                                                               GFP_KERNEL);
>  +       BUG_ON(sched_group_nodes_bycpu == NULL);
>  +#endif
>         sched_init_granularity();
>   }
>   #endif /* CONFIG_SMP */

This hunk is causing problems with one of my builds (generic,
uniprocessor). Note
that the #else at the start of this hunk is from a #ifdef CONFIG_SMP ... so I'm
wondering why we need #if defined(CONFIG_NUMA) inside uniprocessor code :-)
How can you have NUMA issues with only one cpu!!!

[I'm also wondering why the config that has the compile problem has CONFIG_SMP=n
and CONFIG_NUMA=y ... but that weirdness exposed this silliness, so
perhaps it isn't
all bad]

Error message is:
kernel/sched.c: In function `sched_init_smp':
kernel/sched.c:7994: error: `sched_group_nodes_bycpu' undeclared
(first use in this function)
kernel/sched.c:7994: error: (Each undeclared identifier is reported only once
kernel/sched.c:7994: error: for each function it appears in.)

-Tony
