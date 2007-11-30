Return-Path: <linux-kernel-owner+w=401wt.eu-S935097AbXK3P02@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935097AbXK3P02 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2007 10:26:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752944AbXK3P0N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Nov 2007 10:26:13 -0500
Received: from smtpoutm.mac.com ([17.148.16.77]:54697 "EHLO smtpoutm.mac.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753301AbXK3P0M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2007 10:26:12 -0500
In-Reply-To: <20071130143445.GA2310@csclub.uwaterloo.ca>
References: <474EAD18.6040408@stellatravel.co.uk> <20071130143445.GA2310@csclub.uwaterloo.ca>
Mime-Version: 1.0 (Apple Message framework v752.2)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <53ADBDBF-9B65-441E-B867-D68DE48ABD64@mac.com>
Cc: Ben Crowhurst <Ben.Crowhurst@stellatravel.co.uk>,
       linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 7bit
From: Kyle Moffett <mrmacman_g4@mac.com>
Subject: Re: Kernel Development & Objective-C
Date: Fri, 30 Nov 2007 10:26:03 -0500
To: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
X-Mailer: Apple Mail (2.752.2)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Nov 30, 2007, at 09:34:45, Lennart Sorensen wrote:
> On Thu, Nov 29, 2007 at 12:14:16PM +0000, Ben Crowhurst wrote:
>> Has Objective-C ever been considered for kernel development?
>
> Doesn't objective C essentially require a runtime to provide a lot  
> of the features of the language?  If it does (as I suspect) then it  
> is totally unsiatable for kernel development.
>
> That and object oriented languages in general are badly designed  
> and a bad idea.  Having not used objective C I have no idea if it  
> qualifies as badly designed or not.  Certainly C++ and java are  
> both very badly designed.

Objective-C is actually a pretty minimal wrapper around C; it was  
originally implemented as a C preprocessor.  It generally does not  
have any kind of memory management, garbage collection, or anything  
else (although typically a "runtime" will provide those features).   
There are no first-class exceptions, so there would be nothing to  
worry about there (the exceptions used in GUI programs are built  
around the setjmp/longjmp primitives).  Objective-C is also almost  
completely backwards-compatible with C, much more so than C++ ever  
was.  As far as the runtime goes the kernel would be expected to  
write its own, the same way that it implements "kmalloc()" as part of  
a "C runtime".  Since the runtime itself never does any implicit  
memory allocation, I think it would conceivably even be relatively  
safe for kernel usage.

With that said, there is a significant performance penalty as all  
Objective-C method calls are looked up symbolically at runtime for  
every single call.  For GUI programs where large chunks of the code  
are event-loops and not performance-sensitive that provides a huge  
amount of extra flexibility.  In the kernel though, there are many  
codepaths where *every* *single* instruction counts; that could be a  
serious performance hit.

Cheers,
Kyle Moffett

