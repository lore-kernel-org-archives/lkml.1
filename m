Return-Path: <linux-kernel-owner+w=401wt.eu-S1764196AbXKTV3U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764196AbXKTV3U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2007 16:29:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763815AbXKTV27
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Nov 2007 16:28:59 -0500
Received: from mx1.redhat.com ([66.187.233.31]:57886 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763764AbXKTV25 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2007 16:28:57 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Oleg Nesterov <oleg@tv-sign.ru>
X-Fcc: ~/Mail/linus
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH -mm 1/2] kill PT_PTRACED
In-Reply-To: Oleg Nesterov's message of  Wednesday, 21 November 2007 00:20:32 +0300 <20071120212031.GA157@tv-sign.ru>
References: <20071120152133.GA4546@tv-sign.ru>
	<20071120210840.94CB726F8BE@magilla.localdomain>
	<20071120212031.GA157@tv-sign.ru>
X-Zippy-Says: Yes, but will I see the EASTER BUNNY in skintight leather at an
    IRON MAIDEN concert?
Message-Id: <20071120212851.EEB5026F8BE@magilla.localdomain>
Date: Tue, 20 Nov 2007 13:28:51 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> This is microoptimization, both ->signal and ->sighand are cleared at the same
> time in __exit_signal(), so we can check either. But we are using the value of
> ->sighand below, so it makes sense to read ->sighand, not ->signal.

Ok.  Anality would suggest doing that in a separate patch, though I don't
really care.

> Andrew, it is very easy to send the new patch to fix the code, but is it
> possible to fix the changelog somehow for the patch in -mm tree?

I'd prefer a comment in the code there making it explicit that ->sighand is
a "reaped yet" synchronization check (under tasklist_lock).


Thanks,
Roland
