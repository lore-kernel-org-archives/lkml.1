Return-Path: <linux-kernel-owner+w=401wt.eu-S1753470AbXIORdu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753470AbXIORdu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Sep 2007 13:33:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752709AbXIORdn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Sep 2007 13:33:43 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:51560 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752029AbXIORdn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Sep 2007 13:33:43 -0400
Message-ID: <46EC1775.4000709@us.ibm.com>
Date: Sat, 15 Sep 2007 12:33:41 -0500
From: Anthony Liguori <aliguori@us.ibm.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070830)
MIME-Version: 1.0
To: Zachary Amsden <zach@vmware.com>
CC: Jeremy Fitzhardinge <jeremy@goop.org>, kvm-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, Avi Kivity <avi@qumranet.com>
Subject: Re: [kvm-devel] [PATCH] Refactor hypercall infrastructure
References: <11897991353793-git-send-email-aliguori@us.ibm.com> <46EAF4C6.8090903@goop.org>  <46EAF6FC.80207@codemonkey.ws> <1189804847.5982.137.camel@bodhitayantram.eng.vmware.com> <46EB00D8.3090903@codemonkey.ws> <1189827476.5982.143.camel@bodhitayantram.eng.vmware.com>
In-Reply-To: <1189827476.5982.143.camel@bodhitayantram.eng.vmware.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Zachary Amsden wrote:
> On Fri, 2007-09-14 at 16:44 -0500, Anthony Liguori wrote:
>
>   
>> So then each module creates a hypercall page using this magic MSR and 
>> the hypervisor has to keep track of it so that it can appropriately 
>> change the page on migration.  The page can only contain a single 
>> instruction or else it cannot be easily changed (or you have to be able 
>> to prevent the guest from being migrated while in the hypercall page).
>>
>> We're really talking about identical models.  Instead of an MSR, the #GP 
>> is what tells the hypervisor to update the instruction.  The nice thing 
>> about this is that you don't have to keep track of all the current 
>> hypercall page locations in the hypervisor.
>>     
>
> I agree, multiple hypercall pages is insane.  I was thinking more of a
> single hypercall page, fixed in place by the hypervisor, not the kernel.
>
> Then each module can read an MSR saying what VA the hypercall page is
> at, and the hypervisor can simply flip one page to switch architectures.
>   

That requires a memory hole though.  In KVM, we don't have a memory hole.

Regards,

Anthony Liguori

> Zach
>
>   

