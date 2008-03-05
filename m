Return-Path: <linux-kernel-owner+w=401wt.eu-S1754507AbYCEO0f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754507AbYCEO0f (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2008 09:26:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751612AbYCEO01
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Mar 2008 09:26:27 -0500
Received: from e28smtp01.in.ibm.com ([59.145.155.1]:46303 "EHLO
	e28smtp01.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751384AbYCEO00 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2008 09:26:26 -0500
Message-ID: <47CEAD38.3080501@linux.vnet.ibm.com>
Date: Wed, 05 Mar 2008 19:54:56 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Paul Menage <menage@google.com>
CC: Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       lkml <linux-kernel@vger.kernel.org>,
       containers@lists.linux-foundation.org, Balbir Singh <balbir@in.ibm.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       Sudhir Kumar <skumar@linux.vnet.ibm.com>
Subject: Re: [RFC] libcg: design and plans
References: <20080304152341.GB5659@linux.vnet.ibm.com> <6599ad830803042215n6aedb3eeub0c037e6a4e7bb34@mail.gmail.com> <20080305103343.GA22217@linux.vnet.ibm.com> <6599ad830803050241k590e4389ud95b9b3ef920f8b6@mail.gmail.com> <20080305110730.GB22217@linux.vnet.ibm.com> <6599ad830803050351p91bdacahd47059e863f56817@mail.gmail.com>
In-Reply-To: <6599ad830803050351p91bdacahd47059e863f56817@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Menage wrote:
> On Wed, Mar 5, 2008 at 3:07 AM, Dhaval Giani <dhaval@linux.vnet.ibm.com> wrote:
>>  OK. Hmm, I've not really thought about it. At first thought, it should
>>  not be very difficult. Only thing I am not sure is the arbitrary
>>  grouping of the groups (ok, a bit confusing).
> 
> I suspect that the main form of composite grouping is going to be
> between parents and children. E.g. you might want to say things like:
> 
> create_group(A, memory=1G, cpu=100)
> create_group(B, parent=A, memory=inherit, cpu=20)
> create_group(C, parent=A, memory=inherit, cpu=30)
> 
> i.e. both B and C inherit/share their memory limit from their parent,
> but have their own CPU groups (child groups of their parent?)
>

No, we don't plan on doing that. What we plan on doing is

1. Specify the mount point for each controller
2. In the create group API, specify the name of the group and the various
parameters.

If for example CPU is mounted at /cpu and Memory at /mem

Then a specification for creation of group A would be of the form

create_group(A, cpu=100, memory=100M)

Then,

/cpu/A has shares set to 100 and /mem/A has memory.limit set to 100M

If you want to create subgroups under A, you specify

create_group(A/B, memory=200M, cpu=50)

That would create /cpu/A/B and /mem/A/B

Please note that memory and CPU hierarchy needs work in the kernel. The shares
and hierarchy support is pending. We need to make the res_counters
infrastructure aware of hierarchies.



-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
