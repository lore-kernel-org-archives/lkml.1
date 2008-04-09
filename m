Return-Path: <linux-kernel-owner+w=401wt.eu-S1756662AbYDIQQd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756662AbYDIQQd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2008 12:16:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753096AbYDIQQ0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Apr 2008 12:16:26 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:35141 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752733AbYDIQQZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2008 12:16:25 -0400
Subject: Re: lockdep, false positive ?
From: Peter Zijlstra <peterz@infradead.org>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: benh@kernel.crashing.org, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel list <linux-kernel@vger.kernel.org>
In-Reply-To: <20080409120803.ZZRA012@mailhub.coreip.homeip.net>
References: <1207714607.9079.22.camel@pasglop>
	 <1207734281.4110.46.camel@twins>
	 <20080409120803.ZZRA012@mailhub.coreip.homeip.net>
Content-Type: text/plain
Date: Wed, 09 Apr 2008 18:16:10 +0200
Message-Id: <1207757770.24562.14.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-04-09 at 12:11 -0400, Dmitry Torokhov wrote:
> Hi Peter,
> 
> On Wed, Apr 09, 2008 at 11:44:41AM +0200, Peter Zijlstra wrote:
> > 
> > Yes, if both locks are of the same class it will report this. Lockdep
> > does lock chain validation on classes, never on individual locks.
> > 
> > A class usually consists of all locks that share the lock init site; but
> > there are ways to explicity set another class.
> > 
> > In case of these recursions we have helpers like spin_lock_nested(&lock,
> > subclass) that allow you to annotate these. These sub-classes must then
> > always be taken in the same order; subclass < 8.
> > 
> > In this case its probably easier to explicity set a class, as the
> > nesting is not exposed to the input layer, so it doesn't know about it.
> > 
> 
> Is there a way in lockdep to mark all instances of a given lock as distinct?
> I'd rather do that in input core once and be done with it.

Nope. Do you have a lot of nesting in input?

> Also another question I've been meaning to ask - we have lockdep annotations
> in serio code and they work fine first time around but if you reload
> psmouse module lockdep will barf if you have SYnaptics touchpad with
> pass-through port. What gives?

Could you show me one such dump? - And yes, module reloading is a tad
tricky, but it should work for a while.

