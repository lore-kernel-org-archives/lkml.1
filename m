Return-Path: <linux-kernel-owner+w=401wt.eu-S1753435AbXDFAW1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753435AbXDFAW1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2007 20:22:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753448AbXDFAW1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Apr 2007 20:22:27 -0400
Received: from smtp-outbound-1.vmware.com ([65.113.40.141]:36318 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753435AbXDFAW0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2007 20:22:26 -0400
Message-ID: <4615924E.8020009@vmware.com>
Date: Thu, 05 Apr 2007 17:20:30 -0700
From: Zachary Amsden <zach@vmware.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070221)
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: Andi Kleen <ak@suse.de>, Andrew Morton <akpm@osdl.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@osdl.org>
Subject: Re: [PATCH] Bugfix for VMI paravirt ops
References: <46158674.5090709@vmware.com> <200704060154.41574.ak@suse.de> <46158DE1.4050508@vmware.com> <46158F8E.1050807@goop.org> <46158FBE.3090105@vmware.com> <461590EA.10605@goop.org>
In-Reply-To: <461590EA.10605@goop.org>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge wrote:
> Zachary Amsden wrote:
>   
>> No, they are totally dependent.  The reason interrupts are disabled is
>> to stop kmap_atomic in interrupt handlers.  With the kmap_atomic_pte
>> changes, the whole interrupt disable jibberish goes away. 
>>     
>
> But kmap_atomic_pte is a special case of kmap_atomic for ptes. 
> Interrupt routines can still use plain kmap_atomic for bouncebuffers and
> so on.
>   

Ah, yes.

> A more general patch would be to make kmap/unmap_atomic pv_ops, and then
> they can all be rolled together.  I.e: check the type to see if special
> pte handling needs to happen, etc.
>   

So the clean fix for this is still even further out.  I don't think I 
want to hook kmap/unmap as paravirt-ops.

Zach
