Return-Path: <linux-kernel-owner+w=401wt.eu-S1753832AbYEEEWS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753832AbYEEEWS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 00:22:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751401AbYEEEWE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 00:22:04 -0400
Received: from E23SMTP03.au.ibm.com ([202.81.18.172]:58242 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751348AbYEEEWB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 00:22:01 -0400
Message-ID: <481E8B3F.3050508@linux.vnet.ibm.com>
Date: Mon, 05 May 2008 09:51:19 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: kamezawa.hiroyu@jp.fujitsu.com
CC: linux-mm@kvack.org, Sudhir Kumar <skumar@linux.vnet.ibm.com>,
       YAMAMOTO Takashi <yamamoto@valinux.co.jp>,
       Paul Menage <menage@google.com>, lizf@cn.fujitsu.com,
       linux-kernel@vger.kernel.org, David Rientjes <rientjes@google.com>,
       Pavel Emelianov <xemul@openvz.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [-mm][PATCH 0/4] Add rlimit controller to cgroups (v3)
References: <20080503213726.3140.68845.sendpatchset@localhost.localdomain> <23630056.1209914669637.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <23630056.1209914669637.kamezawa.hiroyu@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

kamezawa.hiroyu@jp.fujitsu.com wrote:
>>
>> This is the third version of the address space control patches. These
>> patches are against 2.6.25-mm1  and have been tested using KVM in SMP mode,
>> both with and without the config enabled.
>>
>> The first patch adds the user interface. The second patch fixes the
>> cgroup mm_owner_changed callback to pass the task struct, so that
>> accounting can be adjusted on owner changes. The thrid patch adds accounting
>> and control. The fourth patch updates documentation.
>>
>> An earlier post of the patchset can be found at
>> http://lwn.net/Articles/275143/
>>
>> This patch is built on top of the mm owner patches and utilizes that feature
>> to virtually group tasks by mm_struct.
>>
>> Reviews, Comments?
>>
> 
> I can't read the whole patch deeply now but this new concept "rlimit-controlle
> r" seems make sense to me.
> 
> At quick glance, I have some thoughts.
> 
> 1. kerner/rlimit_cgroup.c is better for future expansion.

I have no problem with that name, I can rename the files.

> 2. why 
>    "+This controller framework is designed to be extensible to control any
>    "+resource limit (memory related) with little effort."
>    memory only ? Ok, all you want to do is related to memory, but someone
>    may want to limit RLIMIT_CPU by group or RLIMIT_CORE by group or....
>    (I have no plan but they seems useful.;)

I currently mentioned memory, since we have the infrastructure to group using
mm->owner infrastructure. For other purposes, we'll need to enhance the
controller quite a bit. That is why I put memory related in brackets.

>    So, could you add design hint of rlimit contoller to the documentation ?
>    

OK, I'll update the documentation

> 3. Rleated to 2. Showing what kind of "rlimit" params are supported by
>    cgroup will be good.
> 

Do you mean in init/Kconfig or documentation?. I should probably rename
limit_in_bytes and usage_in_bytes to add an as_ prefix, so that the UI clearly
shows what is supported as well.

> I don't think you have to implement all things at once. Staring from
> "only RLIMIT_AS is supported now" is good. Someone will expand it if
> he needs. But showing basic view of "gerenal purpose rlimit contoller" in _doc
> ument_ or _comments_ or _codes_ is a good thing to do.
> 

I can add to the documentation

> If you don't want to provide RLIMIT feature other than address space,
> it's better to avoid using the name of RLIMIT. It's confusing.
> 

I used RLIMIT since I want to extend it later to control memory locked pages :)
I open to other names as well.

> Thanks,
> -Kame
> 
> 
> 
> 
> 
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo@kvack.org.  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>


-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
