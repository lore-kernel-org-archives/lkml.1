Return-Path: <linux-kernel-owner+w=401wt.eu-S1753685AbYDORlg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753685AbYDORlg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2008 13:41:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751210AbYDORl1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Apr 2008 13:41:27 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:51555 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750853AbYDORl0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2008 13:41:26 -0400
Date: Tue, 15 Apr 2008 11:41:09 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andi Kleen <andi@firstfloor.org>, Peter Zijlstra <peterz@infradead.org>,
       Bart Van Assche <bart.vanassche@gmail.com>,
       Roland Dreier <rdreier@cisco.com>, Ingo Molnar <mingo@elte.hu>,
       Ingo Oeser <ioe-lkml@rameria.de>, Daniel Walker <dwalker@mvista.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Replace completions with semaphores
Message-ID: <20080415174109.GD9191@parisc-linux.org>
References: <4803AD91.5020001@firstfloor.org> <e2e108260804142318m19cf55c7p9973d3500de18120@mail.gmail.com> <1208242017.7053.4.camel@lappy> <e2e108260804150017u7d0aad8do9b26f7531a3a5226@mail.gmail.com> <1208249088.7124.7.camel@twins> <alpine.LFD.1.00.0804150907080.2879@woody.linux-foundation.org> <4804D779.6070907@firstfloor.org> <alpine.LFD.1.00.0804150952300.2879@woody.linux-foundation.org> <4804E29F.9060703@firstfloor.org> <alpine.LFD.1.00.0804151023350.2879@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.00.0804151023350.2879@woody.linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 15, 2008 at 10:26:21AM -0700, Linus Torvalds wrote:
> MUCH more trivial than this complex series.
> 
> (You may think that the "Replace completions with semaphores" patch is not 
> very complicated, but it *is* - it depends very intimately on the big 
> patch-series that basically turns semaphores into what completions are 
> now!)

complex?  big?  The big bits are dealing with renaming asm/semaphore.h to
linux/semaphore.h, and I've dropped those out now.  There's a couple of
up-front patches which add inclusions of asm/semaphore.h to files which
were missing it.  Then I add the new semaphore implementation, delete
the old ones, and add the down_timeout() and down_killable() functions.

> In other words, what makes me not like this is hat we first turn 
> semaphores into the generic code (which is largely what completions were: 
> just a special case of the generic semaphores!) and then turns completions 
> into these things. That just doesn't make any sense to me!

Blame me for not realising that completions were semaphores under a
different name.

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
