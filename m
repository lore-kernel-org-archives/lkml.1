Return-Path: <linux-kernel-owner+w=401wt.eu-S1757597AbYDOHRW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757597AbYDOHRW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2008 03:17:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753405AbYDOHRN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Apr 2008 03:17:13 -0400
Received: from fg-out-1718.google.com ([72.14.220.153]:11962 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753265AbYDOHRL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2008 03:17:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=kV2wo3VNbcP7xJ8NCCR2ApTQEMxdKL5y3yVLInKWKCPeffWX8TSXu7ua0iubkAssIkxvUOcLwG4UxBPcBZfR5KvsJ60ikzqvYovvo2MVOlq64vuQUOY7xUNiBFQnSJUBKHP91tubXdoqHkJGC5ABX55e4QXKQk2lz/7OgidnkbY=
Message-ID: <e2e108260804150017u7d0aad8do9b26f7531a3a5226@mail.gmail.com>
Date: Tue, 15 Apr 2008 09:17:09 +0200
From: "Bart Van Assche" <bart.vanassche@gmail.com>
To: "Peter Zijlstra" <peterz@infradead.org>
Subject: Re: [PATCH] Replace completions with semaphores
Cc: "Andi Kleen" <andi@firstfloor.org>, "Roland Dreier" <rdreier@cisco.com>,
       "Ingo Molnar" <mingo@elte.hu>, "Matthew Wilcox" <matthew@wil.cx>,
       "Ingo Oeser" <ioe-lkml@rameria.de>,
       "Daniel Walker" <dwalker@mvista.com>, linux-kernel@vger.kernel.org,
       "Linus Torvalds" <torvalds@osdl.org>
In-Reply-To: <1208242017.7053.4.camel@lappy>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080411210022.GJ11962@parisc-linux.org>
	 <20080413125758.GQ11962@parisc-linux.org>
	 <20080414153928.GA22259@elte.hu> <adafxtoqvgh.fsf@cisco.com>
	 <1208190749.7375.10.camel@twins> <87d4osuy6r.fsf@basil.nowhere.org>
	 <1208195673.7164.2.camel@twins> <4803AD91.5020001@firstfloor.org>
	 <e2e108260804142318m19cf55c7p9973d3500de18120@mail.gmail.com>
	 <1208242017.7053.4.camel@lappy>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 15, 2008 at 8:46 AM, Peter Zijlstra <peterz@infradead.org> wrote:
>
> On Tue, 2008-04-15 at 08:18 +0200, Bart Van Assche wrote:
>  > Would it really be a good idea to give a synchronization concept that
>  > behaves exactly like a semaphore another name than "semaphore" ? The
>  > semaphore concept is well known and is taught in every computer
>  > science course.
>
>  Are the ramifications wrt priority inversion taught? Is it made clear
>  that its hard to validate because there is no clear resource owner?
>
>  Afaik, non of these subjects are touched upon in the CS-101 courses and
>  that is exactly the problem. So you can say they are not well know, they
>  are just widely misunderstood.
>
>  And yes, if there are more hand a very few such users it doesn't make
>  sense to keep them open coded.

Regarding semaphores and priority inversion: I have never recommended
the use of semaphores over mutexes, all I recommended is to keep the
name "semaphore" for something that behaves like a semaphore. There
might be better ways to discourage the use of the semaphore API, e.g.
letting the compiler print a warning every time a semaphore function
is called unless one or another #define has been enabled.

Regarding priority inheritance: does the above mean that you consider
priority inheritance as an optimal solution for realizing real-time
behavior in the kernel ? Are you aware of the fundamental problems
associated with priority inheritance ? These issues are well explained
in Victor Yodaiken's paper "Against priority inheritance". See also
http://www.linuxdevices.com/files/misc/yodaiken-july02.pdf .

Bart.
