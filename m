Return-Path: <linux-kernel-owner+w=401wt.eu-S1752794AbYJUIKl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752794AbYJUIKl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2008 04:10:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751006AbYJUIK1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Oct 2008 04:10:27 -0400
Received: from www.tglx.de ([62.245.132.106]:48006 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751003AbYJUIKZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2008 04:10:25 -0400
Date: Tue, 21 Oct 2008 10:09:59 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Daniel Rosenthal <danielrosenthal@acm.org>
cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: behavior of hrtimers scheduled to expire in the past
In-Reply-To: <4b6fba110810201724v41d26dd8lc9abcba129599fd1@mail.gmail.com>
Message-ID: <alpine.LFD.2.00.0810210953120.3301@apollo>
References: <4b6fba110810201724v41d26dd8lc9abcba129599fd1@mail.gmail.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 20 Oct 2008, Daniel Rosenthal wrote:

> What is the intended behavior for an hrtimer that is scheduled to
> expire in the past?  I assumed that it would simply be scheduled to
> expire at the nearest available time in the future, but I wrote some
> scheduler code and it looks like hrtimers don't go off at all if they
> are not scheduled to go off at a time which is after rq->clock.  Is
> this the intended behavior or is this a bug?

That depends on the callback mode of the hrtimer. The standard ones
are scheduled to the softirq when they are already expired, but those
which are not allowed to run their callback in softirq context are
_not_ enqueued and the caller has to check, whether the timer is
active/enqueued after starting it.

Thanks,

	tglx

