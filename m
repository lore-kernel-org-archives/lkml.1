Return-Path: <linux-kernel-owner+w=401wt.eu-S1751274AbZHRS6j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751274AbZHRS6j (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Aug 2009 14:58:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751132AbZHRS6i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Aug 2009 14:58:38 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:55564 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750900AbZHRS6i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Aug 2009 14:58:38 -0400
Date: Tue, 18 Aug 2009 14:58:38 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
cc: Zhaolei <zhaolei@cn.fujitsu.com>, Frederic Weisbecker <fweisbec@gmail.com>,
       Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH] Add timer-source of walltime for ftrace
In-Reply-To: <20090818215620.A63C.A69D9226@jp.fujitsu.com>
Message-ID: <alpine.DEB.2.00.0908181454090.727@gandalf.stny.rr.com>
References: <alpine.DEB.2.00.0907272218480.30108@gandalf.stny.rr.com> <4A89213C.5090109@cn.fujitsu.com> <20090818215620.A63C.A69D9226@jp.fujitsu.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 19 Aug 2009, KOSAKI Motohiro wrote:

> > +u64 notrace trace_clock_walltime(void)
> > +{
> > +	u32 remainder;
> > +	return base_walltime.tv_sec + div_u64_rem(
> > +			trace_clock() + base_walltime.tv_nsec,
> > +			NSEC_PER_SEC, &remainder);
> > +}
> 
> Why do we need calculate walltime at ring-buffer recordng phase?
> IOW, Why can't we calculate this at displaing time?

Right! We should have something like this:

	return (u64)base_walltime.tv_sec * NSEC_PER_SEC +
		trace_clock() + base_walltime.tv_nsec;

And then we could divide it out later.

And then we could even show more fields in the output and not limit 
ourselves to seconds.

-- Steve

