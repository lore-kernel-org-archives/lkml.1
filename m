Return-Path: <linux-kernel-owner+w=401wt.eu-S1760828AbYGAVsr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760828AbYGAVsr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2008 17:48:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756086AbYGAVsi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jul 2008 17:48:38 -0400
Received: from gv-out-0910.google.com ([216.239.58.188]:5292 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751862AbYGAVsh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2008 17:48:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:reply-to:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=VuU1I8mpce8V9fCa1sgqJo03vesZ9UV3FOVnOL3u6I0v7eTIGY+wDzD1InrX+ICNa5
         3EFxReO+D9wL1+wqtbnx5xCp8izrjl1HRjmXg0HDZhL1cno7Fd72aWB5DrB2CU1En/h0
         l4KaE89lt0QGj0g73ZU7p5ns0vd79ok+4gGrA=
Message-ID: <486AA62F.40503@gmail.com>
Date: Tue, 01 Jul 2008 23:48:31 +0200
From: Andrea Righi <righi.andrea@gmail.com>
Reply-To: righi.andrea@gmail.com
User-Agent: Swiftdove 2.0.0.14 (X11/20080505)
MIME-Version: 1.0
To: Li Zefan <lizf@cn.fujitsu.com>
CC: Dhaval Giani <dhaval@linux.vnet.ibm.com>, Paul Menage <menage@google.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Balbir Singh <balbir@in.ibm.com>,
       Sudhir Kumar <skumar@linux.vnet.ibm.com>,
       lkml <linux-kernel@vger.kernel.org>, containers@lists.osdl.org,
       Paul Jackson <pj@sgi.com>
Subject: Re: Attaching PID 0 to a cgroup
References: <20080701094545.GD3925@linux.vnet.ibm.com> <20080701094734.GE3925@linux.vnet.ibm.com> <486A06B7.7020906@cn.fujitsu.com>
In-Reply-To: <486A06B7.7020906@cn.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Li Zefan wrote:
> CC: Paul Jackson <pj@sgi.com>
> 
> Dhaval Giani wrote:
>> [put in the wrong alias for containers list correcting it.]
>>
>> On Tue, Jul 01, 2008 at 03:15:45PM +0530, Dhaval Giani wrote:
>>> Hi Paul,
>>>
>>> Attaching PID 0 to a cgroup caused the current task to be attached to
>>> the cgroup. Looking at the code,
>>>
> 
> [...]
> 
>>> I was wondering, why this was done. It seems to be unexpected behavior.
>>> Wouldn't something like the following be a better response? (I've used
>>> EINVAL, but I can change it to ESRCH if that is better.)
>>>
> 
> Why is it unexpected? it follows the behavior of cpuset, so this patch will
> break backward compatibility of cpuset.
> 
> But it's better to document this.
> 
> -----------------------------------------
> 
> Document the following cgroup usage:
>  # echo 0 > /dev/cgroup/tasks
> 
> Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
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

Wouldn't be more meaningful to specify the bash's builtin echo here
even if it doesn't opportunely handle write() errors?

Using /bin/echo would attach /bin/echo itself to the cgroup, that just
exists, so it seems like a kind of noop, isn't it?

-Andrea
