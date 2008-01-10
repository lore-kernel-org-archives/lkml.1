Return-Path: <linux-kernel-owner+w=401wt.eu-S1759962AbYAJQts@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759962AbYAJQts (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2008 11:49:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756626AbYAJQtl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jan 2008 11:49:41 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:34550 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755677AbYAJQtk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2008 11:49:40 -0500
Date: Thu, 10 Jan 2008 08:49:07 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, akpm@linux-foundation.org
Subject: Re: Make the 32 bit Frame Pointer backtracer fall back to
 traditional
Message-ID: <20080110084907.37279d36@laptopd505.fenrus.org>
In-Reply-To: <alpine.LFD.1.00.0801100816450.3148@woody.linux-foundation.org>
References: <20080109220508.686bbda4@laptopd505.fenrus.org>
	<alpine.LFD.1.00.0801100816450.3148@woody.linux-foundation.org>
Organization: Intel
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.12.1; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 10 Jan 2008 08:36:57 -0800 (PST)
Linus Torvalds <torvalds@linux-foundation.org> wrote:

> 
> 
> On Wed, 9 Jan 2008, Arjan van de Ven wrote:
> >
> > +	if (valid_stack_ptr(tinfo, frame, sizeof(*frame)))
> > +		while (valid_stack_ptr(tinfo, frame,
> > sizeof(*frame))) {
> 
> Why?
> 
> Why not just make this something like the appended instead?
> 
> This is *totally* untested, but the basic notion is very simple:
> start off using the frame pointer until it is no longer valid (for
> any reason - whether the return address is corrupt, or the next frame
> info is bad), and update the stack pointer a you go.
> 
> When we've run out of frame pointers, we then scan any remaining
> stack the oldfashioned way, regardless of what happened. No
> unnecessary conditionals that will just mean that we don't show
> enough of the stack if *part* of it is corrupt.
> 
> The code is simpler and more robust (assuming it works - as
> mentioned, I didn't actually test it, so there may be some stupid
> thinko there).
> 

there's still a bug in it (not updating EBP) and I need to check how 
it reacts if you have 2 stacks, and you're at the end of the first stack,
and EBP now jumps to the second stack (correctly).

Anyway I'll test this after (or maybe during) my meeting, and fix the EBP return bug
and see how to deal with the 2 stack issue
