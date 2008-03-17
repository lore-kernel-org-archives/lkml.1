Return-Path: <linux-kernel-owner+w=401wt.eu-S1755977AbYCQDNt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755977AbYCQDNt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Mar 2008 23:13:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752169AbYCQDNm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Mar 2008 23:13:42 -0400
Received: from E23SMTP03.au.ibm.com ([202.81.18.172]:58219 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751325AbYCQDNl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Mar 2008 23:13:41 -0400
Message-ID: <47DDE187.70109@linux.vnet.ibm.com>
Date: Mon, 17 Mar 2008 08:42:07 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Paul Menage <menage@google.com>
CC: linux-mm@kvack.org, Hugh Dickins <hugh@veritas.com>,
       Sudhir Kumar <skumar@linux.vnet.ibm.com>,
       YAMAMOTO Takashi <yamamoto@valinux.co.jp>, lizf@cn.fujitsu.com,
       linux-kernel@vger.kernel.org, taka@valinux.co.jp,
       David Rientjes <rientjes@google.com>,
       Pavel Emelianov <xemul@openvz.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [RFC][0/3] Virtual address space control for cgroups
References: <20080316172942.8812.56051.sendpatchset@localhost.localdomain> <6599ad830803161626q1fcf261bta52933bb5e7a6bdd@mail.gmail.com> <47DDCE5E.9020104@linux.vnet.ibm.com> <6599ad830803161855y1ceb8aa8t2f486434b521bd81@mail.gmail.com>
In-Reply-To: <6599ad830803161855y1ceb8aa8t2f486434b521bd81@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Menage wrote:
> On Mon, Mar 17, 2008 at 9:50 AM, Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
>>  I am yet to measure the performance overhead of the accounting checks. I'll try
>>  and get started on that today. I did not consider making it a separate system,
>>  because I suspect that anybody wanting memory control would also want address
>>  space control (for the advantages listed in the documentation).
> 
> I'm a counter-example to your suspicion :-)
> 
> Trying to control virtual address space is a complete nightmare in the
> presence of anything that uses large sparsely-populated mappings
> (mmaps of large files, or large sparse heaps such as the JVM uses.)
> 

Not really. Virtual limits are more gentle than an OOM kill that can occur if
the cgroup runs out of memory. Please also see
http://linux-vserver.org/Memory_Limits

> If we want to control the effect of swapping, the right way to do it
> is to control disk I/O, and ensure that the swapping is accounted to
> that. Or simply just not give apps much swap space.

Yes, a disk I/O and swap I/O controller are being developed (not by us, but
others in the community). How does one restrict swap space for a particular
application? I can think of RLIMIT_AS for a process and something similar to
what I've posted for cgroups. Not enabling swap is an option, but not very
practical IMHO.

-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
