Return-Path: <linux-kernel-owner+w=401wt.eu-S1756057AbXKNKX7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756057AbXKNKX7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2007 05:23:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751091AbXKNKXw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Nov 2007 05:23:52 -0500
Received: from E23SMTP04.au.ibm.com ([202.81.18.173]:54850 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751020AbXKNKXv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2007 05:23:51 -0500
Message-ID: <473ACCBE.9010308@in.ibm.com>
Date: Wed, 14 Nov 2007 15:53:58 +0530
From: Srinivasa Ds <srinivasa@in.ibm.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20071022)
MIME-Version: 1.0
To: Abhishek Sagar <sagar.abhishek@gmail.com>
CC: linux-kernel@vger.kernel.org, prasanna@in.ibm.com, davem@davemloft.net,
       anil.s.keshavamurthy@intel.com, Jim Keniston <jkenisto@us.ibm.com>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Subject: Re: [PATCH][RFC] kprobes: Add user entry-handler in kretprobes
References: <47389BEB.1000901@gmail.com> <863e9df20711121039t5352a993xc9eeb6bfea123805@mail.gmail.com> <863e9df20711130247g45d3d541j10c76434e9c65b00@mail.gmail.com> <473AAA75.2050900@in.ibm.com> <863e9df20711140049q3ad486ben7ace2edab0a2ca41@mail.gmail.com>
In-Reply-To: <863e9df20711140049q3ad486ben7ace2edab0a2ca41@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Abhishek Sagar wrote:

> the entry handler is called with the appropriate return instance. I
> haven't put any explicit "match" test here for ri. The reason is that
> the correct ri would be passed to both the entry and return handlers
> as trampoline_handler() explicitly matches them to the correct task.
> Note that all pending return instances of a function are chained in
> LIFO order. S the entry-handler which gets called last, should have
> its return handler called first (in case of multiple pending return
> instances).
> 

No, eventhough return instances are chained in an order, order of execution of 
return handler entirely depends on which process returns first(some process may 
return from 2 line of the function and some process may return from last line
of the function). So entry_handler() which gets executed last doesn't guarantee 
that its return handler will be executed first(because it took a lot time
to return).

So only thing to match the entry_handler() with its return_handler() is 
return probe instance(ri)'s address, which user has to take care explicitly 
(Hence I feel sol a) would be nice). 

Thanks
 Srinivasa DS

