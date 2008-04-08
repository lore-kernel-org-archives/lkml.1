Return-Path: <linux-kernel-owner+w=401wt.eu-S1758842AbYDHCl3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758842AbYDHCl3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2008 22:41:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753258AbYDHClV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Apr 2008 22:41:21 -0400
Received: from e28smtp06.in.ibm.com ([59.145.155.6]:50974 "EHLO
	e28smtp06.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751927AbYDHClU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2008 22:41:20 -0400
Message-ID: <47FADAFD.7030202@linux.vnet.ibm.com>
Date: Tue, 08 Apr 2008 08:09:57 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: menage@google.com, xemul@openvz.org, hugh@veritas.com,
       skumar@linux.vnet.ibm.com, yamamoto@valinux.co.jp, lizf@cn.fujitsu.com,
       linux-kernel@vger.kernel.org, taka@valinux.co.jp, linux-mm@kvack.org,
       rientjes@google.com, kamezawa.hiroyu@jp.fujitsu.com
Subject: Re: [-mm] Add an owner to the mm_struct (v8)
References: <20080404080544.26313.38199.sendpatchset@localhost.localdomain> <20080407150956.9a29573a.akpm@linux-foundation.org>
In-Reply-To: <20080407150956.9a29573a.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Fri, 04 Apr 2008 13:35:44 +0530
> Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
> 
>> 1. Add mm->owner change callbacks using cgroups
>>
>> ...
>>
>> +config MM_OWNER
>> +	bool "Enable ownership of mm structure"
>> +	help
>> +	  This option enables mm_struct's to have an owner. The advantage
>> +	  of this approach is that it allows for several independent memory
>> +	  based cgroup controllers to co-exist independently without too
>> +	  much space overhead
>> +
>> +	  This feature adds fork/exit overhead. So enable this only if
>> +	  you need resource controllers
> 
> Do we really want to offer this option to people?  It's rather a low-level
> thing and it's likely to cause more confusion than it's worth.  Remember
> that most kernels get to our users via kernel vendors - to what will they
> be setting this config option?
> 

I suspect that this kernel option will not be explicitly set it. This option
will be selected by other config options (memory controller, swap namespace,
revoke*)

>>  config CGROUP_MEM_RES_CTLR
>>  	bool "Memory Resource Controller for Control Groups"
>>  	depends on CGROUPS && RESOURCE_COUNTERS
>> +	select MM_OWNER
> 
> Presumably they'll always be setting it to "y" if they are enabling cgroups
> at all.
> 
>> --- linux-2.6.25-rc8/kernel/cgroup.c~memory-controller-add-mm-owner	2008-04-03 22:43:27.000000000 +0530
>> +++ linux-2.6.25-rc8-balbir/kernel/cgroup.c	2008-04-03 22:43:27.000000000 +0530
>> @@ -118,6 +118,7 @@ static int root_count;
>>   * be called.
>>   */
>>  static int need_forkexit_callback;
>> +static int need_mm_owner_callback;
> 
> I suppose these should be __read_mostly.
> 

Yes, good point. I'll send out v9 with this fix.

-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
