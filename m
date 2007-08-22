Return-Path: <linux-kernel-owner+w=401wt.eu-S964833AbXHVVqu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964833AbXHVVqu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2007 17:46:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933970AbXHVVq0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Aug 2007 17:46:26 -0400
Received: from smtp-outbound-1.vmware.com ([65.113.40.141]:46830 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933678AbXHVVqY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2007 17:46:24 -0400
Message-ID: <46CCAD7A.80505@vmware.com>
Date: Wed, 22 Aug 2007 14:41:14 -0700
From: Zachary Amsden <zach@vmware.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Andi Kleen <ak@suse.de>, Andrew Morton <akpm@osdl.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Virtualization Mailing List <virtualization@lists.osdl.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Chris Wright <chrisw@sous-sol.org>, Avi Kivity <avi@qumranet.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: [PATCH] Add I/O hypercalls for i386 paravirt
References: <46CBC842.4070100@vmware.com>	<20070822102217.GE2642@bingen.suse.de>	<46CC68D9.5060200@vmware.com>	<20070822175918.GB8058@bingen.suse.de>	<46CC6D63.2010204@vmware.com>	<20070822194632.GD8058@bingen.suse.de>	<46CC9FF2.3040406@vmware.com>	<20070822220451.GJ8058@bingen.suse.de> <20070822222528.7c58f1e9@the-village.bc.nu>
In-Reply-To: <20070822222528.7c58f1e9@the-village.bc.nu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
>> I still think it's preferable to change some drivers than everybody.
>>
>> AFAIK BusLogic as real hardware is pretty much dead anyways,
>> so you're probably the only primary user of it anyways.
>> Go wild on it!
>>     
>
> I don't believe anyone is materially maintaining the buslogic driver and
> in time its going to break completely.
>   

I think I was actually the last person to touch it ;)

>   
>> Well that might be. I just think it would be a mistake
>> to design paravirt_ops based on someone's short term release engineering
>> considerations.
>>     
>
> Agreed, especially as an interface where each in or out traps into the
> hypervisor is broken even for the model of virtualising hardware. 
>   

Well, it's not necessarily broken, it's just a different model.  At some 
point the cost of maintaining a whole suite of virtual drivers becomes 
greater than leveraging a bunch of legacy drivers.  If you can eliminate 
most of the performance cost of that by changing something at a layer 
below (port I/O), it is a win even if it is not a perfect solution.

But I think I've lost the argument anyways; it doesn't seem to be for 
the greater good of Linux, and there are alternatives we can take.  
Unfortunately for me, they require a lot more work.

Zach
