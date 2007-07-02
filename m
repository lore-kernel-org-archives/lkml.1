Return-Path: <linux-kernel-owner+w=401wt.eu-S1758329AbXGBPwY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758329AbXGBPwY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2007 11:52:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752701AbXGBPwR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jul 2007 11:52:17 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:35845 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752331AbXGBPwR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2007 11:52:17 -0400
Date: Mon, 2 Jul 2007 08:51:38 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Andi Kleen <ak@suse.de>
cc: Stephen Hemminger <shemminger@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: blink driver power saving
In-Reply-To: <200707020159.51200.ak@suse.de>
Message-ID: <alpine.LFD.0.98.0707020843100.9434@woody.linux-foundation.org>
References: <20070701125035.3f54d8b0@oldman> <200707012329.52918.ak@suse.de>
 <alpine.LFD.0.98.0707011511120.3323@woody.linux-foundation.org>
 <200707020159.51200.ak@suse.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 2 Jul 2007, Andi Kleen wrote:
>
> It's not intended for normal kernels. It's a debugging feature.
> It's not intended for normal kernels. It's a debugging feature.
> It's not intended for normal kernels. It's a debugging feature.
> 
> Got it now?

You seem to have some reading comprehension problems.

The email you replied to had this in it:

  "No, its main problem is that PEOPLE SHOULD NOT USE IT, but it sounds cool,
   so people end up configuring the damn thing even though they shouldn't."

but you seem to not have understood.

Got it now?

> > It hangs machines when it tries to blink.
> 
> Yes, there seem to be more buggy keyboard controllers
> around than I anticipated. Very sad that IBM couldn't even
> get such a simple thing right.

Well, I would say that the driver itself is buggy. It calls 
"panic_blink()", which doesn't do the proper locking (i8042_lock is 
required to protect the accesses, otherwise you can have different 
entities in the system writing to the command ports concurrently, and get 
random stuff happening!).

So blaming "buggy keyboard controllers" is pretty damn silly of you, when 
the real problem is that the driver is broken. That interface is for 
panic, and panic *only*, and avoids the lock exactly because it's meant to 
be called when the system is basically dead.

Why did you think that function is called "panic_blink()"?

Yes, it could be hidden by making it do the buggy calls less often. That 
makes some machines work, but it doesn't change the fact that it would 
still be buggy.

> Anyways, Stephen's patch just doesn't make sense: 
> he clearly didn't understand the code at all. Before you
> apply it and cripple it better drop the driver completely.

I think I will have to.

		Linus
