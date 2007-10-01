Return-Path: <linux-kernel-owner+w=401wt.eu-S1752035AbXJAEJi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752035AbXJAEJi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2007 00:09:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750750AbXJAEJa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Oct 2007 00:09:30 -0400
Received: from gamma.unitedhosting.co.uk ([72.249.26.4]:56686 "EHLO
	gamma.unitedhosting.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750760AbXJAEJ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2007 00:09:29 -0400
Message-ID: <470072E0.50409@aol.com>
Date: Mon, 01 Oct 2007 00:09:04 -0400
From: AndrewL733 <AndrewL733@aol.com>
User-Agent: Thunderbird 1.5.0.13 (Macintosh/20070809)
MIME-Version: 1.0
CC: rdunlap@xenotime.net, Jim Paris <jim@jtan.com>, linas@austin.ibm.com,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Repost:  NMI error and Intel S5000PSL Motherboards
References: <c038f5910709261207k740ad130k151a9b0c8d8e48e0@mail.gmail.com>	<20070926135229.67edd4eb.rdunlap@xenotime.net>	<c038f5910709261207k740ad130k151a9b0c8d8e48e0@mail.gmail.com>	<46FA3092.70108@aol.com>	<20070926121655.55334682@the-village.bc.nu>	<46FA3092.70108@aol.com>	<20070925215819.c993e2d8.rdunlap@xenotime.net>	<46FA3092.70108@aol.com>	<20070925195946.cef5ae9d.rdunlap@xenotime.net>	<46FA3092.70108@aol.com>	<20070926234814.GA27743@jim.sh> <20070926170330.ee8fb5b4.rdunlap@xenotime.net> <46FD1A2F.9050801@aol.com>
In-Reply-To: <46FD1A2F.9050801@aol.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a slightly edited repost of a note sent on Friday September 28, 
as we haven't heard back from anyone yet. (I know it was the weekend!) 
Sorry to post again but this issue caused great problems for us and I 
want to be sure we're choosing a decent solution.

Perhaps one of the people who so helpfully commented on this issue 
earlier last week can now give their opinion on the what should be 
concluded from our discovery that "CONFIG_PCIEAER=y" -- introduced in 
the 2.6.19 kernel and set as the default -- leads to NMI errors on the 
Intel S5000PSL motherboard.

I'm told Intel people were closely involved in the development of this 
PCIEAER feature -- so it seems even weirder that it causes problems for 
this Intel motherboard. But we have confirmed the problem with multiple 
Linux distributions.

We are hoping to get some insights into the real cause. Please see below 
where I outlined what seem to be the 3 possibilities.
> rdunlap@xenotime.net wrote:
>> On Wed, 26 Sep 2007 19:48:14 -0400 Jim Paris wrote:
>>
>>  
>>> Hello,
>>>
>>>    
>>>> We have about 100 servers based on Intel S5000PSL-SATA 
>>>> motherboards. They have been running for anywhere between 1 and 10 
>>>> months. For the past few months, after updating them all to the 
>>>> 2.6.20.15 kernel (because of a bug in the 2.6.18 kernel), we are 
>>>> seeing some strange NMI errors. For example:
>>>>
>>>> Aug 29 09:02:10 master kernel: Uhhuh. NMI received for unknown 
>>>> reason 30.
>>>> Aug 29 09:02:10 master kernel: Do you have a strange power saving 
>>>> mode enabled?
>>>> Aug 29 09:02:10 master kernel: Dazed and confused, but trying to 
>>>> continue
>>>>       
>>> I'm also working with Andrew and Samson.  It seems that the cause of
>>> the problem is CONFIG_PCIEAER, which was introduced after 2.6.18 and
>>> defaults to y.
>>>
>>> With CONFIG_PCIEAER=n, scanpci works fine with no errors.  This is the
>>> workaround that they'll likely use for now.
>>>     
>>
>> Glad that you found it.
>>
>>  
>>> With CONFIG_PCIEAER=y, scanpci always triggers the NMI error.  The
>>> option aerdriver.forceload=1 has no effect.
>>>   
Although running "scanpci" provoked the NMI errors 100 percent on 
demand, the NMI errors would also occur randomly every few weeks on a 
given system without doing anything special. I don't want anybody to 
think we are just trying to prevent a problem from occurring because we 
like running "scanpci".  "Scanpci" just turned out to be a reliable way 
to reproduce an otherwise random problem.
>>
>> The 'forceload' option only forces the driver to load even when the
>> ACPI hardware initialization routine fails.
>>
>> It would be nice to be able to disable PCIEAER at boot time though.
>> Shouldn't be difficult.
>>
>>   


So, looking for some closure here, what do you think is the "root 
cause"? Is it:

1)  a defect with Intel's S5000PSL motherboards that is not seen when 
running 2.6.18 and earlier kernels but that is exposed by this feature 
added in 2.6.19? In which case, shouldn't we work to get Intel to 
investigate?

2)  a problem with the PCIEAER feature? And maybe "CONFIG_PCIEAER=y"  
should NOT be the default setting?

3)  just a bad interaction between a good motherboard and a good Linux 
feature that don't play well together? (in which case isn't this a 
"feature" that anybody compiling a kernel to run on the Intel S5000PSL 
motherboard should know not to enable?/

And in general is it a bad idea to set "CONFIG_PCIEAER to "no"". Or is 
it something that we can really live without?




Andrew
