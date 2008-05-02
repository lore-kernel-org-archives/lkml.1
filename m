Return-Path: <linux-kernel-owner+w=401wt.eu-S935082AbYEBM5r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935082AbYEBM5r (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2008 08:57:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759837AbYEBM5g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 May 2008 08:57:36 -0400
Received: from mail.ocs.com.au ([203.34.248.175]:17718 "EHLO mail.ocs.com.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760364AbYEBM5f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2008 08:57:35 -0400
X-Greylist: delayed 406 seconds by postgrey-1.27 at vger.kernel.org; Fri, 02 May 2008 08:57:34 EDT
X-Mailer: exmh version 2.7.2 01/07/2005 (debian 1:2.7.2-12) with nmh-1.2
From: Keith Owens <kaos@ocs.com.au>
To: paulmck@linux.vnet.ibm.com
cc: Nick Piggin <npiggin@suse.de>, Jens Axboe <jens.axboe@oracle.com>,
       linux-kernel@vger.kernel.org, peterz@infradead.org,
       linux-arch@vger.kernel.org, jeremy@goop.org, mingo@elte.hu
Subject: Re: [PATCH 1/10] Add generic helpers for arch IPI function calls 
In-reply-to: Your message of "Fri, 02 May 2008 05:29:55 MST."
             <20080502122955.GB15522@linux.vnet.ibm.com> 
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Date: Fri, 02 May 2008 22:50:44 +1000
Message-ID: <27854.1209732644@ocs10w>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Paul E. McKenney" (on Fri, 2 May 2008 05:29:55 -0700) wrote:
>OK -- for some reason, I was thinking that it was illegal to
>invoke smp_call_function() with irqs disabled...
>
>Ah, I see it -- smp_call_function_mask() says:
>
> * You must not call this function with disabled interrupts or from a
> * hardware interrupt handler or from a bottom half handler.
>
>So we have no problem with smp_call_function, then.
>
>OK, so smp_call_function() -can- be invoked with irqs disabled?
>Hmmm...  I will give this some thought.

Doing any smp_call_function with interrupts disabled is a potential
deadlock.  See http://lkml.org/lkml/2004/5/2/116.

