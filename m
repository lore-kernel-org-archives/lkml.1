Return-Path: <linux-kernel-owner+w=401wt.eu-S932804AbXGWRx1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932804AbXGWRx1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2007 13:53:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761306AbXGWRxT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jul 2007 13:53:19 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:48224 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761102AbXGWRxT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2007 13:53:19 -0400
Date: Mon, 23 Jul 2007 10:52:53 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Satyam Sharma <ssatyam@cse.iitk.ac.in>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       David Howells <dhowells@redhat.com>,
       Nick Piggin <nickpiggin@yahoo.com.au>, Andi Kleen <ak@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 4/8] i386: bitops: Kill volatile-casting of memory
 addresses
In-Reply-To: <20070723160548.22137.66072.sendpatchset@cselinux1.cse.iitk.ac.in>
Message-ID: <alpine.LFD.0.999.0707231046140.3607@woody.linux-foundation.org>
References: <20070723160528.22137.84144.sendpatchset@cselinux1.cse.iitk.ac.in>
 <20070723160548.22137.66072.sendpatchset@cselinux1.cse.iitk.ac.in>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 23 Jul 2007, Satyam Sharma wrote:

> 
> [4/8] i386: bitops: Kill volatile-casting of memory addresses

This is wrong.

The "const volatile" is so that you can pass an arbitrary pointer. The 
only kind of abritraty pointer is "const volatile".

In other words, the "volatile" has nothing at all to do with whether the 
memory is volatile or not (the same way "const" has nothing to do with it: 
it's purely a C type *safety* issue, exactly the same way "const" is a 
type safety issue.

A "const" on a pointer doesn't mean that the thing it points to cannot 
change. When you pass a source pointer to "strlen()", it doesn't have to 
be constant. But "strlen()" takes a "const" pointer, because it work son 
constant pointers *too*.

Same deal here.

Admittedly this may be mostly historic, but regardless - the "volatiles" 
are right.

Using volatile on *data* is generally considered incorrect and bad taste, 
but using it in situations like this potentially makes sense.

Of course, if we remove all "volatiles" in data in the kernel (with the 
possible exception of "jiffies"), we can then remove them from function 
declarations too, but it should be done in that order.

			Linus
