Return-Path: <linux-kernel-owner+w=401wt.eu-S1759629AbYHAVsS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759629AbYHAVsS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2008 17:48:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752113AbYHAVr7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Aug 2008 17:47:59 -0400
Received: from relay1.sgi.com ([192.48.171.29]:58209 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751355AbYHAVr6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2008 17:47:58 -0400
Message-ID: <4893848C.5070303@sgi.com>
Date: Fri, 01 Aug 2008 14:47:56 -0700
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: Yinghai Lu <yhlu.kernel@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, hpa <hpa@zytor.com>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/16] dyn_array and nr_irqs support v2
References: <1217583464-28494-1-git-send-email-yhlu.kernel@gmail.com> <m1iqukwjjg.fsf@frodo.ebiederm.org>
In-Reply-To: <m1iqukwjjg.fsf@frodo.ebiederm.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric W. Biederman wrote:
> Yinghai Lu <yhlu.kernel@gmail.com> writes:
> 
>> Please check dyn_array support for x86
> 
> YH you have not addressed any of my core concerns and this exceeds my review limit.
> Unfortunately I don't feel like this is a productive process.
> 
> My core concerns are:
> - You have not separated out and separately pushed the regression patch.  So that we can
>   fix the current rc release.  Simply tuning NR_IRQS is all I feel comfortable with for
>   fixing things in the post merge window period.
> 
> - The generic code has no business with dealing with NR_IRQS sized arrays.
>   Since we don't have a generic problem I don't see why we should have a generic dyn_array solution.
> 
> - The dyn_array infrastructure does not provide for per numa node allocation of
>   irq_desc structures, limiting NUMA scalability.
> 
> - You appear to be papering over problems instead of digging in and actually fixing them.
> 
> YH  Here is what I was suggesting when the topic of killing NR_IRQs came up a week or so
> ago.
> http://lkml.org/lkml/2008/7/10/439
> http://lkml.org/lkml/2008/7/10/532
> 
> Which essentially boils down to:
> - Removing NR_IRQS from the non-irq infrastructure code.
> - Add a config option for architectures that are not going to use an array
> - In the genirq code have a lookup function that goes from irq number to irq_desc *.
> 
> The rest we should be able to handle in a arch dependent fashion.
> 
> When we are done we should be able to create a stable irq number for msi interrupts
> that is something like:  bus:dev:fun:vector_no which is 8+5+3+12=28 bits long.
> 
> Eric

Hi Eric,

Small nit:  domain:bus:dev:fun:vector_no ... an SGI UV system can have potentially
512 domains (NODES), each having some # of busses.  

Thanks,
Mike
