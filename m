Return-Path: <linux-kernel-owner+w=401wt.eu-S1758211AbXJaPBo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758211AbXJaPBo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2007 11:01:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756648AbXJaPBf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Oct 2007 11:01:35 -0400
Received: from ms-smtp-04.nyroc.rr.com ([24.24.2.58]:38579 "EHLO
	ms-smtp-04.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756526AbXJaPBf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2007 11:01:35 -0400
Date: Wed, 31 Oct 2007 11:00:56 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Arjan van de Ven <arjan@infradead.org>
cc: LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Christoph Hellwig <hch@infradead.org>,
       Daniel Walker <dwalker@mvista.com>
Subject: Re: [PATCH] dump_stack on panic
In-Reply-To: <20071031071907.2d1b02ed@laptopd505.fenrus.org>
Message-ID: <Pine.LNX.4.58.0710311034410.16249@gandalf.stny.rr.com>
References: <1193788979.5623.43.camel@localhost.localdomain>
 <20071031071907.2d1b02ed@laptopd505.fenrus.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--
On Wed, 31 Oct 2007, Arjan van de Ven wrote:

> On Tue, 30 Oct 2007 20:02:59 -0400
> Steven Rostedt <rostedt@goodmis.org> wrote:
>
> > Is there any reason why we don't do a dump_stack on panic?
>
>
> panic() should never be used for kernel type of bugs, that's what
> BUG_ON() is for. panic() tends to be for "your cpu melted" and "you
> don't have a root fs".. nothing else.
>
> for both of those cases, a stack trace actually hurts because it
> scrolls the useful information off the screen instead.

Then we need to go and remove all the panics that are not needed and
replace them with Bugs.

I've had too many issues in development where I hit a panic and it gives
me nothing to tell me why.

At the very least, we should have a dump_stack in areas that are usually
caused by kernel bugs. For example, killing an interrupt handler.

-- Steve

