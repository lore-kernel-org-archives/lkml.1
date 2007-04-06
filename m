Return-Path: <linux-kernel-owner+w=401wt.eu-S1753395AbXDFALc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753395AbXDFALc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2007 20:11:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753398AbXDFALc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Apr 2007 20:11:32 -0400
Received: from smtp-outbound-1.vmware.com ([65.113.40.141]:47623 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753395AbXDFALb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2007 20:11:31 -0400
Message-ID: <46158FBE.3090105@vmware.com>
Date: Thu, 05 Apr 2007 17:09:34 -0700
From: Zachary Amsden <zach@vmware.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070221)
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: Andi Kleen <ak@suse.de>, Andrew Morton <akpm@osdl.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@osdl.org>
Subject: Re: [PATCH] Bugfix for VMI paravirt ops
References: <46158674.5090709@vmware.com> <200704060154.41574.ak@suse.de> <46158DE1.4050508@vmware.com> <46158F8E.1050807@goop.org>
In-Reply-To: <46158F8E.1050807@goop.org>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge wrote:
> Zachary Amsden wrote:
>   
>> Well at this point, the "proper" fix is dependent on Jeremy's
>> kmap_atomic_pte changes, which are definitely too late to pull into
>> 2.6.21.  Can we just apply this patch please? 
>>     
>
> Hm, I think they're independent aren't they?  Your fix is about making
> lazy_mmu disable interrupts; that's independent of how highpte pages get
> mapped.

No, they are totally dependent.  The reason interrupts are disabled is 
to stop kmap_atomic in interrupt handlers.  With the kmap_atomic_pte 
changes, the whole interrupt disable jibberish goes away.

Zach
