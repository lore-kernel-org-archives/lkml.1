Return-Path: <linux-kernel-owner+w=401wt.eu-S1764776AbYCELvr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764776AbYCELvr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2008 06:51:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764897AbYCELva
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Mar 2008 06:51:30 -0500
Received: from mail.amln.net ([88.203.210.2]:51415 "EHLO neon.bastun.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762662AbYCELv2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2008 06:51:28 -0500
Message-ID: <47CE8A67.3050109@amln.net>
Date: Wed, 05 Mar 2008 13:56:23 +0200
From: Xpl++ <xpl@amln.net>
User-Agent: Mozilla Thunderbird 1.5.0.14 (Windows/20071210)
MIME-Version: 1.0
To: Dhaval Giani <dhaval@linux.vnet.ibm.com>
CC: fedora-devel-list@redhat.com, opensuse-packaging@opensuse.org,
       lkml <linux-kernel@vger.kernel.org>,
       containers@lists.linux-foundation.org, Balbir Singh <balbir@in.ibm.com>,
       menage@google.com, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       Sudhir Kumar <skumar@linux.vnet.ibm.com>
Subject: Re: [RFC] libcg: design and plans
References: <20080304152341.GB5659@linux.vnet.ibm.com> <47CD83C7.4020206@amln.net> <20080305052631.GA26361@linux.vnet.ibm.com>
In-Reply-To: <20080305052631.GA26361@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dhaval,

Dhaval Giani ??????:
>> I was wonder if creating such library makes any sense at all, considering 
>> the nature of cgroups, the way they work and their possible application?
>> It seems to me that any attempt to create a 'simple' API would actualy 
>> result in something that will be much harder to use that just making raw 
>> mkdir/open/read/write/close operations.
>>     
>
> These simple APIs are nothing but raw mkdir/open/read/write/close
> operations.
>
>   
Then why do you have to make the api? Everybody knows how to user these 
syscalls :)
If its only this -> why use it? If it's not -> it aint simple anymore?
>>  Another thing is suggested config 
>> for this lib would be more appropriate for a daemon rather than a library.
>> In general - cgroup is a very flexible subsystem that can be used in a wide 
>> variety of ways and modes and trying to create a universal simple API would 
>> more likely result in something hard to manage and work with.
>> The idea of having multiple container managers (applications that use 
>> libcg) creates a lots of questions and possible issues. Containers are 
>> supposed provide a flexible resource management and task grouping ability, 
>> which somewhat implies that there cannot be two different resource managers 
>> per node without one knowing well the desires/goals/methods of the other 
>> and vice versa. And should there be only one manager per node - probably it 
>> will be easier for it to use cgroup subsystem directly rather than using a 
>> wrapper library?
>>     
>
> I disagree. Allowing multiple resource managers allows more flexibility.
> One thing the configuration subsystem aims to do is to allow permissions
> to the groups. With this happening, a resource manager does not need to
> about the existence of other groups, it can control only the resources
> allotted to it. And since the top level is controlled by the
> administrator, he is aware of the groups and their needs. (I've given an
> example of such a scenario in the document as well).
>   
Imagine having a shared/joint household savings account with your wife, 
and taking money from it without your wife knowing and vice versa .. 
then at some point when you thought that you have some $5K to buy the 
new super duper laptop you dreamt about your entire life - surprise - no 
enough resources :)
This is somewhat the equivalent of multiple independent resourse 
managers :) It won't end well :)
Should they be expected to be adequate in doing their job, they cannot 
be independent since they manage a shared resource.

Regards,
Peter.
