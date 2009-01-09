Return-Path: <linux-kernel-owner+w=401wt.eu-S1757608AbZAIVsK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757608AbZAIVsK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2009 16:48:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757087AbZAIVry
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Jan 2009 16:47:54 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:49238 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756926AbZAIVrx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2009 16:47:53 -0500
Subject: Re: [PATCH] Fix leap second message hang
From: Peter Zijlstra <peterz@infradead.org>
To: Chris Adams <cmadams@hiwaay.net>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20090109203110.GA1523360@hiwaay.net>
References: <20090109203110.GA1523360@hiwaay.net>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Fri, 09 Jan 2009 22:48:02 +0100
Message-Id: <1231537682.29452.4.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.2 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-01-09 at 14:31 -0600, Chris Adams wrote:
> Resending this outside the big long thread to make sure it gets added
> (it isn't critical right now but I don't want to forget it).

Best way to get stuff added is to CC the right people -- loose patches
get lost easily.

> The code to handle leap seconds printks an information message when the
> second is inserted or deleted.  It does this while holding xtime_lock.
> However, printk wakes up klogd, and in some cases, the scheduler tries
> to get the current kernel time, trying to get xtime_lock (which results
> in a deadlock).  This moved the printks outside of the lock.  It also
> adds a comment to not use printk while holding xtime_lock.

That should actually work these days, we don't actually do a direct wake
up anymore.

printk should work from all places, including holding rq->lock and
xtime_lock.
