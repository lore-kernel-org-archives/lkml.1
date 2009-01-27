Return-Path: <linux-kernel-owner+w=401wt.eu-S1756569AbZA0RvR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756569AbZA0RvR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2009 12:51:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755698AbZA0RvA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Jan 2009 12:51:00 -0500
Received: from gw.goop.org ([64.81.55.164]:42387 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755614AbZA0RvA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2009 12:51:00 -0500
Message-ID: <497F4982.8060103@goop.org>
Date: Tue, 27 Jan 2009 09:50:58 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Brian Gerst <brgerst@gmail.com>
CC: Tejun Heo <htejun@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: unified percpu stuff
References: <497E5F76.10301@goop.org>	 <73c1f2160901262157g3d281e62nb3ebafe01ab1dfe4@mail.gmail.com>	 <497EB698.30509@goop.org> <73c1f2160901270435t5623b0d8tbf832b1f8a575b2e@mail.gmail.com>
In-Reply-To: <73c1f2160901270435t5623b0d8tbf832b1f8a575b2e@mail.gmail.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Brian Gerst wrote:
>> BTW, does the initial cpu0 percpu area get reallocated and moved during
>> boot, or does cpu0 keep using the same memory forever?
>>     
>
> It is reallocated in setup_per_cpu_areas().
>   

Hm, OK.  What's the reason we need to move cpu 0's percpu area?  Its 
always seemed a bit awkward.

Once it has been moved, how can I find the address of a variable in the 
original boot-time cpu 0 percpu area?  There's a couple of pages which 
Xen will have marked RO which need to be made RW if they're being freed 
back into the kernel pool.  Currently I use per_cpu_var(gdt_page), but 
guess that's a small offset rather than a directly usable address.

Thanks,
    J
