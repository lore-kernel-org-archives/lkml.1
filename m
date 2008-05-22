Return-Path: <linux-kernel-owner+w=401wt.eu-S936596AbYEVKQj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936596AbYEVKQj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2008 06:16:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933700AbYEVKQ1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 May 2008 06:16:27 -0400
Received: from e28smtp05.in.ibm.com ([59.145.155.5]:38835 "EHLO
	e28smtp05.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933330AbYEVKQZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2008 06:16:25 -0400
Message-ID: <483547B1.6030604@linux.vnet.ibm.com>
Date: Thu, 22 May 2008 15:45:13 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-mm@kvack.org, Sudhir Kumar <skumar@linux.vnet.ibm.com>,
       YAMAMOTO Takashi <yamamoto@valinux.co.jp>,
       Paul Menage <menage@google.com>, lizf@cn.fujitsu.com,
       linux-kernel@vger.kernel.org, Pavel Emelianov <xemul@openvz.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [-mm][PATCH 4/4] Add memrlimit controller accounting and control
 (v5)
References: <20080521152921.15001.65968.sendpatchset@localhost.localdomain> <20080521153012.15001.96490.sendpatchset@localhost.localdomain> <20080521212408.6f535259.akpm@linux-foundation.org>
In-Reply-To: <20080521212408.6f535259.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Wed, 21 May 2008 21:00:12 +0530 Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
> 
>> This patch adds support for accounting and control of virtual address space
>> limits. The accounting is done via the rlimit_cgroup_(un)charge_as functions.
>> The core of the accounting takes place during fork time in copy_process(),
>> may_expand_vm(), remove_vma_list() and exit_mmap(). 
>>
>> Changelog v5->v4
>>
>> Move specific hooks in code to insert_vm_struct
>> Use mmap_sem to protect mm->owner from changing and mm->owner from
>> changing cgroups.
>>
>> ...
>>
>> + * brk(), sbrk()), stack expansion, mremap(), etc - called with
>> + * mmap_sem held.
>> + * decreasing - called with mmap_sem held.
>> + * This callback is called with mmap_sem held
> 
> It's good to document the locking prerequisites but for rwsems, one
> should specify whether it must be held for reading or for writing.
> 
> Of course, down_write() is a superset of down_read(), so if it's "held
> for reading" then either mode-of-holding is OK.  But it's best to spell
> all that out.
> 

Sure, will do


-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
