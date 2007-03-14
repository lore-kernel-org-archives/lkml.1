Return-Path: <linux-kernel-owner+w=401wt.eu-S1751782AbXCNPo5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751782AbXCNPo5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2007 11:44:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751797AbXCNPo5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Mar 2007 11:44:57 -0400
Received: from smtp.osdl.org ([65.172.181.24]:42640 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751783AbXCNPoz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2007 11:44:55 -0400
Date: Wed, 14 Mar 2007 08:44:10 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Steven Rostedt <rostedt@goodmis.org>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Chris Wright <chrisw@sous-sol.org>,
       Rusty Russell <rusty@rustcorp.com.au>, Andi Kleen <ak@muc.de>,
       Glauber de Oliveira Costa <glommer@gmail.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: [PATCH 18/18] Straight file moves
In-Reply-To: <20070314051050.688415057@goodmis.org>
Message-ID: <Pine.LNX.4.64.0703140837300.9690@woody.linux-foundation.org>
References: <20070314050819.536207642@goodmis.org> <20070314051050.688415057@goodmis.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 14 Mar 2007, Steven Rostedt wrote:
>
> Here's a list of files that were moved from either i386 or x86_64 over
> to the arch/x86 directory.

Well, this means that your patch series doesn't actually *compile* as a 
series.

In other words, it's a pointless series, since the individual patches just 
generate a non-working kernel, until they have all been applied. 

So I really meant that each patch should be generated with "git diff -M", 
and you'd have a series of patches that are all working and move one part 
of the tree at a time (with Makefile changes etc integrated).

Also, in case you didn't notice, it's also perfectly fine to have  
"impure" moves, ie a move that not only renames something, but also 
changes something (commonly the comments at the top of the file). Maybe 
you simply didn't have anything like that, but I thought I'd mention it 
just in case you tried to avoid it on purpose.

The reason I really want the whole series to be compileable is that 
especially with a lot of people using "git bisect", if you have something 
that doesn't compile in the middle, not only does it show that the series 
wasn't a series, it also means that you cannot automate the bisect and you 
need manual intervention.

		Linus
