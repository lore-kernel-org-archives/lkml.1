Return-Path: <linux-kernel-owner+w=401wt.eu-S1753506AbYCLDj3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753506AbYCLDj3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2008 23:39:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753251AbYCLDjR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Mar 2008 23:39:17 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:53141 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753244AbYCLDjK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2008 23:39:10 -0400
X-IronPort-AV: E=McAfee;i="5100,188,5249"; a="1236170"
Message-ID: <47D7505B.6080706@qualcomm.com>
Date: Tue, 11 Mar 2008 20:39:07 -0700
From: Max Krasnyansky <maxk@qualcomm.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Paul Menage <menage@google.com>
CC: Paul Jackson <pj@sgi.com>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: boot cgroup questions
References: <47D73086.2030008@qualcomm.com>	 <6599ad830803111827n1cb8e2c7i47c2ef3f3bb58995@mail.gmail.com>	 <47D7411E.1000009@qualcomm.com>	 <6599ad830803111936jd940deam8584bc971c3b6f41@mail.gmail.com>	 <47D74595.4080100@qualcomm.com> <6599ad830803112009y18d9e43ft8e3fc4a551d891da@mail.gmail.com>
In-Reply-To: <6599ad830803112009y18d9e43ft8e3fc4a551d891da@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Menage wrote:
> On Tue, Mar 11, 2008 at 7:53 PM, Max Krasnyansky <maxk@qualcomm.com> wrote:
>> It probably won't even affect your existing scripts since
>> they will be able to move tasks into another set just like they do now.
> 
> My boot scripts look in /dev/cpuset/tasks to find processes to move
> into the system cpuset. So that would break them.
I see. I assumed you just iterate through /proc/[0-9]*

>>  they will now have to unset it in the 'boot' set as well.
> 
> That can break existing userspace, so I presume PaulJ isn't in favour
> of this change.
My impression was that he was ok with changing his stuff. But I maybe
completely wrong of course. I'm actually perfectly fine with making it
conditional.
Maybe something like
	bootcpuset=1
?

>> Otherwise since the
>>  'boot' set will be non-exclusive (cpus and mems) it should not really affect
>>  anything.
> 
> Apart from other cpusets that *are* mem_exclusive or cpu_exclusive.
Hold on, if you move all the tasks ... Oh, never mind :). You mean that you
won't be able to create any cpusets that must be exclusive unless you nuke
'boot' set. Makes sense.

>>  So what's your concern with unconditional 'boot' cgroup/cpuset ?
> 
> The exclusivity problem, as above.
Yes I agree. If this 'boot' set is unconditional user-space tools will have to
change. As I mentioned above I totally do not mind if is is conditional. Any
other opinions out there ?

> 
> Which subsystems are you going to include in this boot hierarchy?
> Userspace is going to have to be aware of the fact that there's a
> cpusets hierarchy which might have to be dismantled if it wants to set
> up something different.
I was going to only include 'cpusets'. Does it make sense for anything else ?

Max
