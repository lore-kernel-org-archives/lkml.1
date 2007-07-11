Return-Path: <linux-kernel-owner+w=401wt.eu-S1758653AbXGKH0c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758653AbXGKH0c (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 03:26:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751616AbXGKH0Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 03:26:24 -0400
Received: from il.qumranet.com ([82.166.9.18]:36230 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751602AbXGKH0Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 03:26:24 -0400
Message-ID: <46948626.6050308@qumranet.com>
Date: Wed, 11 Jul 2007 10:26:30 +0300
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Satyam Sharma <satyam.sharma@gmail.com>
CC: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       KVM <kvm-devel@lists.sourceforge.net>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 17/20] SMP: Implement on_cpu()
References: <11838956891287-git-send-email-avi@qumranet.com>	 <p73lkdqzpdm.fsf@bingen.suse.de> <4691D9C1.4050309@qumranet.com>	 <20070709071640.GB10864@one.firstfloor.org>	 <46920270.3080309@qumranet.com> <46921BE9.4040801@qumranet.com>	 <a781481a0707091224s3fb1a2acr6d3ccce091480f61@mail.gmail.com>	 <4693211D.4040406@qumranet.com>	 <a781481a0707100222k4f204ed8gfd4823bc21b7bf25@mail.gmail.com>	 <46936766.20900@qumranet.com> <a781481a0707101707w121da1b7hc82dc0e3638e4570@mail.gmail.com>
In-Reply-To: <a781481a0707101707w121da1b7hc82dc0e3638e4570@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Satyam Sharma wrote:
>
> And I think what's proposed is:
>
> 1. Change smp_call_function() semantics, to run given function
> on _all_ CPUs (thus getting rid of the on_each_cpu() "mistake")
>
> 2. Resort to (most probably implement another function?) using
> smp_call_function_mask() or flags appropriately to also serve
> the use cases where we need to run a given function on all
> _other_ CPUs
>
> Does this pointless/gratuitous code-churn really make sense?
> Definitely not to me ...


It's not proposed.  Andi mentioned it in passing.  The only churn is in 
this thread.

>
> [ For the _single() case we now have on_cpu() as you originally
> proposed, which I definitely like and fills the other gap in the API. ]
>
> So I still don't quite understand what is the need to change existing
> semantics of smp_call_function{_single} in the first place.
>

I imagine Andi's motivation was that most uses benefit from this change, 
and the rest don't suffer.  It's better not to have a proliferation of 
ever-so-similar APIs.


-- 
error compiling committee.c: too many arguments to function

