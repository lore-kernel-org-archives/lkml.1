Return-Path: <linux-kernel-owner+w=401wt.eu-S1751197AbZL1OCi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751197AbZL1OCi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Dec 2009 09:02:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751026AbZL1OCh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Dec 2009 09:02:37 -0500
Received: from casper.infradead.org ([85.118.1.10]:58388 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750892AbZL1OCh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Dec 2009 09:02:37 -0500
Subject: Re: perf: counter and event question
From: Peter Zijlstra <peterz@infradead.org>
To: Tim Blechmann <tim@klingt.org>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <4B38AE1D.8060703@klingt.org>
References: <4B389391.8050303@klingt.org> <1261999573.7135.83.camel@laptop>
	 <4B38A707.4060904@klingt.org> <1262005413.7135.98.camel@laptop>
	 <4B38AE1D.8060703@klingt.org>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 28 Dec 2009 15:02:12 +0100
Message-ID: <1262008932.7135.101.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-12-28 at 14:09 +0100, Tim Blechmann wrote:
> >>>> like it is impossible to sample instructions with a period of 1? 
> >>>
> >>> Pretty much, imagine the cpu getting a trap every cycle.
> >>
> >> is this a hardware restriction? a slowdown is acceptable for me, as long
> >> as i am able to collect a huge number of samples accurately ...
> > 
> > Large number of samples and sample interval are only related through the
> > runtime of your application.
> > 
> > Use a sensible period (~10k ins) and run a 'little' longer.
> 
> well, for my application, i am not interested in statistical data, but
> in the order of the events ...
> (i am not doing profiling, but trying to gather a sequence of
> machine-structured data for an artistic project)

Well, then use the branch tracer, that will give you the relation
between blocks of code and is actually doable.

But I guess you could hack out the throttle and run the cycle counter
with period=1 for userspace only.

