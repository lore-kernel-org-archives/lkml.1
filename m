Return-Path: <linux-kernel-owner+w=401wt.eu-S1762663AbXJZRZ5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762663AbXJZRZ5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2007 13:25:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754660AbXJZRZq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Oct 2007 13:25:46 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:37497 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753785AbXJZRZp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2007 13:25:45 -0400
Date: Fri, 26 Oct 2007 10:25:29 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Andrew Haley <aph@redhat.com>
cc: Bart Van Assche <bart.vanassche@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Is gcc thread-unsafe?
In-Reply-To: <18210.8170.598519.439148@zebedee.pink>
Message-ID: <alpine.LFD.0.999.0710261020250.30120@woody.linux-foundation.org>
References: <e2e108260710260729x4603211cgb68d7434ce1e54e9@mail.gmail.com>
 <e2e108260710260740k27210c4fu2f75d5fb31ccdccc@mail.gmail.com>
 <alpine.LFD.0.999.0710260814570.30120@woody.linux-foundation.org>
 <alpine.LFD.0.999.0710260917500.30120@woody.linux-foundation.org>
 <e2e108260710261007n118186b5geb3a48094638497f@mail.gmail.com>
 <18210.8170.598519.439148@zebedee.pink>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 26 Oct 2007, Andrew Haley wrote:
>
> Bart Van Assche writes:
> 
>  > Andrew, do you know whether gcc currently contains any optimization
>  > that interchanges the order of accesses to non-volatile variables
>  > and function calls ?
> 
> It sure does.

Note that doing so is perfectly fine.

But only for local variables that haven't had their addresses taken.

The fact is, those kinds of variables really *are* special. They are 
provably not accessible from any other context, and re-ordering them (or 
doing anything AT ALL to them - the most basic and very important 
optimization is caching them in registers, of course) is always purely an 
internal compiler issue.

But if gcc re-orders functions calls with *other* memory accesses, gcc is 
totally broken. I doubt it does that. It would break on all but the most 
trivial programs, and it would be a clear violation of even standard C.

HOWEVER: the bug that started this thread isn't even "reordering 
accesses", it's *adding* accesses that weren't there (and please don't mix 
this up with "volatile", since volatile is a totally unrelated issue and 
has nothing what-so-ever to do with anything).

		Linus
