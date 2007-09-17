Return-Path: <linux-kernel-owner+w=401wt.eu-S1756020AbXIQSMX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756020AbXIQSMX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2007 14:12:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755768AbXIQSMO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Sep 2007 14:12:14 -0400
Received: from E23SMTP03.au.ibm.com ([202.81.18.172]:36602 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753719AbXIQSMN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2007 14:12:13 -0400
Message-ID: <46EEC359.8070508@linux.vnet.ibm.com>
Date: Mon, 17 Sep 2007 23:41:37 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 1.5.0.13 (X11/20070824)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Simon Derr <Simon.Derr@bull.net>, Nicolas Capit <nicolas.capit@imag.fr>,
       linux-kernel@vger.kernel.org, Paul Jackson <pj@sgi.com>,
       "Serge E. Hallyn" <serue@us.ibm.com>, Paul Menage <menage@google.com>,
       Balbir Singh <balbir@in.ibm.com>
Subject: Re: cpuset trouble after hibernate
References: <20070908204438.3bf03d85@localhost.localdomain> <Pine.LNX.4.64.0709101141180.3467@frecb006381.adech.frec.bull.fr> <20070915010807.b0055e7e.akpm@linux-foundation.org>
In-Reply-To: <20070915010807.b0055e7e.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Mon, 10 Sep 2007 11:45:10 +0200 (CEST) Simon Derr <Simon.Derr@bull.net> wrote:
> 
>> On Sat, 8 Sep 2007, Nicolas Capit wrote:
>>
>>> Hello,
>>>
>>> This is my situation:
>>>   - I mounted the pseudo cpuset filesystem into /dev/cpuset
>>>   - I created a cpuset named oar with my 2 cpus
>>>
>>> cat /dev/cpuset/oar/cpus 
>>> 0-1
>>>
>>>   - Then I hibernate my computer with 'echo -n "disk" >/sys/power/state'
>>>   - After reboot:
>>>
>>> cat /dev/cpuset/oar/cpus 
>>> 0
>>>
>>> Why did I lost a cpu?
>>> Is this a normal behavior???
>> Hi Nicolas,
>>
>> I believe this is related to the fact that hibernation uses the hotplug 
>> subsystem to disable all CPUs except the boot CPU.
>>
>> Thus guarantee_online_cpus() is called on each cpuset and removes all 
>> CPUs, except CPU 0, from all cpusets.
>>
>> I'm not quite sure about if/how this should be fixed in the kernel, 
>> though. Looks like a very simple user-land workaround would be enough.
>>
> 
> Yeah.  Bug, surely.  But I guess it's always been there.
> 
> What are the implications of this for cpusets-via-containers?
> 

I suspect the functionality of cpusets is not affected by containers.

I wonder if containers should become suspend/resume aware and pass
that option on to controllers. I think it's only the bus drivers
and device drivers that do that now.



-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
