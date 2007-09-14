Return-Path: <linux-kernel-owner+w=401wt.eu-S1758854AbXINVDQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758854AbXINVDQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2007 17:03:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756135AbXINVDE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Sep 2007 17:03:04 -0400
Received: from wx-out-0506.google.com ([66.249.82.228]:12761 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756231AbXINVDD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2007 17:03:03 -0400
Message-ID: <46EAF6FC.80207@codemonkey.ws>
Date: Fri, 14 Sep 2007 16:02:52 -0500
From: Anthony Liguori <anthony@codemonkey.ws>
User-Agent: Thunderbird 2.0.0.6 (X11/20070830)
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: Anthony Liguori <aliguori@us.ibm.com>, kvm-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, Avi Kivity <avi@qumranet.com>
Subject: Re: [kvm-devel] [PATCH] Refactor hypercall infrastructure
References: <11897991353793-git-send-email-aliguori@us.ibm.com> <46EAF4C6.8090903@goop.org>
In-Reply-To: <46EAF4C6.8090903@goop.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge wrote:
> Anthony Liguori wrote:
>   
>> This patch refactors the current hypercall infrastructure to better support live
>> migration and SMP.  It eliminates the hypercall page by trapping the UD
>> exception that would occur if you used the wrong hypercall instruction for the
>> underlying architecture and replacing it with the right one lazily.
>>   
>>     
>
> I guess it would be pretty rude/unlikely for these opcodes to get reused
> in other implementations...  But couldn't you make the page trap
> instead, rather than relying on an instruction fault?
>   

The whole point of using the instruction is to allow hypercalls to be 
used in many locations.  This has the nice side effect of not requiring 
a central hypercall initialization routine in the guest to fetch the 
hypercall page.  A PV driver can be completely independent of any other 
code provided that it restricts itself to it's hypercall namespace.

>> It also introduces the infrastructure to probe for hypercall available via
>> CPUID leaves 0x40000002.  CPUID leaf 0x40000003 should be filled out by
>> userspace.
>>   
>>     
>
> Is this compatible with Xen's (and other's) use of cpuid?  That is,
> 0x40000000 returns a hypervisor-specific signature in e[bcd]x, and eax
> has the max hypervisor leaf.
>   

Xen is currently using 0/1/2.  I had thought it was only using 0/1.  The 
intention was not to squash Xen's current CPUID usage so that it would 
still be possible for Xen to make use of the guest code.  Can we agree 
that Xen won't squash leaves 3/4 or is it not worth trying to be 
compatible at this point?

Regards,

Anthony Liguori

>     J
>
> -------------------------------------------------------------------------
> This SF.net email is sponsored by: Microsoft
> Defy all challenges. Microsoft(R) Visual Studio 2005.
> http://clk.atdmt.com/MRT/go/vse0120000070mrt/direct/01/
> _______________________________________________
> kvm-devel mailing list
> kvm-devel@lists.sourceforge.net
> https://lists.sourceforge.net/lists/listinfo/kvm-devel
>
>   

