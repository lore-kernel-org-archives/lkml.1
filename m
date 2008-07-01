Return-Path: <linux-kernel-owner+w=401wt.eu-S1755088AbYGAKvy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755088AbYGAKvy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2008 06:51:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752627AbYGAKvn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jul 2008 06:51:43 -0400
Received: from E23SMTP03.au.ibm.com ([202.81.18.172]:38563 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754139AbYGAKvm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2008 06:51:42 -0400
Date: Tue, 1 Jul 2008 16:21:26 +0530
From: Dhaval Giani <dhaval@linux.vnet.ibm.com>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Paul Menage <menage@google.com>, Andrew Morton <akpm@linux-foundation.org>,
       Balbir Singh <balbir@in.ibm.com>,
       Sudhir Kumar <skumar@linux.vnet.ibm.com>,
       lkml <linux-kernel@vger.kernel.org>, containers@lists.osdl.org,
       Paul Jackson <pj@sgi.com>
Subject: Re: Attaching PID 0 to a cgroup
Message-ID: <20080701105126.GA10403@linux.vnet.ibm.com>
Reply-To: Dhaval Giani <dhaval@linux.vnet.ibm.com>
References: <20080701094545.GD3925@linux.vnet.ibm.com> <20080701094734.GE3925@linux.vnet.ibm.com> <486A06B7.7020906@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <486A06B7.7020906@cn.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 01, 2008 at 06:28:07PM +0800, Li Zefan wrote:
> CC: Paul Jackson <pj@sgi.com>
> 
> Dhaval Giani wrote:
> > [put in the wrong alias for containers list correcting it.]
> > 
> > On Tue, Jul 01, 2008 at 03:15:45PM +0530, Dhaval Giani wrote:
> >> Hi Paul,
> >>
> >> Attaching PID 0 to a cgroup caused the current task to be attached to
> >> the cgroup. Looking at the code,
> >>
> 
> [...]
> 
> >>
> >> I was wondering, why this was done. It seems to be unexpected behavior.
> >> Wouldn't something like the following be a better response? (I've used
> >> EINVAL, but I can change it to ESRCH if that is better.)
> >>
> 
> Why is it unexpected? it follows the behavior of cpuset, so this patch will
> break backward compatibility of cpuset.

Ah, I was not aware of that. Thanks!

> 
> But it's better to document this.
> 

Yes please.

> -----------------------------------------
> 
> Document the following cgroup usage:
>  # echo 0 > /dev/cgroup/tasks
> 
> Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>

Acked-by: Dhaval Giani <dhaval@linux.vnet.ibm.com>

> ---
>  cgroups.txt |    4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/Documentation/cgroups.txt b/Documentation/cgroups.txt
> index 824fc02..213f533 100644
> --- a/Documentation/cgroups.txt
> +++ b/Documentation/cgroups.txt
> @@ -390,6 +390,10 @@ If you have several tasks to attach, you have to do it one after another:
>  	...
>  # /bin/echo PIDn > tasks
> 
> +You can attach the current task by echoing 0:
> +
> +# /bin/echo 0 > tasks
> +
>  3. Kernel API
>  =============
> 
> 

-- 
regards,
Dhaval
