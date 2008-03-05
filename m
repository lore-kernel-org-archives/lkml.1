Return-Path: <linux-kernel-owner+w=401wt.eu-S1761157AbYCERc0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761157AbYCERc0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2008 12:32:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755330AbYCERcG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Mar 2008 12:32:06 -0500
Received: from terminus.zytor.com ([198.137.202.10]:43836 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757108AbYCERcB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2008 12:32:01 -0500
Message-ID: <47CED7F8.1060205@zytor.com>
Date: Wed, 05 Mar 2008 09:27:20 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: Eduardo Habkost <ehabkost@redhat.com>, Ian Campbell <ijc@hellion.org.uk>,
       Alexander van Heukelum <heukelum@mailshack.com>,
       Ingo Molnar <mingo@elte.hu>,
       Alexander van Heukelum <heukelum@fastmail.fm>, Andi Kleen <ak@suse.de>,
       Thomas Gleixner <tglx@linutronix.de>,
       Mark McLoughlin <markmc@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] use realmode code to reserve end-of-conventional-memory
 to 1MB
References: <20080224174605.GA21661@mailshack.com> <47C22568.1010405@zytor.com> <1203958478.20033.1239002461@webmail.messagingengine.com> <20080225170134.GA15839@elte.hu> <20080225180750.GA31054@mailshack.com> <20080228131341.GA25213@mailshack.com> <20080228132822.GA25278@mailshack.com> <1204233131.28798.12.camel@cthulhu.hellion.org.uk> <47C72432.3010606@zytor.com> <1204240609.28798.33.camel@cthulhu.hellion.org.uk> <20080305155930.GI20230@blackpad> <47CECC8D.9090507@goop.org>
In-Reply-To: <47CECC8D.9090507@goop.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge wrote:
>>
>> I am aware that it would take more work to tell all kernel code that it
>> shouldn't look for BIOS data on this region when running as a domU guest,
>> but it seems that it would be a better solution.
> 
> For the moment that's true, but we should be able to release those 
> pages.  On the other hand, there's been talk of making Xen hand out 
> memory in physically contigious 2M chunks, which means trying to unmap 
> 300k won't be possible or worthwhile.  I suspect real hardware will just 
> waste this memory too (it won't remap that 320k of ram to somewhere 
> else; it will just be shadowed) - which is nothing compared to chipsets 
> which will just throw away 1G to make space for PCI...
> 

Not that 384K is all that much to worry about, but you could just map 
memory from 2 MB upward, and set the kernel load address to 2 MB (which 
is good for performance anyway.)

There has been talk of making the default kernel load address 16 MB, to 
keep the DMA zone free.

	-hpa
