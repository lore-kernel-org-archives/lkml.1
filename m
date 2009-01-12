Return-Path: <linux-kernel-owner+w=401wt.eu-S1757397AbZALUvF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757397AbZALUvF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2009 15:51:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754096AbZALUuw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Jan 2009 15:50:52 -0500
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:59332 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754078AbZALUuv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2009 15:50:51 -0500
Message-Id: <1231793450.26049.1294379841@webmail.messagingengine.com>
X-Sasl-Enc: nbAd8+PfHdxoctpQzEQUVc3bk5V7NE9f2H8aZ0sGV2Dx 1231793450
From: "Alexander van Heukelum" <heukelum@fastmail.fm>
To: "Peter Zijlstra" <peterz@infradead.org>, "Ingo Molnar" <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, "Andi Kleen" <ak@suse.de>,
       "Dhaval Giani" <dhaval@linux.vnet.ibm.com>
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="UTF-8"
MIME-Version: 1.0
X-Mailer: MessagingEngine.com Webmail Interface
References: <1220990178-29773-15-git-send-email-heukelum@fastmail.fm> 
 <1220990178-29773-16-git-send-email-heukelum@fastmail.fm> 
 <1220990178-29773-17-git-send-email-heukelum@fastmail.fm> 
 <1220990178-29773-18-git-send-email-heukelum@fastmail.fm> 
 <1220990178-29773-19-git-send-email-heukelum@fastmail.fm> 
 <1220990178-29773-20-git-send-email-heukelum@fastmail.fm> 
 <1220990178-29773-21-git-send-email-heukelum@fastmail.fm> 
 <1220990178-29773-22-git-send-email-heukelum@fastmail.fm> 
 <1220990178-29773-23-git-send-email-heukelum@fastmail.fm> 
 <1231780911.4371.196.camel@laptop> <20090112183904.GC12249@elte.hu> 
 <1231785815.4371.205.camel@laptop>
Subject: Re: [PATCH 22/24] i386: add TRACE_IRQS_OFF for the nmi
In-Reply-To: <1231785815.4371.205.camel@laptop>
Date: Mon, 12 Jan 2009 21:50:50 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 12 Jan 2009 19:43:35 +0100, "Peter Zijlstra"
<peterz@infradead.org> said:
> On Mon, 2009-01-12 at 19:39 +0100, Ingo Molnar wrote:
> > * Peter Zijlstra <peterz@infradead.org> wrote:
> > 
> > > On Tue, 2008-09-09 at 21:56 +0200, heukelum@fastmail.fm wrote:
> > > > From: Alexander van Heukelum <heukelum@fastmail.fm>
> > > > 
> > > > At this point interrupts are off, so let's inform the tracing
> > > > code of that fact before calling into C.
> > > 
> > > Sorry but this is an obvious dud, lockdep (and thus the irq state
> > > tracer) aren't nmi safe.
> > > 
> > > Ingo, please revert, as people are already seeing lockdep warnings due
> > > to this.
> > 
> > done - reverted it in tip/x86/urgent, see the commit below. Is that all 
> > that we need, wasnt there a 64-bit side done too?
> 
> I had a _very_ quick peek but couldn't fine one, Alexander, does your
> memory go back that far? :-)

Git helped a bit, I must admit. The 64-bit version does not include
TRACE_IRQS_ON/TRACE_IRQS_OFF in the nmi handler. The comment above
"ENTRY(paranoid_exit)" in entry_64.S should be updated, though. That
code is not used for NMIs.

The revert is obviously the correct thing to do, but a comment would
not hurt here either.

Greetings,
    Alexander
-- 
  Alexander van Heukelum
  heukelum@fastmail.fm

-- 
http://www.fastmail.fm - Access your email from home and the web

