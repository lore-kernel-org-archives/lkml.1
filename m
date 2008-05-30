Return-Path: <linux-kernel-owner+w=401wt.eu-S1753541AbYE3WWU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753541AbYE3WWU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2008 18:22:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752190AbYE3WWM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 May 2008 18:22:12 -0400
Received: from e28smtp07.in.ibm.com ([59.145.155.7]:39792 "EHLO
	e28esmtp07.in.ibm.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751480AbYE3WWL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2008 18:22:11 -0400
Message-ID: <48407DC3.8060001@linux.vnet.ibm.com>
Date: Sat, 31 May 2008 03:50:51 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
CC: "linux-mm@kvack.org" <linux-mm@kvack.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "xemul@openvz.org" <xemul@openvz.org>,
       "menage@google.com" <menage@google.com>,
       "yamamoto@valinux.co.jp" <yamamoto@valinux.co.jp>,
       "lizf@cn.fujitsu.com" <lizf@cn.fujitsu.com>
Subject: Re: [RFC][PATCH 1/2] memcg: res_counter hierarchy
References: <20080530104312.4b20cc60.kamezawa.hiroyu@jp.fujitsu.com> <20080530104515.9afefdbb.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20080530104515.9afefdbb.kamezawa.hiroyu@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

KAMEZAWA Hiroyuki wrote:
> This patch tries to implements _simple_ 'hierarchy policy' in res_counter.
> 
> While several policy of hierarchy can be considered, this patch implements
> simple one 
>    - the parent includes, over-commits the child
>    - there are no shared resource

I am not sure if this is desirable. The concept of a hierarchy applies really
well when there are shared resources.

>    - dynamic hierarchy resource usage management in the kernel is not necessary
> 

Could you please elaborate as to why? I am not sure I understand your point

> works as following.
> 
>  1. create a child. set default child limits to be 0.
>  2. set limit to child.
>     2-a. before setting limit to child, prepare enough room in parent.
>     2-b. increase 'usage' of parent by child's limit.

The problem with this is that you are forcing the parent will run into a reclaim
loop even if the child is not using the assigned limit to it.

>  3. the child sets its limit to the val moved from the parent.
>     the parent remembers what amount of resource is to the children.
> 

All of this needs to be dynamic

>  Above means that
> 	- a directory's usage implies the sum of all sub directories +
>           own usage.
> 	- there are no shared resource between parent <-> child.
> 
>  Pros.
>   - simple and easy policy.
>   - no hierarchy overhead.
>   - no resource share among child <-> parent. very suitable for multilevel
>     resource isolation.

Sharing is an important aspect of hierachies. I am not convinced of this
approach. Did you look at the patches I sent out? Was there something
fundamentally broken in them?

[snip]

-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
