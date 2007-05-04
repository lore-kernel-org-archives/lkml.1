Return-Path: <linux-kernel-owner+w=401wt.eu-S1767019AbXEDVHb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767019AbXEDVHb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2007 17:07:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1766626AbXEDVHa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 May 2007 17:07:30 -0400
Received: from smtp-outbound-1.vmware.com ([65.113.40.141]:45833 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1767019AbXEDVH2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2007 17:07:28 -0400
Message-ID: <463B9FEA.8@vmware.com>
Date: Fri, 04 May 2007 14:04:42 -0700
From: Zachary Amsden <zach@vmware.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070221)
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: Petr Vandrovec <petr@vmware.com>, nigel@nigel.suspend2.net,
       Arjan van de Ven <arjan@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: VMware, x86_64 and 2.6.21.
References: <1177998147.8981.16.camel@nigel.suspend2.net>	<1178031475.3448.0.camel@laptopd505.fenrus.org>	<1178032456.13953.12.camel@nigel.suspend2.net>	<46385A18.30804@vmware.com> <m1slacu88z.fsf@ebiederm.dsl.xmission.com>	<463B4C5C.1000507@vmware.com> <m13b2cpcr2.fsf@ebiederm.dsl.xmission.com>
In-Reply-To: <m13b2cpcr2.fsf@ebiederm.dsl.xmission.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Eric W. Biederman wrote:

> Is this linux running on vmware or vmware running on linux?
>   

VMware running on Linux.

> This sounds like playing with fire.  Although I suppose you could do it generally
> by making software irqs trigger a general protection fault.
>   

Better if you don't have to; the whole point of the swirq is faster 
handling.

> What we currently have is: 
> int assign_irq_vector(int irq, cpumask_t);
>
> It has a number of interesting properties such as you can change
> the vector assignment at runtime, and we can migrate the irq
> between cpus.
>   

Yes, but still not enough here.

> That is pretty much the architecture we have to support msi.  Although
> irq != vector not even at a fixed offset.
>   

It doesn't look like you can safely allocate an exclusive IRQ here 
however - the IO-APIC could always route a hardware IRQ for the matching 
vector right on top of you unless, I'm misreading something.

Zach
