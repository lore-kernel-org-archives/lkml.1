Return-Path: <linux-kernel-owner+w=401wt.eu-S1757322AbXIWPeP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757322AbXIWPeP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Sep 2007 11:34:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754568AbXIWPeD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Sep 2007 11:34:03 -0400
Received: from mx1.redhat.com ([66.187.233.31]:41803 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754486AbXIWPeC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Sep 2007 11:34:02 -0400
Date: Sun, 23 Sep 2007 11:32:43 -0400
From: Dave Jones <davej@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Arjan van de Ven <arjan@infradead.org>,
       Cyrill Gorcunov <gorcunov@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: memset as memzero
Message-ID: <20070923153243.GE8127@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Arjan van de Ven <arjan@infradead.org>,
	Cyrill Gorcunov <gorcunov@gmail.com>,
	LKML <linux-kernel@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Ingo Molnar <mingo@elte.hu>
References: <20070922083355.GA7226@cvg> <20070922124659.741cca42@laptopd505.fenrus.org> <alpine.LFD.0.999.0709221149480.16478@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.0.999.0709221149480.16478@woody.linux-foundation.org>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 22, 2007 at 11:53:53AM -0700, Linus Torvalds wrote:
 > 
 > 
 > On Sat, 22 Sep 2007, Arjan van de Ven wrote:
 > > 
 > > it doesn't add value.... memset with a constant 0 is just as fast
 > > (since the compiler knows it's 0) than any wrapper around it, and the
 > > syntax around it is otherwise the same.
 > 
 > Indeed.
 > 
 > The reason we have "clear_page()" is not because the value we're writing 
 > is constant - that doesn't really help/change anything at all. We could 
 > have had a "fill_page()" that sets the value to any random byte, it's just 
 > that zero is the only value that we really care about.
 > 
 > So the reason we have "clear_page()" is because the *size* and *alignment* 
 > is constant and known at compile time, and unlike the value you write, 
 > that actually matters.
 > 
 > So "memzero()" would never really make sense as anything but a syntactic 
 > wrapper around "memset(x,0,size)". 

There is one useful argument for memzero (or bzero to give it its proper
name), and that's that it's impossible to screw up.
I'm still amazed at how many times I see

	memset (x,size,0);

in various code. So much so, that my editor highlights it now to spot
it during code review.  As does my mail client.  To be on the safe
side, I also have a cron job grepping for it in my ~/Mail/commits
for all the projects I'm interested in.

It's tragic really just how easy it is to screw it up.

	Dave

-- 
http://www.codemonkey.org.uk
