Return-Path: <linux-kernel-owner+w=401wt.eu-S1754840AbYCKJZg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754840AbYCKJZg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2008 05:25:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751096AbYCKJZ2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Mar 2008 05:25:28 -0400
Received: from tomts10-srv.bellnexxia.net ([209.226.175.54]:60516 "EHLO
	tomts10-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750929AbYCKJZ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2008 05:25:28 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AgEFAI/s1UdMQWoK/2dsb2JhbACBWKld
Date: Tue, 11 Mar 2008 05:25:24 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: [PATCH] x86 Fix test_poke for vmalloced pages
Message-ID: <20080311092524.GA30220@Krystal>
References: <20080310183653.GA4482@Krystal> <20080311090947.GG25110@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20080311090947.GG25110@elte.hu>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 05:24:42 up 11 days,  5:35,  4 users,  load average: 5.33, 2.44,
	1.47
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Ingo Molnar (mingo@elte.hu) wrote:
> 
> * Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca> wrote:
> 
> > The shadow vmap for DEBUG_RODATA kernel text modification uses 
> > virt_to_page to get the pages from the pointer address.
> > 
> > However, I think vmalloc_to_page would be required in case the page is 
> > used for modules.
> > 
> > Since only the core kernel text is marked read-only, use 
> > kernel_text_address() to make sure we only shadow map the core kernel 
> > text, not modules.
> 
> actually, i think we should mark module text readonly too.
> 

I agree, then we would have to use vmalloc_to_page. I guess it has not
been done before because there wasn't any mechanism such as text_poke
available.

Mathieu

> 	Ingo

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
