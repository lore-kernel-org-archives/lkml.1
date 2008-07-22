Return-Path: <linux-kernel-owner+w=401wt.eu-S1753382AbYGVEpx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753382AbYGVEpx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 00:45:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751419AbYGVEpo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 00:45:44 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:56471 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751309AbYGVEpo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 00:45:44 -0400
Subject: Re: [RFC] schedule_timeout_range()
From: David Woodhouse <dwmw2@infradead.org>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@elte.hu>, arjan@infradead.org
In-Reply-To: <200807221433.32412.nickpiggin@yahoo.com.au>
References: <1216695757.18980.16.camel@shinybook.infradead.org>
	 <200807221356.29892.nickpiggin@yahoo.com.au>
	 <1216699922.18980.66.camel@shinybook.infradead.org>
	 <200807221433.32412.nickpiggin@yahoo.com.au>
Content-Type: text/plain
Date: Tue, 22 Jul 2008 00:45:25 -0400
Message-Id: <1216701925.18980.75.camel@shinybook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-07-22 at 14:33 +1000, Nick Piggin wrote:
> The only thing I dislike about explicit times is that when a driver or
> someone doesn't _really_ know how much to specify. Do you say 10s, 100s?

This is true, but they certainly have a _better_ idea than we do. If the
individual callers can't even come up with an answer, how are we ever
going to come up with a generic policy that does the right thing? 

I really don't think that applying this kind of policy in generic code
is useful -- I'd like the callers to provide numbers even if they _do_
pull it out of their wossname.

The number they provide is the _maximum_ amount of time they should be
prepared to wait (let's assume for a moment that they stayed sober and
remembered Linux isn't a real-time kernel, so all guarantees are taken
with a pinch of salt. Let's not get bogged down in nomenclature).

In practice, they'll almost always get called before that maximum time
expires -- that's the whole _point_, of course. But we can't _invent_
that maximum in generic code; that's really up to the caller.

> Some upper bound would be nice, which basically would not have to ever
> fire by itself unless there is some CPU activity (so you don't have to
> set two timers as a bonus). After that, I wonder, perhaps some "maximum
> power savings value but not completely deferred"? Say give it a max of
> 30s? Or perhaps even that is not future-proof enough if we one day want
> to suspend most of the system between external IOs?

I _really_ don't think we want to go there. Let the caller set a maximum
amount of time they're prepared to wait, and that's it.

-- 
dwmw2

