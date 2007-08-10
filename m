Return-Path: <linux-kernel-owner+w=401wt.eu-S941358AbXHJTRu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S941358AbXHJTRu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2007 15:17:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936275AbXHJTRm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Aug 2007 15:17:42 -0400
Received: from mx1.redhat.com ([66.187.233.31]:34594 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935286AbXHJTRl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2007 15:17:41 -0400
Message-ID: <46BCB9C5.4050103@redhat.com>
Date: Fri, 10 Aug 2007 16:17:25 -0300
From: Glauber de Oliveira Costa <gcosta@redhat.com>
User-Agent: Thunderbird 1.5.0.12 (X11/20070719)
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: Glauber de Oliveira Costa <glommer@gmail.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, lguest@ozlabs.org,
       linux-kernel@vger.kernel.org, chrisw@sous-sol.org,
       anthony@codemonkey.ws, Steven@smtp2.linux-foundation.org,
       akpm@linux-foundation.org, virtualization@lists.linux-foundation.org,
       mingo@elte.hu
Subject: Re: [PATCH 23/25] [PATCH] paravirt hooks for arch initialization
References: <11865467522495-git-send-email-gcosta@redhat.com>	 <11865468394005-git-send-email-gcosta@redhat.com>	 <11865468431616-git-send-email-gcosta@redhat.com>	 <200708081144.04119.ak@suse.de> <46BB5258.8040609@goop.org>	 <20070809190303.214e5457@the-village.bc.nu> <5d6222a80708101108y62ebfa26n9f47bfc52b48f4a8@mail.gmail.com> <46BCB3A5.8090504@goop.org>
In-Reply-To: <46BCB3A5.8090504@goop.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge escreveu:
> Glauber de Oliveira Costa wrote:
>> On 8/9/07, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
>>   
>>>> What's the EBDA actually used for?  The only place which seems to use
>>>> ebda_addr is in the e820 code to avoid that area as RAM.
>>>>       
>>> It belongs to the firmware.
>>>     
>> Wouldn't it be better, then, to just skip this step unconditionally if
>> we are running a paravirtualized guest? What do we from doing it?
>>   
> 
> It's better to make discover_ebda() quietly cope with a missing ebda for
> whatever reason.  We could add an explicit interface to paravirt_ops to
> handle this one little corner, but it isn't very important, not very
> general and really its just clutter.  Its much better to have things
> cope with being virtualized quietly on their own rather than hit them
> all with the pv_ops hammer.   pv_ops is really for things where the
> hypervisor-specific code really has to get actively involved.
> 
I think the idea you gave me earlier of using probe_kernel_address could
work. Xen/lguest/put_yours_here that won't use an ebda would then have 
to unmap the page, to make sure a read would fault.


