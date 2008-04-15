Return-Path: <linux-kernel-owner+w=401wt.eu-S1759452AbYDOSud@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759452AbYDOSud (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2008 14:50:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753206AbYDOSuZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Apr 2008 14:50:25 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:49664 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753806AbYDOSuZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2008 14:50:25 -0400
Date: Tue, 15 Apr 2008 12:50:08 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>, Peter Zijlstra <peterz@infradead.org>,
       Bart Van Assche <bart.vanassche@gmail.com>,
       Roland Dreier <rdreier@cisco.com>, Ingo Oeser <ioe-lkml@rameria.de>,
       Daniel Walker <dwalker@mvista.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Replace completions with semaphores
Message-ID: <20080415185008.GE9191@parisc-linux.org>
References: <1208195673.7164.2.camel@twins> <4803AD91.5020001@firstfloor.org> <e2e108260804142318m19cf55c7p9973d3500de18120@mail.gmail.com> <1208242017.7053.4.camel@lappy> <e2e108260804150017u7d0aad8do9b26f7531a3a5226@mail.gmail.com> <1208249088.7124.7.camel@twins> <alpine.LFD.1.00.0804150907080.2879@woody.linux-foundation.org> <4804D779.6070907@firstfloor.org> <alpine.LFD.1.00.0804150952300.2879@woody.linux-foundation.org> <20080415170556.GA16417@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080415170556.GA16417@elte.hu>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 15, 2008 at 07:05:56PM +0200, Ingo Molnar wrote:
> i very much agree with the "get rid of semaphores" argument - the reason 
> why i initially supported the "move to generic semaphores" step was 
> because i saw it basically as the precursor to full removal: it is the 
> removal of semaphores from all architectures - with a small generic 
> compatibility wrapper to handle the remaining few uses of semaphores.

Hm.  I thought you initially supported it because it deleted so much
code.  I don't want to go and add down_killable() to each architecture
again, and you were pretty enthusiastic about adding down_killable().

> i got thoroughly surprised by the "increase the scope of semaphores" 
> angle to the patchset though, and in hindsight i'd rather see neither of 
> those generalizations and see semaphores die a slow but sure natural 
> death than to see their prolongation :-/

I'm fully in favour of reducing the number of semaphore users, and
eventually eliminating them.  Arjan and I discussed a way to do that
just now ... I'll write some code, see how it looks.

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
