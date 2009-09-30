Return-Path: <linux-kernel-owner+w=401wt.eu-S1754656AbZI3PJ3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754656AbZI3PJ3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Sep 2009 11:09:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754447AbZI3PJ1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Sep 2009 11:09:27 -0400
Received: from mailhub.sw.ru ([195.214.232.25]:35694 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754646AbZI3PJ0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Sep 2009 11:09:26 -0400
Message-ID: <4AC374A4.5030709@openvz.org>
Date: Wed, 30 Sep 2009 19:09:24 +0400
From: Pavel Emelyanov <xemul@openvz.org>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: vatsa@in.ibm.com
CC: Bharata B Rao <bharata@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
       Gautham R Shenoy <ego@in.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Herbert Poetzl <herbert@13thfloor.at>, Avi Kivity <avi@redhat.com>,
       Chris Friesen <cfriesen@nortel.com>, Paul Menage <menage@google.com>,
       Mike Waychison <mikew@google.com>
Subject: Re: [RFC v2 PATCH 0/8] CFS Hard limits - v2
References: <20090930124919.GA19951@in.ibm.com> <4AC35EDD.1080902@openvz.org> <20090930142537.GJ19951@in.ibm.com> <20090930143953.GA2014@in.ibm.com>
In-Reply-To: <20090930143953.GA2014@in.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Srivatsa Vaddagiri wrote:
> On Wed, Sep 30, 2009 at 07:55:37PM +0530, Bharata B Rao wrote:
>> On Wed, Sep 30, 2009 at 05:36:29PM +0400, Pavel Emelyanov wrote:
>>> Bharata B Rao wrote:
>>>> Hi,
>>>>
>>>> Here is the v2 post of hard limits feature for CFS group scheduler. This
>>>> RFC post mainly adds runtime borrowing feature and has a new locking scheme
>>>> to protect CFS runtime related fields.
>>>>
>>>> It would be nice to have some comments on this set!
>>> I have a question I'd like to ask before diving into the code.
>>> Consider I'm a user, that has a 4CPUs box 2GHz each and I'd like
>>> to create a container with 2CPUs 1GHz each. Can I achieve this
>>> after your patches?
>> I am not sure if I understand the GHz specification you mention here.
>> Are you saying that you want run a container with 2 CPUS with each of
>> them running at half their (frequency)capacity ?
>>
>> This hard limits scheme is about time based rate limiting where you can
>> specify a runtime(=hard limit) and a period for the container and the
>> container will not be allowed to consume more than the specified CPU time
>> within a given period.
> 
> IMO Pavel's requirement can be met with a hard limit of 25%
> 
> 	2 CPU of 1GHz = (1/2 x 4) (1/2 x 2) GHz CPUs
> 		      = 1/4 x 4 2GHz CPU
> 		      = 25% of (4 2GHz CPU)
> 
> IOW by hard-limiting a container thread to run just 0.5sec every sec on a 2GHz 
> cpu, it is effectively making progress at the rate of 1GHz?

4CPUS 25% each is not the same as 2CPUS 50% each.
OTOH making 2CPU container and setting 50% for both would work, but please
look at the problem from the end user point of view. He wants to set 50% of
the CPU power. Which setup is better 0.5/1, 1/2 or 0.25/0.5?

If you look at how tc works it proposes the user to select bandwidth in
human readable values like kbps or mbps.

> - vatsa
> 

