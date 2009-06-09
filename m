Return-Path: <linux-kernel-owner+w=401wt.eu-S1759239AbZFIIZ1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759239AbZFIIZ1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jun 2009 04:25:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756543AbZFIIZO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Jun 2009 04:25:14 -0400
Received: from mx2.redhat.com ([66.187.237.31]:54507 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755499AbZFIIZN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jun 2009 04:25:13 -0400
Message-ID: <4A2E1C67.4040301@redhat.com>
Date: Tue, 09 Jun 2009 11:25:11 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Kallol Biswas <nucleodyne@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: looking for ideas on VM related research projects
References: <438397970906072249pe76fafdj49626f20eea31eab@mail.gmail.com>	 <4A2CAC32.5030904@redhat.com> <438397970906090114m7ebc6e6fub0c6085f462d2e1a@mail.gmail.com>
In-Reply-To: <438397970906090114m7ebc6e6fub0c6085f462d2e1a@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kallol Biswas wrote:
> Hi,
>     I am from IO and driver background, and not up to date with
> current VM developments in linux.
>
> Are you talking about NUMA architecture? 

Yes.

> Could you clarify or point me
> to document that describes the problem with VMA/task affinity?

Linux will try to allocate memory on the same node that the allocating 
thread ran on on the time the page was faulted in.  However, for long 
running processes, the thread will eventually migrate to some other cpu 
with only 1/N chance of actually running on the same node (N being the 
number of nodes).

If we can specify that a thread is related to some vma, the scheduler 
can try to keep that thread running on the vma's node, or else it can 
migrate the vma to a node with available cpu power.

>  Where do affinity issues arise?
>   

Large, long-running processes.  My specific interest is virtualization 
with kvm, but I believe HPC and databases can make use of this as well.  
HPC currently solves the problem by statically allocating memory and cpu 
resources.

-- 
error compiling committee.c: too many arguments to function

