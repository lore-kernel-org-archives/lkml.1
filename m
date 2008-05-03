Return-Path: <linux-kernel-owner+w=401wt.eu-S1755632AbYECVw7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755632AbYECVw7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 May 2008 17:52:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751721AbYECVww
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 May 2008 17:52:52 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:57948 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751038AbYECVwv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 May 2008 17:52:51 -0400
Date: Sat, 3 May 2008 23:52:14 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Adrian Bunk <bunk@kernel.org>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, linux-kernel@vger.kernel.org,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Ingo, no more kconfig patches
Message-ID: <20080503215214.GA18407@elte.hu>
References: <20080430200340.GA13757@elte.hu> <20080430170125.ZZRA012@mailhub.coreip.homeip.net> <20080430211317.GA24633@elte.hu> <20080430230100.GK29330@cs181133002.pp.htv.fi> <20080501025234.GE27574@elte.hu> <20080501115923.GX29330@cs181133002.pp.htv.fi> <20080503191445.GF5292@elte.hu> <20080503202416.GR5838@cs181133002.pp.htv.fi> <20080503210300.GA10979@elte.hu> <20080503212429.GT5838@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080503212429.GT5838@cs181133002.pp.htv.fi>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Adrian Bunk <bunk@kernel.org> wrote:

> > at minimum a warning needs to be emitted by the kconfig tool if such 
> > incomplete selects are used. I've stopped counting the number of 
> > times such issues have broken the build and have held up kernel 
> > development.
> 
> It might held up your randconfig compiles.
> 
> Actual kernel development isn't much affected.

uhm, you are quite wrong - countless times have people been bitten by 
select's breakages in the past, and not via randconfig. That's the main 
reason why select use in Kconfig was not encouraged for a long time.

Select does make sense in some situations but it's a double-edged sword: 
kconfig does not warn at all about the situations where it's "unsafe" to 
use it - while it has all the information in the Kconfig files to emit 
that warning. Instead we get build breakages not visible when an 
incorrect select is added, but much later, if someone happens to stumble 
on the wrong kind of .config. That is obviously harmful.

My larger point is that this kconfig tool bug breeds a constant stream 
of avoidable breakages, which causes lost manpower and causes a stream 
of trivial patches hindering maintainers all around the tree. Because 
every such trivial patch has to be reviewed, tested, it clogs the commit 
logs, etc.

So the more trivial patches we _avoid_ having to do in the future, the 
better. I'm not sure why you are even arguing against this this rather 
simple point - your arguments are rather hard to understand. Wouldnt you 
be happier if a whole category of trivial breakages was avoided and if 
you didnt have to deal with and waste your time on that category of 
trivial patches anymore?

Most of the time reoccuring trivial patches are an indicator of some 
deeper structural problem - as in this case.

	Ingo
