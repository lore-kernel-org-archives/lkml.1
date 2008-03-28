Return-Path: <linux-kernel-owner+w=401wt.eu-S1754305AbYC1JCG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754305AbYC1JCG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2008 05:02:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752330AbYC1JBz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Mar 2008 05:01:55 -0400
Received: from py-out-1112.google.com ([64.233.166.179]:40676 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752294AbYC1JBy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2008 05:01:54 -0400
Message-ID: <36ca99e90803280201i708ce9b7y293a2c68e733f088@mail.gmail.com>
Date: Fri, 28 Mar 2008 10:01:53 +0100
From: "Bert Wesarg" <bert.wesarg@googlemail.com>
To: "Mike Travis" <travis@sgi.com>
Subject: Re: [PATCH 2/2] x86: modify show_shared_cpu_map in intel_cacheinfo
Cc: "Ingo Molnar" <mingo@elte.hu>, linux-kernel@vger.kernel.org
In-Reply-To: <20080327231654.599276000@polaris-admin.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080327231654.284673000@polaris-admin.engr.sgi.com>
	 <20080327231654.599276000@polaris-admin.engr.sgi.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 28, 2008 at 12:16 AM, Mike Travis <travis@sgi.com> wrote:
> Used cpulist_scnprintf to print cpus on a leaf instead of requiring
>  a new "cpumask_scnprintf_len" function to determine the size of
>  the temporary buffer.  cpulist_scnprintf can be used to print directly
>  to the output buffer, eliminating the need for the temporary buffer.
>
>  Based on:
>         git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6.git
>         git://git.kernel.org/pub/scm/linux/kernel/git/x86/linux-2.6-x86.git
>
>  Signed-off-by: Mike Travis <travis@sgi.com>
>  ---
>   arch/x86/kernel/cpu/intel_cacheinfo.c |   25 +++++++++++++++++--------
>   1 file changed, 17 insertions(+), 8 deletions(-)
>
>  --- linux.trees.git.orig/arch/x86/kernel/cpu/intel_cacheinfo.c
>  +++ linux.trees.git/arch/x86/kernel/cpu/intel_cacheinfo.c
>  @@ -593,14 +593,23 @@ static ssize_t show_size(struct _cpuid4_
>
>   static ssize_t show_shared_cpu_map(struct _cpuid4_info *this_leaf, char *buf)
>   {
>  -       int n = 0;
>  -       int len = cpumask_scnprintf_len(nr_cpu_ids);
>  -       char *mask_str = kmalloc(len, GFP_KERNEL);
>  -
>  -       if (mask_str) {
>  -               cpumask_scnprintf(mask_str, len, this_leaf->shared_cpu_map);
>  -               n = sprintf(buf, "%s\n", mask_str);
>  -               kfree(mask_str);
>  +       /*
>  +        * cpulist_scnprintf() has the advantage of compressing
>  +        * consecutive cpu numbers into a single range which seems
>  +        * appropriate for cpus on a leaf.  This will change what is
>  +        * output so scripts that process the output will have to change.
So this breaks user space?

Bert
