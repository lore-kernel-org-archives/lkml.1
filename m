Return-Path: <linux-kernel-owner+w=401wt.eu-S1752597AbYIBQCX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752597AbYIBQCX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2008 12:02:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751061AbYIBQCQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Sep 2008 12:02:16 -0400
Received: from casper.infradead.org ([85.118.1.10]:37726 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750744AbYIBQCP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2008 12:02:15 -0400
Date: Tue, 2 Sep 2008 09:02:11 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
       dwmw2@infradead.org, drepper@redhat.com, mingo@elte.hu, tglx@tglx.de
Subject: Re: [PATCH 11/13] hrtimer: turn hrtimers into range timers
Message-ID: <20080902090211.31ebced7@infradead.org>
In-Reply-To: <1220363227.8609.56.camel@twins>
References: <20080901160343.75a89ec9@infradead.org>
	<20080901161336.10a71c9f@infradead.org>
	<1220343732.8609.19.camel@twins>
	<20080902060517.60dca448@infradead.org>
	<1220363227.8609.56.camel@twins>
Organization: Intel
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 02 Sep 2008 15:47:07 +0200
Peter Zijlstra <peterz@infradead.org> wrote:

> > (it's not perfect by any means but it works ;-)
> 
> Gah, right. How about adding the following:
> 
> /*
>  * The immediate goal is minimizing wakeups, not running
>  * timers at the earliest interrupt after their soft expiration.
>  * This allows us to avoid using a Priority Search Tree,
>  * which can answer a stabbing querry for overlapping
>  * intervals and instead use the simple BST we already have.
>  * We don't add extra wakeups by delaying timers that are
>  * right-of a not yet expired timer, because that timer will
>  * have to trigger a wakeup anyway.
>  */

fair enough; I'll merge this in (I'm not going to resend the whole
series just for this redo though... maybe when there's more feedback
I'll roll it all up)
thanks!

-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
