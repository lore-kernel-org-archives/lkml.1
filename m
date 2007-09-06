Return-Path: <linux-kernel-owner+w=401wt.eu-S1758092AbXIFNWx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758092AbXIFNWx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2007 09:22:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756216AbXIFNWn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Sep 2007 09:22:43 -0400
Received: from main.gmane.org ([80.91.229.2]:50676 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756187AbXIFNWm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2007 09:22:42 -0400
Message-ID: <46DFFE1F.7060900@qumranet.com>
Date: Thu, 06 Sep 2007 16:18:23 +0300
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070719)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: Avi Kivity <public-avi-atKUWr5tajBWk0Htik3J/w@ciao.gmane.org>,
       public-linux-kernel-u79uwXL29TY76Z2rM5mHXA@ciao.gmane.org,
       public-linux-mm-Bw31MaZKKs3YtjvyW6yDsg@ciao.gmane.org,
       public-kvm-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@ciao.gmane.org,
       public-general-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@ciao.gmane.org
Subject: Re: [PATCH][RFC] pte notifiers -- support for external page	tables
References: <11890207643068-git-send-email-avi@qumranet.com> <p73myw09g5w.fsf@bingen.suse.de>
In-Reply-To: <p73myw09g5w.fsf@bingen.suse.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-TMDA-Confirmed: Thu Sep 6 15:22:34 CEST 2007
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org




[ugh, what happened to the cc-list?]

Andi Kleen wrote:
> Avi Kivity <avi-atKUWr5tajBWk0Htik3J/w@public.gmane.org> writes:
>   
>> pte notifiers are different from paravirt_ops: they extend the normal
>> page tables rather than replace them; and they provide high-level information
>> such as the vma and the virtual address for the driver to use.
>>     
>
> Sounds like a locking horror to me.  To do anything with page tables
> you need locks. Both for the kernel page tables and for your new tables.
>
> What happens when people add all
> things of complicated operations in these notifiers? That will likely
> happen and then everytime you change something in VM code they 
> will break. This has the potential to increase the cost of maintaining
> VM code considerably, which would be a bad thing.
>
> This is quite different from paravirt ops because low level pvops
> can typically run lockless by just doing some kind of hypercall directly.
> But that won't work for maintaining your custom page tables.
>   

This is a real problem.  I don't have a solution yet.

Obviously that needs to be addressed before something like this can go 
in; but as it's been done for the quadrics driver, presumably it is doable.

-- 
Any sufficiently difficult bug is indistinguishable from a feature.



