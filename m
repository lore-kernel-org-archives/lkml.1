Return-Path: <linux-kernel-owner+w=401wt.eu-S1759743AbYIALzN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759743AbYIALzN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2008 07:55:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753431AbYIALy7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Sep 2008 07:54:59 -0400
Received: from relay2.sgi.com ([192.48.171.30]:47803 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753380AbYIALy7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2008 07:54:59 -0400
Message-ID: <48BBD7C8.4070005@sgi.com>
Date: Mon, 01 Sep 2008 13:53:44 +0200
From: Jes Sorensen <jes@sgi.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: David Miller <davem@davemloft.net>, travis@sgi.com, mingo@elte.hu,
       Alan.Brunelle@hp.com, tglx@linutronix.de, rjw@sisk.pl,
       linux-kernel@vger.kernel.org, kernel-testers@vger.kernel.org,
       akpm@linux-foundation.org, arjan@linux.intel.com, rusty@rustcorp.com.au
Subject: Re: [Bug #11342] Linux 2.6.27-rc3: kernel BUG at mm/vmalloc.c - bisected
References: <20080826072220.GB31876@elte.hu> <20080826.004607.253712060.davem@davemloft.net> <48B4542A.1050004@sgi.com> <20080826.134535.193703558.davem@davemloft.net> <48B7EEA2.7090300@sgi.com> <alpine.LFD.1.10.0808290909020.3300@nehalem.linux-foundation.org>
In-Reply-To: <alpine.LFD.1.10.0808290909020.3300@nehalem.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> 
> On Fri, 29 Aug 2008, Jes Sorensen wrote:
>> I have only tested this on ia64, but it boots, so it's obviously
>> perfect<tm> :-)
> 
> Well, it probably boots because it doesn't really seem to _change_ much of 
> anything.

Hi Linus,

I realize that, but as I have been doing this work on ia64, I didn't
want to mess too much with the x86 code. The ia64 part of the patch does
change things :-)

If someone with more x86 knowledge would want to try and make that part
of the patch better, and more importantly test it, I'd be quite keen on
helping out.

Cheers,
Jes


> Things like this:
> 
> 	-static inline void arch_send_call_function_ipi(cpumask_t mask)
> 	+static inline void arch_send_call_function_ipi(cpumask_t *mask)
> 	 {
> 	-       smp_ops.send_call_func_ipi(mask);
> 	+       smp_ops.send_call_func_ipi(*mask);
> 	 }
> 
> will still do that stack allocation at the time of the call. You'd have to 
> pass the thing all the way down as a pointer..
> 
> 			Linus
> 

