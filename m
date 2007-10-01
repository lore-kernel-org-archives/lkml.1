Return-Path: <linux-kernel-owner+w=401wt.eu-S1754608AbXJAHdn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754608AbXJAHdn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2007 03:33:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753272AbXJAHd3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Oct 2007 03:33:29 -0400
Received: from il.qumranet.com ([82.166.9.18]:45880 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753130AbXJAHd2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2007 03:33:28 -0400
Message-ID: <4700A649.9020700@qumranet.com>
Date: Mon, 01 Oct 2007 09:48:25 +0200
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070719)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Ingo Molnar <mingo@elte.hu>, Andy Whitcroft <apw@shadowen.org>,
       linux-kernel@vger.kernel.org
Subject: Re: checkpatch and kernel/sched.c
References: <20070928105345.GC18163@shadowen.org>	<20071001064448.GA4239@elte.hu> <20071001003007.4e90143b.akpm@linux-foundation.org>
In-Reply-To: <20071001003007.4e90143b.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (firebolt.argo.co.il [0.0.0.0]); Mon, 01 Oct 2007 09:48:25 +0200 (IST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
>> this is actually a false positive - as the debug code constructs a 
>> printk output _without_ \n. So the script should check whether there's 
>> any \n in the printk string - if there is none, do not emit a warning. 
>> (if you implement that then i think it can remain a warning and does not 
>> need to move to CHECK.)
>>     
>
> Yeah, it does that sometimes.  I don't think it's fixable within the scope
> of checkpatch.  It needs to check whether some preceding printk which might
> not even be in the patch has a \n:
>
> 	printk(KERN_ERR "foo");
> 	<100 lines of whatever>
> +	printk("bar\n");
>
> we're screwed...
>
>   

Isn't that broken on SMP (or with preemption) anyway?

-- 
Do not meddle in the internals of kernels, for they are subtle and quick to panic.

