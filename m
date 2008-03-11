Return-Path: <linux-kernel-owner+w=401wt.eu-S1756753AbYCKEp7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756753AbYCKEp7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2008 00:45:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752064AbYCKEpw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Mar 2008 00:45:52 -0400
Received: from E23SMTP02.au.ibm.com ([202.81.18.163]:47593 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751368AbYCKEpv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2008 00:45:51 -0400
Message-ID: <47D60E74.6080109@linux.vnet.ibm.com>
Date: Tue, 11 Mar 2008 10:15:40 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 1.5.0.12 (X11/20080131)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Paul Menage <menage@google.com>, Pavel Emelianov <xemul@openvz.org>,
       Hugh Dickins <hugh@veritas.com>,
       Sudhir Kumar <skumar@linux.vnet.ibm.com>,
       YAMAMOTO Takashi <yamamoto@valinux.co.jp>, lizf@cn.fujitsu.com,
       linux-kernel@vger.kernel.org, taka@valinux.co.jp, linux-mm@kvack.org,
       David Rientjes <rientjes@google.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [PATCH] Move memory controller allocations to their own slabs
References: <20080311043149.20251.50059.sendpatchset@localhost.localdomain> <20080310214100.d7fe7904.akpm@linux-foundation.org>
In-Reply-To: <20080310214100.d7fe7904.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Tue, 11 Mar 2008 10:01:49 +0530 Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
> 
>>
>> Move the memory controller data structures page_cgroup and
>> mem_cgroup_per_zone to their own slab caches. It saves space on the system,
>> allocations are not necessarily pushed to order of 2 and should provide
>> performance benefits.
> 
> eh?  Those structures are tiny.  Which slab allocator has gone and used an
> order-2 allocation and for which structure did it (stupidly) do this?
> 
> 

When I say order of 2, I meant with kmalloc. They are rounded of to 64, 128 byte
boundary. I wanted to pack these objects more closely.

-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
