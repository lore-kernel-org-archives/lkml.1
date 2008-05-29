Return-Path: <linux-kernel-owner+w=401wt.eu-S1758951AbYE2Ses@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758951AbYE2Ses (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2008 14:34:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759124AbYE2Sef
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 May 2008 14:34:35 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45750 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759106AbYE2See (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2008 14:34:34 -0400
Date: Thu, 29 May 2008 11:29:41 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: David Howells <dhowells@redhat.com>
cc: akpm@linux-foundation.org, bunk@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/6] Werror: Fix casting wrong size integer to pointer
In-Reply-To: <20080529181726.5396.79336.stgit@warthog.procyon.org.uk>
Message-ID: <alpine.LFD.1.10.0805291123320.2958@woody.linux-foundation.org>
References: <20080529181726.5396.79336.stgit@warthog.procyon.org.uk>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 29 May 2008, David Howells wrote:
>
> Fix casting wrong size integer to pointer.  Smaller integers must be cast to
> unsigned long then cast to a pointer.

I do not want to apply patches that just hide compiler warnings.

Quite frankly, if the code looks worse (and it does), and the warning is 
valid (and in two out of three cases it *was*), then the patch that 
removes the warning is MUCH MUCH WORSE than the warning ever was!

So in this case, the "sis_mm.c" change *may* be fine. I say *may*, because 
quite frankly, I don't think it really is. The cast looks like it may be 
at the wrogn point, and the code really looks like crap. In particular, 
notice how the "sis_sman_mm_allocate()" and "sis_sman_mm_free()" (and 
the _offset() function) use casts on different sides of the '~' operator.

I think that thing should be cleaned up to actually have a function to 
turn the offset into a pointer and back. Because right now it looks buggy.

The two changes to drivers/message/i2o/i2o_config.c are utter shit. That 
warning should *stay*, because it damn well is correct. The code simply 
doesn't work right on a 64-bit architecture, and even has a comment to 
that effect.

Don't send patches to remove warnings. Send patches to FIX PROBLEMS. If 
the warning goes away because the _problem_ went away, it's a good patch. 
Otherwise the patch is just a total piece of crap.

			Linus
