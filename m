Return-Path: <linux-kernel-owner+w=401wt.eu-S933954AbYAaVNt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933954AbYAaVNt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2008 16:13:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762264AbYAaVNi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jan 2008 16:13:38 -0500
Received: from nf-out-0910.google.com ([64.233.182.184]:6773 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751592AbYAaVNh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2008 16:13:37 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:reply-to:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=ZsSCL/sl6GMPSUb4mhnLwz2ycGDgfqXG+Xo3wB3FxJscwYwe5Xs6zchkD+DfA0EpfUisbS8Igcgj/1JxmxuJx5k7Y92eS6u/Gb1Bd+9kK6Q9vL5B6xuD0iDR+myN435Iz55L9xxaottg+w+gOEvCsuG2l+E4QH0imGH63rCXzEk=
Date: Thu, 31 Jan 2008 16:13:29 -0500
From: Vivek Goyal <vivek.goyal2008@gmail.com>
To: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
       Ingo Molnar <mingo@elte.hu>, menage@google.com,
       containers@lists.osdl.org, dhaval@linux.vnet.ibm.com,
       Balbir Singh <balbir@in.ibm.com>, pj@sgi.com
Subject: Re: [RFC] Default child of a cgroup
Message-ID: <20080131211328.GA9521@dhcp83-78.boston.redhat.com>
Reply-To: vivek.goyal2008@gmail.com
References: <20080131024049.GA9544@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080131024049.GA9544@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 31, 2008 at 08:10:49AM +0530, Srivatsa Vaddagiri wrote:
> Hi,
> 	As we were implementing multiple-hierarchy support for CPU
> controller, we hit some oddities in its implementation, partly related
> to current cgroups implementation. Peter and I have been debating on the 
> exact solution and I thought of bringing that discussion to lkml.
> 
> Consider the cgroup filesystem structure for managing cpu resource.
> 
> 	# mount -t cgroup -ocpu,cpuacct none /cgroup
> 	# mkdir /cgroup/A
> 	# mkdir /cgroup/B
> 	# mkdir /cgroup/A/a1
> 
> will result in:
> 
> 	/cgroup
> 	   |------<tasks>
> 	   |------<cpuacct.usage>
>  	   |------<cpu.shares>
> 	   |
> 	   |----[A]
> 	   |     |----<tasks>
> 	   |     |----<cpuacct.usage>
> 	   |     |----<cpu.shares>
> 	   |     |
> 	   |     |---[a1]
> 	   |           |----<tasks>
> 	   |   	       |----<cpuacct.usage>
> 	   |           |----<cpu.shares>
> 	   |           |
> 	   |
> 	   |----[B]
> 	   |     |----<tasks>
> 	   |     |----<cpuacct.usage>
> 	   |     |----<cpu.shares>
> 	   |     
> 
> 
> Here are some questions that arise in this picture:
> 
> 1. What is the relationship of the task-group in A/tasks with the
>    task-group in A/a1/tasks? In otherwords do they form siblings
>    of the same parent A?
> 

Vatsa,

I don't know much about cgroups but got a query. How do we handle this if we
just go one level up? How do we define relationship between /cgroup/tasks and
/cgroup/A/tasks, or /cgroup/tasks and /cgroup/B/tasks?

To me lower levels should be handeled in the same way.

Thanks
Vivek
