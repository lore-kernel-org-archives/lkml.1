Return-Path: <linux-kernel-owner+w=401wt.eu-S1754822AbYDKEbi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754822AbYDKEbi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2008 00:31:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751423AbYDKEb3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Apr 2008 00:31:29 -0400
Received: from E23SMTP05.au.ibm.com ([202.81.18.174]:60994 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751417AbYDKEb2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2008 00:31:28 -0400
Message-ID: <47FEE89A.1010102@linux.vnet.ibm.com>
Date: Fri, 11 Apr 2008 09:57:06 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
CC: Paul Menage <menage@google.com>, Pavel Emelianov <xemul@openvz.org>,
       Hugh Dickins <hugh@veritas.com>,
       Sudhir Kumar <skumar@linux.vnet.ibm.com>,
       YAMAMOTO Takashi <yamamoto@valinux.co.jp>, linux-kernel@vger.kernel.org,
       taka@valinux.co.jp, linux-mm@kvack.org,
       David Rientjes <rientjes@google.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [-mm] Add an owner to the mm_struct (v9)
References: <20080410091602.4472.32172.sendpatchset@localhost.localdomain> <20080411123339.89aea319.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20080411123339.89aea319.kamezawa.hiroyu@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

KAMEZAWA Hiroyuki wrote:
> maybe I don't undestand correctlly...
> 
> On Thu, 10 Apr 2008 14:46:02 +0530
> Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
> 
>>  
>> +config MM_OWNER
>> +	bool
>> +
> no default is ok here  ? what value will this have if not selected ?
> I'm sorry if I misunderstand Kconfig.
> 

The way this works is

If I select memory resource controller, CONFIG_MM_OWNER is set to y, else it
does not even show up in the .config

> 
>> +	/*
>> +	 * Search through everything else. We should not get
>> +	 * here often
>> +	 */
>> +	do_each_thread(g, c) {
>> +		if (c->mm == mm)
>> +			goto assign_new_owner;
>> +	} while_each_thread(g, c);
>> +
> 
> Again, do_each_thread() is suitable here ?
> for_each_process() ?
> 

do_each_thread(), while_each_thread() walks all processes and threads of those
processes in the system. It is a common pattern used in the kernel (see
try_to_freeze_tasks() or oom_kill_task() for example).

> Thanks,
> -Kame
> 


-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
