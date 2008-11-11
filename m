Return-Path: <linux-kernel-owner+w=401wt.eu-S1754806AbYKKR3T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754806AbYKKR3T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2008 12:29:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752126AbYKKR3L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Nov 2008 12:29:11 -0500
Received: from smtp-out.google.com ([216.239.45.13]:16369 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751594AbYKKR3K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2008 12:29:10 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=subject:from:to:cc:in-reply-to:references:content-type:
	organization:date:message-id:mime-version:x-mailer:content-transfer-encoding;
	b=I8W8rn4whb29kzws7gOh4vVWWuxzZF8Vkxdi4iNSTjKF9AYmJHzaHYJft328mrKd8
	Sw/NHm4TytxY4pz0CsqTw==
Subject: Re: [PATCH] for account_group_exec_runtime(), make sure ->signal
	can't be freed under rq->lock
From: Frank Mayhar <fmayhar@google.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Oleg Nesterov <oleg@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>, adobriyan@gmail.com,
       Doug Chapman <doug.chapman@hp.com>, Roland McGrath <roland@redhat.com>,
       linux-kernel@vger.kernel.org
In-Reply-To: <20081111171659.GB8201@elte.hu>
References: <20081110143930.GA28275@redhat.com>
	 <20081111103532.GA8869@elte.hu>
	 <1226423423.4444.8.camel@bobble.smo.corp.google.com>
	 <20081111171659.GB8201@elte.hu>
Content-Type: text/plain
Organization: Google, Inc.
Date: Tue, 11 Nov 2008 09:28:02 -0800
Message-Id: <1226424482.4444.13.camel@bobble.smo.corp.google.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-11-11 at 18:16 +0100, Ingo Molnar wrote:
> * Frank Mayhar <fmayhar@google.com> wrote:
> 
> > On Tue, 2008-11-11 at 11:35 +0100, Ingo Molnar wrote:
> > > * Oleg Nesterov <oleg@redhat.com> wrote:
> > > > The patch is ugly, but I don't see the better fix for now. Needs the 
> > > > review from Peter/Ingo.
> > > this is indeed too ugly, and if we do it we'll get both this ugliness 
> > > and the CPU loop upstream forever. Frank, if you dont have time to fix 
> > > this code, then i guess the best thing is to do the full revert that 
> > > Peter sent.
> > 
> > Well, at the moment I'm up to my armpits in alligators.  That said, 
> > we're going to have to pull in this code regardless, ugliness and 
> > all, since we're guaranteed to run into the soft lockup bug 
> > otherwise.  This means that I'll have strong incentive to come back 
> > and readdress the fix to remove the ugliness and address Peter's 
> > concerns.  I have no idea when that will be, however.
> 
> well, we wont leave buggy code in there for .28 - it could trigger 
> anytime on any SMP box, no matter how narrow the race is.

Sorry, by "we" I meant where I work, not the Linux kernel folks; I guess
it's as true for you guys as it is for us but I'm certainly not in a
position to speak for you.

> I've picked up the spin-wait fix from Oleg, because it fixes the bug. 
> But we should really fix the fundamental issues here too.

Agreed, in spades.  In fact I plan to track this internally so it
doesn't fall off my radar.
-- 
Frank Mayhar <fmayhar@google.com>
Google, Inc.

