Return-Path: <linux-kernel-owner+w=401wt.eu-S1754590AbZFDMVa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754590AbZFDMVa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jun 2009 08:21:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753489AbZFDMVW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Jun 2009 08:21:22 -0400
Received: from mx2.redhat.com ([66.187.237.31]:50293 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753279AbZFDMVV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jun 2009 08:21:21 -0400
Message-ID: <4A27BBCA.5020606@redhat.com>
Date: Thu, 04 Jun 2009 15:19:22 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: bharata@linux.vnet.ibm.com
CC: linux-kernel@vger.kernel.org, Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
       Gautham R Shenoy <ego@in.ibm.com>,
       Srivatsa Vaddagiri <vatsa@in.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Pavel Emelyanov <xemul@openvz.org>, kvm@vger.kernel.org,
       Linux Containers <containers@lists.linux-foundation.org>,
       Herbert Poetzl <herbert@13thfloor.at>
Subject: Re: [RFC] CPU hard limits
References: <20090604053649.GA3701@in.ibm.com>
In-Reply-To: <20090604053649.GA3701@in.ibm.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bharata B Rao wrote:
> 2. Need for hard limiting CPU resource
> --------------------------------------
> - Pay-per-use: In enterprise systems that cater to multiple clients/customers
>   where a customer demands a certain share of CPU resources and pays only
>   that, CPU hard limits will be useful to hard limit the customer's job
>   to consume only the specified amount of CPU resource.
> - In container based virtualization environments running multiple containers,
>   hard limits will be useful to ensure a container doesn't exceed its
>   CPU entitlement.
> - Hard limits can be used to provide guarantees.
>   
How can hard limits provide guarantees?

Let's take an example where I have 1 group that I wish to guarantee a 
20% share of the cpu, and anther 8 groups with no limits or guarantees.

One way to achieve the guarantee is to hard limit each of the 8 other 
groups to 10%; the sum total of the limits is 80%, leaving 20% for the 
guarantee group. The downside is the arbitrary limit imposed on the 
other groups.

Another way is to place the 8 groups in a container group, and limit 
that to 80%. But that doesn't work if I want to provide guarantees to 
several groups.

-- 
error compiling committee.c: too many arguments to function

