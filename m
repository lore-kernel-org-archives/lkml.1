Return-Path: <linux-kernel-owner+w=401wt.eu-S1757384AbYCEPxd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757384AbYCEPxd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2008 10:53:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753183AbYCEPxZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Mar 2008 10:53:25 -0500
Received: from E23SMTP05.au.ibm.com ([202.81.18.174]:35265 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753661AbYCEPxY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2008 10:53:24 -0500
Date: Wed, 5 Mar 2008 21:23:10 +0530
From: Dhaval Giani <dhaval@linux.vnet.ibm.com>
To: Xpl++ <xpl@amln.net>
Cc: fedora-devel-list@redhat.com, opensuse-packaging@opensuse.org,
       lkml <linux-kernel@vger.kernel.org>,
       containers@lists.linux-foundation.org, Balbir Singh <balbir@in.ibm.com>,
       menage@google.com, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       Sudhir Kumar <skumar@linux.vnet.ibm.com>
Subject: Re: [RFC] libcg: design and plans
Message-ID: <20080305155310.GA5349@linux.vnet.ibm.com>
Reply-To: Dhaval Giani <dhaval@linux.vnet.ibm.com>
References: <20080304152341.GB5659@linux.vnet.ibm.com> <47CD83C7.4020206@amln.net> <20080305052631.GA26361@linux.vnet.ibm.com> <47CE8A67.3050109@amln.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47CE8A67.3050109@amln.net>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 05, 2008 at 01:56:23PM +0200, Xpl++ wrote:
> Hi Dhaval,
>
> Dhaval Giani ??????:
>>> I was wonder if creating such library makes any sense at all, considering 
>>> the nature of cgroups, the way they work and their possible application?
>>> It seems to me that any attempt to create a 'simple' API would actualy 
>>> result in something that will be much harder to use that just making raw 
>>> mkdir/open/read/write/close operations.
>>>     
>>
>> These simple APIs are nothing but raw mkdir/open/read/write/close
>> operations.
>>
>>   
> Then why do you have to make the api? Everybody knows how to user these 
> syscalls :)
> If its only this -> why use it? If it's not -> it aint simple anymore?

Well, that's just a small subset of the APIs. There are a lot of other
things that libcg does.

>>>  Another thing is suggested config for this lib would be more appropriate 
>>> for a daemon rather than a library.
>>> In general - cgroup is a very flexible subsystem that can be used in a 
>>> wide variety of ways and modes and trying to create a universal simple 
>>> API would more likely result in something hard to manage and work with.
>>> The idea of having multiple container managers (applications that use 
>>> libcg) creates a lots of questions and possible issues. Containers are 
>>> supposed provide a flexible resource management and task grouping 
>>> ability, which somewhat implies that there cannot be two different 
>>> resource managers per node without one knowing well the 
>>> desires/goals/methods of the other and vice versa. And should there be 
>>> only one manager per node - probably it will be easier for it to use 
>>> cgroup subsystem directly rather than using a wrapper library?
>>>     
>>
>> I disagree. Allowing multiple resource managers allows more flexibility.
>> One thing the configuration subsystem aims to do is to allow permissions
>> to the groups. With this happening, a resource manager does not need to
>> about the existence of other groups, it can control only the resources
>> allotted to it. And since the top level is controlled by the
>> administrator, he is aware of the groups and their needs. (I've given an
>> example of such a scenario in the document as well).
>>   
> Imagine having a shared/joint household savings account with your wife, and 
> taking money from it without your wife knowing and vice versa .. then at 
> some point when you thought that you have some $5K to buy the new super 
> duper laptop you dreamt about your entire life - surprise - no enough 
> resources :)
> This is somewhat the equivalent of multiple independent resourse managers 
> :) It won't end well :)
> Should they be expected to be adequate in doing their job, they cannot be 
> independent since they manage a shared resource.
>

I don't quite agree with your analogy here. The point here is that each
resource manager operates in its own area, and has already been assigned
some resources which it cannot change. Its more like you can take $x at
the most from the account and your wife $y with x+y<=total money.

-- 
regards,
Dhaval
