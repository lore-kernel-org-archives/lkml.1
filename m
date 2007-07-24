Return-Path: <linux-kernel-owner+w=401wt.eu-S936107AbXGXJtf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936107AbXGXJtf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2007 05:49:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764818AbXGXJtZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jul 2007 05:49:25 -0400
Received: from gate.crashing.org ([63.228.1.57]:58354 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762447AbXGXJtY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2007 05:49:24 -0400
Subject: Re: [PATCH 4/8] i386: bitops: Kill volatile-casting of memory
	addresses
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Satyam Sharma <ssatyam@cse.iitk.ac.in>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       David Howells <dhowells@redhat.com>,
       Nick Piggin <nickpiggin@yahoo.com.au>, Andi Kleen <ak@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <alpine.LFD.0.999.0707231046140.3607@woody.linux-foundation.org>
References: <20070723160528.22137.84144.sendpatchset@cselinux1.cse.iitk.ac.in>
	 <20070723160548.22137.66072.sendpatchset@cselinux1.cse.iitk.ac.in>
	 <alpine.LFD.0.999.0707231046140.3607@woody.linux-foundation.org>
Content-Type: text/plain
Date: Tue, 24 Jul 2007 19:49:03 +1000
Message-Id: <1185270544.5439.252.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> The "const volatile" is so that you can pass an arbitrary pointer. The 
> only kind of abritraty pointer is "const volatile".
> 
> In other words, the "volatile" has nothing at all to do with whether the 
> memory is volatile or not (the same way "const" has nothing to do with it: 
> it's purely a C type *safety* issue, exactly the same way "const" is a 
> type safety issue.
> 
> A "const" on a pointer doesn't mean that the thing it points to cannot 
> change. When you pass a source pointer to "strlen()", it doesn't have to 
> be constant. But "strlen()" takes a "const" pointer, because it work son 
> constant pointers *too*.

However... What about that:

 - This "volatile" will allow to pass pointers to volatile data to the
bitops.

 - Most users of "volatile" in the kenrel (except maybe jiffies) are
bogus

 - Thus let's remove it -as a type safety thing- to catch more of those
stupid volatile that shouldn't be ? :-)

Besides, as Nick pointed out, it prevents some valid optimizations.

Cheers,
Ben.

