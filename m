Return-Path: <linux-kernel-owner+w=401wt.eu-S1755791AbZFDVcx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755791AbZFDVcx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jun 2009 17:32:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754647AbZFDVcn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Jun 2009 17:32:43 -0400
Received: from smtp-out.google.com ([216.239.33.17]:3445 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754549AbZFDVcm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jun 2009 17:32:42 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=message-id:date:from:user-agent:mime-version:to:cc:subject:
	references:in-reply-to:content-type:
	content-transfer-encoding:x-system-of-record;
	b=AvZexRpscbnPXxLG9yDW33pTQ4ITQtjnBVNuSorf4T/dq7dPjQxq3ZlviBDQHzm0Y
	5WEbAe+vCiiM1C3r3M+RQ==
Message-ID: <4A283D72.6070603@google.com>
Date: Thu, 04 Jun 2009 14:32:34 -0700
From: Mike Waychison <mikew@google.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090318)
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: bharata@linux.vnet.ibm.com, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Pavel Emelyanov <xemul@openvz.org>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>, kvm@vger.kernel.org,
       Gautham R Shenoy <ego@in.ibm.com>,
       Linux Containers <containers@lists.linux-foundation.org>,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Balbir Singh <balbir@linux.vnet.ibm.com>
Subject: Re: [RFC] CPU hard limits
References: <20090604053649.GA3701@in.ibm.com> <4A27BBCA.5020606@redhat.com>
In-Reply-To: <4A27BBCA.5020606@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Avi Kivity wrote:
> Bharata B Rao wrote:
>> 2. Need for hard limiting CPU resource
>> --------------------------------------
>> - Pay-per-use: In enterprise systems that cater to multiple clients/customers
>>   where a customer demands a certain share of CPU resources and pays only
>>   that, CPU hard limits will be useful to hard limit the customer's job
>>   to consume only the specified amount of CPU resource.
>> - In container based virtualization environments running multiple containers,
>>   hard limits will be useful to ensure a container doesn't exceed its
>>   CPU entitlement.
>> - Hard limits can be used to provide guarantees.
>>   
> How can hard limits provide guarantees?

Hard limits are useful and desirable in situations where we would like 
to maintain deterministic behavior.

Placing a hard cap on the cpu usage of a given task group (and 
configuring such that this cpu time is not overcommited) on a system 
allows us to create a hard guarantee that throughput for that task group 
will not fluctuate as other workloads are added and removed on the system.

Cache use and bus bandwidth in a multi-workload environment can still 
cause a performance deviation, but these are second order compared to 
the cpu scheduling guarantees themselves.

Mike Waychison
