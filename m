Return-Path: <linux-kernel-owner+w=401wt.eu-S932705AbXCALrl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932705AbXCALrl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2007 06:47:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933251AbXCALrl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Mar 2007 06:47:41 -0500
Received: from smtp-outbound-1.vmware.com ([65.113.40.141]:51230 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932705AbXCALrl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2007 06:47:41 -0500
Message-ID: <45E6BD5B.4030305@vmware.com>
Date: Thu, 01 Mar 2007 03:47:39 -0800
From: Zachary Amsden <zach@vmware.com>
User-Agent: Thunderbird 1.5.0.9 (X11/20061206)
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Daniel Hecht <dhecht@vmware.com>, Linus Torvalds <torvalds@osdl.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Bug in on_each_cpu?
References: <45E6AC1A.8050608@vmware.com>	 <20070301024524.c7c8ea1a.akpm@linux-foundation.org>	 <45E6BA3A.2040306@vmware.com> <1172749278.10271.43.camel@localhost.localdomain>
In-Reply-To: <1172749278.10271.43.camel@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Rusty Russell wrote:
> On Thu, 2007-03-01 at 03:34 -0800, Zachary Amsden wrote:
>   
>> What would be really, really nice would be to statically check all 
>> callsites that issue irq disables actually keep irqs disabled.  
>> Presumably, there was a reason they disabled irqs, and re-enabling them 
>> underneath their noses, even if it is to avoid a race, breaks the logic 
>> behind that reason.
>>     
>
> For the moment, how about a BUG_ON() in on_each_cpu()?
>   

Sounds quite decent.  But why does on_each_cpu need to disable 
interrupts at all?  It just calls func(), then re-enables interrupts.  
So whatever was going to happen during func() that might not be 
interrupt safe could just be done in the callee, avoiding the rather 
expensive mess of disabling and re-enabling interrupts for those cases 
where it doesn't matter.

I haven't looked at the call sites, but perhaps on_each_cpu() and 
on_each_cpu_noirq() might be an appropriate distinction.

Zach
