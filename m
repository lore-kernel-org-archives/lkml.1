Return-Path: <linux-kernel-owner+w=401wt.eu-S1756232AbZFHOzK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756232AbZFHOzK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jun 2009 10:55:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754961AbZFHOzA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Jun 2009 10:55:00 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54443 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754633AbZFHOzA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jun 2009 10:55:00 -0400
Date: Mon, 8 Jun 2009 07:53:29 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Rusty Russell <rusty@rustcorp.com.au>
cc: Ingo Molnar <mingo@elte.hu>, Nick Piggin <npiggin@suse.de>,
       Jeremy Fitzhardinge <jeremy@goop.org>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Avi Kivity <avi@redhat.com>,
       Arjan van de Ven <arjan@infradead.org>, Gerd Knorr <kraxel@suse.de>
Subject: Re: [benchmark] 1% performance overhead of paravirt_ops on native
 kernels
In-Reply-To: <200906071023.04789.rusty@rustcorp.com.au>
Message-ID: <alpine.LFD.2.01.0906080749180.6847@localhost.localdomain>
References: <4A0B62F7.5030802@goop.org> <200906051416.19311.rusty@rustcorp.com.au> <alpine.LFD.2.01.0906050753550.6847@localhost.localdomain> <200906071023.04789.rusty@rustcorp.com.au>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sun, 7 Jun 2009, Rusty Russell wrote:
>
> "possible"?  You mean "acceptable".  Gray, not black and white.

I don't think we can possibly claim to support UP configurations if we 
don't patch. 

> 1) Where's the line?

"As good as we can make it". There is no line. There's "your code sucks so 
badly that it needs to get fixed, or we'll rip it out or disable it".

> 2) Where are we?  Does patching claw back 5% of the loss?  50%?  90%?

On some things, especially on P4, the lock overhead was tens of percent. 
Just a single locked instruction takes closer to two hundred instructions.

Of course, on those P4's, just kernel entry/exit is pretty high too (even 
with sysenter/exit), so I doubt you'll ever see something be 90% just 
because of that, unless it causes extra IO or other non-CPU issues.

		Linus
