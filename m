Return-Path: <linux-kernel-owner+w=401wt.eu-S1750961AbXCZF1b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750961AbXCZF1b (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2007 01:27:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752145AbXCZF1b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Mar 2007 01:27:31 -0400
Received: from mail.gmx.net ([213.165.64.20]:40317 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750961AbXCZF1a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2007 01:27:30 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX19dAwwsVFld435ac189w95kyOVOAdsauo+GGscLai
	Oxw4vHZ3k4vSHf
Subject: Re: [patch] sched: accurate user accounting
From: Mike Galbraith <efault@gmx.de>
To: Al Boldi <a1426z@gawab.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <200703260811.18236.a1426z@gawab.com>
References: <200703260811.18236.a1426z@gawab.com>
Content-Type: text/plain
Date: Mon, 26 Mar 2007 07:27:30 +0200
Message-Id: <1174886850.7040.71.camel@Homer.simpson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-03-26 at 08:11 +0300, Al Boldi wrote:

> > +       /* Sanity check. It should never go backwards or ruin accounting
> > */ +       if (unlikely(now < p->last_ran))
> > +               goto out_set;
> 
> If sched_clock() goes backwards, why not fix it, instead of hacking around 
> it?

When tasks change cpu, timestamp correction is attempted, but isn't
perfect (perfection: submit patch to read remote clock - people likely
toast poor submitter's buns very thoroughly).  Timewarps happen, and
even on Intel processors there seems to be very small difference in TSCs
in the same package.  (that's what instrumentation here said must be
true, possible booboos aside)

	-Mike

