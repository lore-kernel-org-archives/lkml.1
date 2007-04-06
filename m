Return-Path: <linux-kernel-owner+w=401wt.eu-S1767314AbXDFAr1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767314AbXDFAr1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2007 20:47:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767451AbXDFAr1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Apr 2007 20:47:27 -0400
Received: from smtp-outbound-1.vmware.com ([65.113.40.141]:57708 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1767314AbXDFAr0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2007 20:47:26 -0400
Message-ID: <4615982A.1070700@vmware.com>
Date: Thu, 05 Apr 2007 17:45:30 -0700
From: Zachary Amsden <zach@vmware.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070221)
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: Andi Kleen <ak@suse.de>, Andrew Morton <akpm@osdl.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@osdl.org>
Subject: Re: [PATCH] Bugfix for VMI paravirt ops
References: <46158674.5090709@vmware.com> <200704060154.41574.ak@suse.de> <46158DE1.4050508@vmware.com> <46158F8E.1050807@goop.org> <46158FBE.3090105@vmware.com> <461590EA.10605@goop.org> <4615924E.8020009@vmware.com> <46159555.4020706@goop.org>
In-Reply-To: <46159555.4020706@goop.org>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge wrote:
> Zachary Amsden wrote:
>   
>> So the clean fix for this is still even further out.  I don't think I
>> want to hook kmap/unmap as paravirt-ops.
>>     
>
> Yes, it seems like overkill.
>
> How about something like adding PARAVIRT_LAZY_FLUSH as an argument to
> set_lazy_mode?  It would be valid to use at any time, and it would flush
> any pending work while still remaining in whatever lazy mode its
> currently in.  That way kmap_atomic can flush anything pending without
> having to muck around with the current lazy state.
>   

Yes, thought about several solutions, and this seems the best.  But it 
requires a new paravirt-op.

Zach

