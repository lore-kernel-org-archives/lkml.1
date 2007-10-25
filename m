Return-Path: <linux-kernel-owner+w=401wt.eu-S1761448AbXJYHTA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761448AbXJYHTA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2007 03:19:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756804AbXJYHSv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Oct 2007 03:18:51 -0400
Received: from cantor.suse.de ([195.135.220.2]:60733 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755469AbXJYHSu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2007 03:18:50 -0400
From: Andi Kleen <ak@suse.de>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Subject: Re: Is gcc thread-unsafe?
Date: Thu, 25 Oct 2007 09:15:50 +0200
User-Agent: KMail/1.9.1
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
References: <200710251324.49888.nickpiggin@yahoo.com.au>
In-Reply-To: <200710251324.49888.nickpiggin@yahoo.com.au>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710250915.50675.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 25 October 2007 05:24, Nick Piggin wrote:

> Basically, what the gcc developers are saying is that gcc is
> free to load and store to any memory location, so long as it
> behaves as if the instructions were executed in sequence.

This case is clearly a bug, a very likely code pessimization.
I guess it wasn't intentional, just an optimization that is useful
for local register values doing too much.

> I guess that dynamically allocated memory and computed pointers
> are more difficult for gcc to do anything unsafe with, because
> it is harder to tell if a given function has deallocated the
> memory. 

Often accesses happen without function calls inbetween.
Also I think newer gcc (not 3.x) can determine if a pointer
"escapes" or not so that might not protect against it.

> Any thoughts?

We don't have much choice: If such a case is found it has to be marked
volatile or that particular compiler version be unsupported.

It might be useful to come up with some kind of assembler pattern
matcher to check if any such code is generated for the kernel
and try it with different compiler versions.

-Andi
