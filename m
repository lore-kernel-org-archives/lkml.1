Return-Path: <linux-kernel-owner+w=401wt.eu-S1758669AbYCUPLx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758669AbYCUPLx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2008 11:11:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752288AbYCUPLq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Mar 2008 11:11:46 -0400
Received: from wine.ocn.ne.jp ([122.1.235.145]:55522 "EHLO smtp.wine.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750873AbYCUPLp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2008 11:11:45 -0400
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org
Subject: Re: use of preempt_count instead of in_atomic() at leds-gpio.c
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <20080320192719.6a32386e.akpm@linux-foundation.org>
	<Pine.LNX.4.44L0.0803202301140.16520-100000@netrider.rowland.org>
	<20080320201723.b87b3732.akpm@linux-foundation.org>
In-Reply-To: <20080320201723.b87b3732.akpm@linux-foundation.org>
Message-Id: <200803220011.CEC82820.QSOtJOVFFHFMLO@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.50 PL2]
X-Accept-Language: ja,en
Date: Sat, 22 Mar 2008 00:11:40 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

> > In short, you are saying that there is _no_ reliable way to determine
> > am-i-called-from-inside-spinlock.
> 
> That's correct.

So, it is impossible to know whether I am inside a spinlock or not.
OK. That's not what I want to do.

I want to make sure that my code (not a device driver) is called only from a context
where use of down()/mutex_lock()/kmalloc(GFP_KERNEL)/get_user_pages()/kmap() etc. are permitted.
Is "if (in_atomic()) return;" check a correct method for avoiding deadlocks
when my code was accidentally called from a context
where use of down()/mutex_lock()/kmalloc(GFP_KERNEL)/get_user_pages()/kmap() etc. are not permitted?
I'm assuming that in_atomic() returns nonzero whenever scheduling is not permitted.

Regards.
