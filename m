Return-Path: <linux-kernel-owner+w=401wt.eu-S1752852AbYIJAuY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752852AbYIJAuY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2008 20:50:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751208AbYIJAuM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Sep 2008 20:50:12 -0400
Received: from gw.goop.org ([64.81.55.164]:57879 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751125AbYIJAuL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2008 20:50:11 -0400
Message-ID: <48C719C0.6060201@goop.org>
Date: Tue, 09 Sep 2008 17:50:08 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Yinghai Lu <yhlu.kernel@gmail.com>
CC: "Eric W. Biederman" <ebiederm@xmission.com>, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: TARGET_CPUS in assign_irq_vector
References: <48C6F913.1010509@goop.org>	 <86802c440809091554y349366fdu8e4ca59797ab4205@mail.gmail.com>	 <48C70ADC.8060004@goop.org> <86802c440809091726y4db8f85eg2d478b482862c5f9@mail.gmail.com>
In-Reply-To: <86802c440809091726y4db8f85eg2d478b482862c5f9@mail.gmail.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yinghai Lu wrote:
> On Tue, Sep 9, 2008 at 4:46 PM, Jeremy Fitzhardinge <jeremy@goop.org> wrote:
>   
>> Yinghai Lu wrote:
>>     
>>> target_cpus is the cpus that could be possible to used to take vector
>>> and process that irq. so at least it should be online.
>>>
>>>       
>> Would it be wrong to make it possible_cpu_mask?
>>
>>     
> it is wrong

What happens if you online a new cpu and migrate the irq to it?  Does it
get allocated a new vector?

I'm using create_irq() as a general irq and vector allocation mechanism
for Xen interrupts.  I'd like to be able to allocate a vector across all
possible cpus so I can bind Xen event channels to vectors.  Should I: 1)
add a create_irq_cpus() which takes a cpu mask rather than defaulting to
TARGET_CPUS, 2) modify struct genapic to insert by own target_cpus(), 
3) give up because the idea is fundamentally ill-conceived, or 4)
something else?

Thanks,
    J

