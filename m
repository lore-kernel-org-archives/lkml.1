Return-Path: <linux-kernel-owner+w=401wt.eu-S1754439AbZAaIs7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754439AbZAaIs7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Jan 2009 03:48:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750953AbZAaIss
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 Jan 2009 03:48:48 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:45245
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1750856AbZAaIsr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Jan 2009 03:48:47 -0500
Date: Sat, 31 Jan 2009 00:48:43 -0800 (PST)
Message-Id: <20090131.004843.127193545.davem@davemloft.net>
To: akpm@linux-foundation.org
Cc: andi@firstfloor.org, roger.larsson@e-gatan.se,
       linux-kernel@vger.kernel.org, mingo@elte.hu, rml@tech9.net,
       pavel@ucw.cz, netdev@vger.kernel.org
Subject: Re: PROBLEM: in_atomic() misuse all over the place
From: David Miller <davem@davemloft.net>
In-Reply-To: <20090130214933.1b91ea3e.akpm@linux-foundation.org>
References: <20090130160316.7e53ef99.akpm@linux-foundation.org>
	<20090131055508.GD18453@one.firstfloor.org>
	<20090130214933.1b91ea3e.akpm@linux-foundation.org>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andrew Morton <akpm@linux-foundation.org>
Date: Fri, 30 Jan 2009 21:49:33 -0800

> Hang on.  You said
> 
>   That's typically for softirq vs non softirq, which is important for
>   the network stack.
> 
> that's what in_softirq() does.
> 
> Now, if networking is indeed using in_atomic() to detect
> are-we-inside-a-spinlock then networking is buggy.
> 
> If networking is _not_ doing that then we can safely switch it to
> in_sortirq() or in_interrupt().  And this would reenable the bug
> detection which networking's use of in_atomic() accidentally
> suppressed.

I think this is a reasonable conclusion, looking at the
gfp_any() users.

Feel free to change it to use in_softirq() and see what
explodes in -mm.  Report to me your findings :-)
