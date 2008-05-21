Return-Path: <linux-kernel-owner+w=401wt.eu-S933348AbYEUCC3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933348AbYEUCC3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 22:02:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757488AbYEUCCU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 22:02:20 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33082 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756402AbYEUCCT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 22:02:19 -0400
Date: Tue, 20 May 2008 19:02:08 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Al Viro <viro@ZenIV.linux.org.uk>
cc: Harvey Harrison <harvey.harrison@gmail.com>,
       Al Viro <viro@ftp.linux.org.uk>, mchehab@infradead.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] or51132.c: unaligned
In-Reply-To: <20080521011843.GH28946@ZenIV.linux.org.uk>
Message-ID: <alpine.LFD.1.10.0805201856200.3081@woody.linux-foundation.org>
References: <E1JycGV-0004yJ-SP@ZenIV.linux.org.uk> <1211330472.5915.228.camel@brick> <20080521004548.GD28946@ZenIV.linux.org.uk> <alpine.LFD.1.10.0805201752230.3081@woody.linux-foundation.org> <20080521011843.GH28946@ZenIV.linux.org.uk>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 21 May 2008, Al Viro wrote:
> 
> FWIW, I wonder how they really compare on misaligned and whether it would
> make sense for gcc to try and generate a single load on targets that are
> known to allow that...

It would almost certainly help on x86. The cost of an unaligned integer 
access that doesn't cross a cache-fetch boundary (8 bytes on older CPU's, 
16 or 32 bytes on newer ones) is zero, last I saw. IOW, there are 
misaligned cases that have a higher cost, but they are pretty rare, and 
especially so with small data and modern CPU's.

So no disadvantage for 95% of all cases, and the advantage of doing just a 
single instruction, rather than four (2 zero-extending loads, a shift and 
an add/or, with data dependencies on most of them).

			Linus
