Return-Path: <linux-kernel-owner+w=401wt.eu-S1756665AbYLaL42@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756665AbYLaL42 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Dec 2008 06:56:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755450AbYLaL4U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Dec 2008 06:56:20 -0500
Received: from relay3.sgi.com ([192.48.171.31]:55100 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755172AbYLaL4T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Dec 2008 06:56:19 -0500
Message-ID: <495B5DE1.2000406@sgi.com>
Date: Wed, 31 Dec 2008 03:56:17 -0800
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Li Zefan <lizf@cn.fujitsu.com>
CC: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Rusty Russell <rusty@rustcorp.com.au>, Paul Menage <menage@google.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/6] cpuset: convert to new cpumask API
References: <495B2EA6.7010808@cn.fujitsu.com>
In-Reply-To: <495B2EA6.7010808@cn.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Li Zefan wrote:
> This patchset converts cpuset to use new cpumask API, and thus
> remove on stack cpumask_t to reduce stack usage.
> 
> Before:
>  # cat kernel/cpuset.c include/linux/cpuset.h | grep -c cpumask_t
>  21
> After:
>  # cat kernel/cpuset.c include/linux/cpuset.h | grep -c cpumask_t
>  0
> 
> The patchset is based on mmotm 2008-12-30-16-05.
> 
> [PATCH 1/6] cpuset: remove on stack cpumask_t in cpuset_sprintf_cpulist()
> [PATCH 2/6] cpuset: remove on stack cpumask_t in cpuset_can_attach()
> [PATCH 3/6] cpuset: convert cpuset_attach() to use cpumask_var_t
> [PATCH 4/6] cpuset: don't allocate trial cpuset on stack
> [PATCH 5/6] cpuset: convert cpuset->cpus_allowed to cpumask_var_t
> [PATCH 6/6] cpuset: remove remaining pointers to cpumask_t
> ---
>  include/linux/cpuset.h   |   10 +
>  kernel/cpuset.c          |  279 ++++++++++++++++++++++++++++-------------------
>  3 files changed, 174 insertions(+), 115 deletions(-)
> 


These all look good Li!  Thanks for doing this.  You can add my:

Acked-by: Mike Travis <travis@sgi.com>
