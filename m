Return-Path: <linux-kernel-owner+w=401wt.eu-S1756077AbYDJKhm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756077AbYDJKhm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2008 06:37:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753269AbYDJKhe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Apr 2008 06:37:34 -0400
Received: from one.firstfloor.org ([213.235.205.2]:54289 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752265AbYDJKhe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2008 06:37:34 -0400
Date: Thu, 10 Apr 2008 12:42:03 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Andi Kleen <andi@firstfloor.org>, astarikovskiy@suse.de,
       len.brown@intel.com, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: mpparse merge
Message-ID: <20080410104203.GE10019@one.firstfloor.org>
References: <20080410092947.GA32376@basil.nowhere.org> <20080410101408.GA12853@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080410101408.GA12853@elte.hu>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> the way Alexey did it is the safest way of doing unifications: keep it 
> simple and finegrained first, keep the more complex steps to later. We 

If he unifies dumbly like you seem to be fond of doing CONFIG_X86_32 when it 
should be CONFIG_FUNCTIONALITY is the wrong way. Can we agree on that?
The ifdef jungle is not any less from that, but at least it is clear
what the code does which makes further changes much easier. Basically
it preserves more information.

> try to stick to that even if there's a temporary jungle of #ifdefs. In a 
> related discussion (which was unfortunately private too so no URLs) you 
> suggested to Alexey to redesign the mp-parsing code first, then unify 
> it. That's the worst possible approach to unification and i advise 

The best approach depends on the code, not on a static rule of thumb. It
can be either depending on the code and the circumstances or often a mix of 
both. 

A good example where the static rule of thumb went totally wrong is Glauber's 
recent smpboot unification without fixing the state machine first.  I'm still 
not sure he has all the races out caused by that yet and I predict 
you'll have some debugging fun with that in the .26 cycle.

-Andi

