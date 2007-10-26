Return-Path: <linux-kernel-owner+w=401wt.eu-S1762392AbXJZSQc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762392AbXJZSQc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2007 14:16:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753677AbXJZSQY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Oct 2007 14:16:24 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:44104 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753252AbXJZSQX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2007 14:16:23 -0400
Date: Fri, 26 Oct 2007 11:14:17 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
cc: Bart Van Assche <bart.vanassche@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Haley <aph@redhat.com>
Subject: Re: Is gcc thread-unsafe?
In-Reply-To: <20071026190856.18510fc4@the-village.bc.nu>
Message-ID: <alpine.LFD.0.999.0710261111390.30120@woody.linux-foundation.org>
References: <e2e108260710260729x4603211cgb68d7434ce1e54e9@mail.gmail.com>
 <e2e108260710260740k27210c4fu2f75d5fb31ccdccc@mail.gmail.com>
 <alpine.LFD.0.999.0710260814570.30120@woody.linux-foundation.org>
 <alpine.LFD.0.999.0710260917500.30120@woody.linux-foundation.org>
 <e2e108260710261007n118186b5geb3a48094638497f@mail.gmail.com>
 <20071026190856.18510fc4@the-village.bc.nu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 26 Oct 2007, Alan Cox wrote:
>
> > non-volatile variables. But for asm statements this can be solved by
> > adding memory to the list of clobbered registers -- this will prevent
> > any reordering of manipulations of non-volatile variables and asm
> > statements.
> 
> IFF the processor doesn't reorder them in hardware, which on some
> processors is visibly out of order when viewed from an I/O device or
> another CPU.
> 
> You can stop the compiler but not the CPU - and some processors will
> certainly speculatively load across conditionals, reorder writes etc

Well, when we're talking inline asms used for locking, the whole point of 
using inline asm is exactly that you cannot do it with regular accesses, 
and have to add architecture-specific barriers. If the user gets that 
wrong, then it's a user problem, not a compiler issue.

So that's not the problem. The problem is if the compiler then does other 
things wrong *despite* the inline asm being correct. 

				Linus
