Return-Path: <linux-kernel-owner+w=401wt.eu-S1761295AbXJaWKd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761295AbXJaWKd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2007 18:10:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752435AbXJaWKY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Oct 2007 18:10:24 -0400
Received: from iriserv.iradimed.com ([72.242.190.170]:40245 "EHLO iradimed.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752082AbXJaWKX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2007 18:10:23 -0400
Message-ID: <4728FD4C.2010509@cfl.rr.com>
Date: Wed, 31 Oct 2007 18:10:20 -0400
From: Phillip Susi <psusi@cfl.rr.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Nick Piggin <nickpiggin@yahoo.com.au>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "Kleen, Andi" <ak@suse.de>
Subject: Re: Is gcc thread-unsafe?
References: <200710251324.49888.nickpiggin@yahoo.com.au>
In-Reply-To: <200710251324.49888.nickpiggin@yahoo.com.au>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 31 Oct 2007 22:10:36.0559 (UTC) FILETIME=[DD2661F0:01C81C0A]
X-TM-AS-Product-Ver: SMEX-7.5.0.1243-5.0.1023-15518.001
X-TM-AS-Result: No--1.129900-5.000000-31
X-TM-AS-User-Approved-Sender: No
X-TM-AS-User-Blocked-Sender: No
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>             pushl   %ebp
>             movl    %esp, %ebp
>             cmpl    $0, 8(%ebp)
>             movl    $1, %eax
>             cmove   v, %eax        ; load (maybe)
>             movl    %eax, v        ; store (always)
>             popl    %ebp
>             ret

How is this even an optimization?  It looks SLOWER to me.  The 
conditional read wastes memory bandwidth sometimes, if the condition is 
true, and v isn't already in the cache.  The unconditional write wastes 
memory bandwidth ALL the time, and dirties/flushes caches, in addition 
to not being thread safe.

This SHOULD be using a conditional write instead of a conditional read 
and an unconditional write.


