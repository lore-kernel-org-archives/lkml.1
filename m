Return-Path: <linux-kernel-owner+w=401wt.eu-S965701AbXBOPtS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965701AbXBOPtS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Feb 2007 10:49:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965721AbXBOPtS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Feb 2007 10:49:18 -0500
Received: from mta15.adelphia.net ([68.168.78.77]:42250 "EHLO
	mta15.adelphia.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965701AbXBOPtR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Feb 2007 10:49:17 -0500
Message-ID: <45D480FB.4030503@acm.org>
Date: Thu, 15 Feb 2007 09:49:15 -0600
From: Corey Minyard <minyard@acm.org>
User-Agent: Icedove 1.5.0.9 (X11/20061220)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Paul Mackerras <paulus@samba.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [patch 4/4] ipmi: add new IPMI nmi watchdog handling
References: <20070214201257.GD5364@localdomain>	<20070214195718.e78458cf.akpm@linux-foundation.org>	<17875.56356.396676.239952@cargo.ozlabs.ibm.com> <20070214201632.a7f18794.akpm@linux-foundation.org>
In-Reply-To: <20070214201632.a7f18794.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Thu, 15 Feb 2007 15:05:56 +1100 Paul Mackerras <paulus@samba.org> wrote:
>
>   
>> Andrew Morton writes:
>>
>>     
>>> This is all fairly unpleasant.
>>>
>>> What architecture is preventing us from using DIE_NMI_POST on all
>>> architectures which support ipmi?  ia64?
>>>
>>> It would be better to simply require that all ipmi-using architectures
>>> implement notify_die(DIE_NMI_POST, ...).
>>>       
>> We're starting to see IPMI creeping on powerpc as well, and we don't
>> have an NMI.
>>     
PowerPC could have an NMI, at least on many of the processors, if 
manufacturers would wire in the MCP line and use it as an NMI.
>>     
>
> Sure, but you could implement the registration function.  I mean, you
> _would_ call the NMI callback if you could, right ;)
>
> As it stands, this change is pretty gruesome...
>   
Yes, it's certainly not ideal.  Most architectures do not have 
asm/kdebug.h, which was the reason for CONFIG_HAVE_STANDARD_NOTIFY_DIE.  
I know there are IPMI implementations on x86, ia64, ARM, MIPS, and PowerPC.

So I see the following options besides what's already there:

1) add asm/kdebug.h and DIE_NMI_POST to everything that might have an 
IPMI implementation.
2) use CONFIG_X86 to tell if NMI will work, since that's the only thing 
it will work on at the present.

I don't have any way to know how different systems have implemented that 
feature, so I can't actually implement it for the various architectures 
(plus I don't have any of those boards).  So maybe #2 is the best?

-Corey
