Return-Path: <linux-kernel-owner+w=401wt.eu-S1754186AbZEJKpk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754186AbZEJKpk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 May 2009 06:45:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750805AbZEJKpa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 May 2009 06:45:30 -0400
Received: from ppp121-45-82-25.lns10.adl6.internode.on.net ([121.45.82.25]:50917
	"EHLO homer.shelbyville.oz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750801AbZEJKpa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 May 2009 06:45:30 -0400
Date: Sun, 10 May 2009 20:15:15 +0930
From: Ron <ron@debian.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: mingo@elte.hu, a.p.zijlstra@chello.nl, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fix for sched_clock() when using jiffies
Message-ID: <20090510104515.GC5417@homer.shelbyville.oz>
References: <1227712598.4454.199.camel@twins> <20081126153152.GB28153@homer.shelbyville.oz> <20081128144039.GG28138@elte.hu> <20090508132449.GV5417@homer.shelbyville.oz> <20090508200444.GA22132@homer.shelbyville.oz> <20090508160142.ad89944f.akpm@linux-foundation.org> <20090509004009.GZ5417@homer.shelbyville.oz> <20090508181559.4750800e.akpm@linux-foundation.org> <20090509040537.GA5417@homer.shelbyville.oz> <20090509000406.c2022a0b.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090509000406.c2022a0b.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: ron@debian.org
X-SA-Exim-Scanned: No (on homer.shelbyville.oz); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 09, 2009 at 12:04:06AM -0700, Andrew Morton wrote:
> otoh, sched_clock() should do the INTITAL_JIFFIES offsetting as well,
> because there are probably callers of sched_clock() who are buggy in
> the presence of sched_clock()-return-value wraparound.

I had pondered that too ...

FWIW, that probably could be added fairly trivially as an explicit
debug mode.  Since the only effect should be the visible anomaly in
the printk timestamp, and that would be a Good Thing in this mode
because you'd get to see exactly when it wrapped relative to when
things do go pear shaped and start barking to kernel log about it.


