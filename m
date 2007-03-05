Return-Path: <linux-kernel-owner+w=401wt.eu-S1752145AbXCEIuO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752145AbXCEIuO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2007 03:50:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752149AbXCEIuO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Mar 2007 03:50:14 -0500
Received: from mis011-1.exch011.intermedia.net ([64.78.21.128]:9264 "EHLO
	mis011-1.exch011.intermedia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752145AbXCEIuM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2007 03:50:12 -0500
Message-ID: <45EBD9BC.4030801@qumranet.com>
Date: Mon, 05 Mar 2007 10:50:04 +0200
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 1.5.0.9 (X11/20070212)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Jens Axboe <jens.axboe@oracle.com>, Pavel Machek <pavel@ucw.cz>,
       Adrian Bunk <bunk@stusta.de>, Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "Michael S. Tsirkin" <mst@mellanox.co.il>,
       Thomas Gleixner <tglx@linutronix.de>, linux-pm@lists.osdl.org,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       Daniel Walker <dwalker@mvista.com>, Len Brown <lenb@kernel.org>
Subject: Re: [patch] KVM: T60 resume fix
References: <20070227111515.GA4271@kernel.dk> <20070301093450.GA8508@elte.hu> <20070301104117.GA22788@elte.hu> <20070301145204.GA25304@elte.hu> <Pine.LNX.4.64.0703011536450.12485@woody.linux-foundation.org> <20070302072100.GB30634@elte.hu> <20070302080441.GA12785@elte.hu> <20070302102018.GA11549@elte.hu> <20070302102216.GA13575@elte.hu> <45E93012.4000100@qumranet.com> <20070305082251.GA23366@elte.hu>
In-Reply-To: <20070305082251.GA23366@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 05 Mar 2007 08:50:11.0000 (UTC) FILETIME=[488BA380:01C75F03]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Avi Kivity <avi@qumranet.com> wrote:
>
>   
>>> my T60 laptop does not resume correctly due to KVM attempting to 
>>> send an IPI to a CPU that might be down (or not up yet). (Doing so 
>>> also triggers the send_IPI_mask_bitmask() warning in 
>>> arch/i386/kernel/smp.c, line 732.)
>>>
>>> with this fix applied my laptop does not hang during resume.
>>>
>>> [ KVM will have to disable/enable virtualization on the CPU itself 
>>>  that goes down / comes up, not via an IPI sent from the requesting
>>> CPU. ]
>>>       
>
>   
>> That is already CPU_ONLINE in my tree (and in the pull request sent to 
>> Linus a couple of days ago).
>>     
>
> that solves the resume problem - but doesnt solve the CPU_DEAD issue of 
> sending an IPI to an already offline CPU. Might be a better idea to do 
> it in CPU_DOWN_PREPARE? (and then to also add a CPU_DOWN_FAILED branch?)
>
> 	

Mainline now has DOWN_PREPARE and UP_CANCELED calling 
->hardware_disable(), and ONLINE calling ->hardware_enabled().  What 
tree are you looking at?

[but I do see the need for DOWN_FAILED now. Off to find a resumable 
machine...]


-- 
Do not meddle in the internals of kernels, for they are subtle and quick to panic.

