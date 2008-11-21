Return-Path: <linux-kernel-owner+w=401wt.eu-S1756141AbYKUQI4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756141AbYKUQI4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2008 11:08:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756898AbYKUQIj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Nov 2008 11:08:39 -0500
Received: from E23SMTP02.au.ibm.com ([202.81.18.163]:35544 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756880AbYKUQIi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2008 11:08:38 -0500
Message-ID: <4926DC1B.1020809@linux.vnet.ibm.com>
Date: Fri, 21 Nov 2008 21:34:43 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 2.0.0.17 (X11/20080925)
MIME-Version: 1.0
To: ananth@in.ibm.com
CC: Nikanth Karthikesan <knikanth@suse.de>, linux-kernel@vger.kernel.org,
       davem@davemloft.net, mhiramat@redhat.com, contact@ksplice.com,
       jbarnold@ksplice.com, tabbott@ksplice.com, wdaher@ksplice.com,
       andersk@ksplice.com
Subject: Re: [RFC] kreplace: Rebootless kernel updates
References: <200811211720.26394.knikanth@suse.de> <20081121133800.GA5244@in.ibm.com>
In-Reply-To: <20081121133800.GA5244@in.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ananth N Mavinakayanahalli wrote:
> On Fri, Nov 21, 2008 at 05:20:25PM +0530, Nikanth Karthikesan wrote:
>> This RFC patch adds support for limited form of rebootless kernel patching 
>> even without building the entire kernel.
>>
>> When looking for a shortcut to avoid the rebuild/reboot cycle when hacking the  
>> kernel - the ksplice[1] was posted. This patch extends kprobes to do something 
>> similar, which would require even lesser time to _experiment_ with the running 
>> kernel. 
> 
> There have been other implementations of this feature, I am sure quite a
> few people would have objections to having this as part of the kernel :-)
> 

I had a patch for x86 a long time ago in 2005, but I never posted it :(

>> This small patch extends jprobes so that the jprobe's handler is executed but 
>> skips executing the actual function. But this has its own limitations such as 
>> Cannot access symbols not exported for modules (ofcourse hacks like 
>> pointers[2] can be used.), problems related to return values[3], etc... This 
>> is currently a x86_64 only _hack_.
> 
> There are many other issues too... How do you enforce correct usage of this
> infrastrucutre? What prevents people from overriding core-kernel
> functions with their own?
> 

Yes and we need to be careful about licensing, tainting the kernel with such an
implementation.

> Kprobes themselves provide enough ammunition to users to shoot themselves
> in the foot, but this is way more dangerous than that.
> ...
> 

Undoubtedly, but a good warning is the best way to keep people warned about
running such code :) It is a useful thing to have and to run, but running it
would take more guts than anything else.



-- 
	Balbir
