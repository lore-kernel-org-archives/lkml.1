Return-Path: <linux-kernel-owner+w=401wt.eu-S1757003AbYDJNk6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757003AbYDJNk6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2008 09:40:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753723AbYDJNkv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Apr 2008 09:40:51 -0400
Received: from mailhub.sw.ru ([195.214.232.25]:5306 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752198AbYDJNku (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2008 09:40:50 -0400
Message-ID: <47FE1219.5010405@parallels.com>
Date: Thu, 10 Apr 2008 17:11:53 +0400
From: Kirill Korotaev <dev@parallels.com>
Organization: Parallels
User-Agent: Thunderbird 2.0.0.6 (X11/20071022)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: Cedric Le Goater <clg@fr.ibm.com>, "David C. Hansen" <haveblue@us.ibm.com>,
       linux-kernel@vger.kernel.org, Containers <containers@lists.osdl.org>,
       Pavel Emelyanov <xemul@openvz.org>
Subject: Re: [PATCH 1/3] change clone_flags type to u64
References: <20080409222611.GA28087@us.ibm.com>	<20080409223231.GA28267@us.ibm.com>	<871w5enmk7.fsf@basil.nowhere.org> <47FE073B.3060007@fr.ibm.com> <20080410125205.GG10019@one.firstfloor.org>
In-Reply-To: <20080410125205.GG10019@one.firstfloor.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The was no real rationale except for some people seeing "clone" functionality
as the match and the fact that FS_NAMESCAPE was done so made them believe it is a good way to go.
And I warned about flags limitation at the beginning.
Both OpenVZ/vserver suggested to use a special syscall for handling this.
Maybe it is a good point to switch to it now finally and stop worring about all this?

Andi Kleen wrote:
>> I guess that was a development rationale. 
> 
> But what rationale? It just doesn't make much sense to me.
> 
>> Most of the namespaces are in 
>> use in the container projects like openvz, vserver and probably others 
>> and we needed a way to activate the code.
> 
> You could just have added it to feature groups over time.
> 
>> Not perfect I agree.
>>  
>>> With your current strategy are you sure that even 64bit will
>>> be enough in the end? For me it rather looks like you'll
>>> go through those quickly too as more and more of the kernel
>>> is namespaced.
>> well, we're reaching the end. I hope ! devpts is in progress and
>> mq is just waiting for a clone flag.
> 
> Are you sure?
> 
>>  
>>> Also I think the user interface is very unfriendly. How
>>> is a non kernel hacker supposed to make sense of these 
>>> myriads of flags? You'll be creating another 
>>> CreateProcess123_extra_args_extended() 
>>> in the end I fear.
>> well, the clone interface is a not friendly interface anyway. glibc wraps 
>> it
> 
> But only for the stack setup which is just a minor detail. 
> 
> The basic clone() flags interface used to be pretty sane and usable 
> before it could overloaded with so many tiny features.
> 
> I especially worry on how user land should keep track of changing kernel
> here. If you add new feature flag for lots of kernel features it is
> reasonable to expect that in the future there will be often new features.
> 
> Does this mean user land needs to be updated all the time? Will this
> end up like another udev? 
> 
>> We will need a user library, like we have a libphtread or a libaio, to
> 
> That doesn't make sense. The basic kernel syscalls should be usable,
> not require some magic library that would likely need intimate 
> knowledge of specific kernel versions to do any good.
> 
>> but we still need a way to extend the clone flags because none are left.
> 
> Can we just take out some again that were added in the .25 cycle and
> readd them once there is a properly thought out interface?  That would
> leave at least one.
> 
> -Andi
> _______________________________________________
> Containers mailing list
> Containers@lists.linux-foundation.org
> https://lists.linux-foundation.org/mailman/listinfo/containers
> 
