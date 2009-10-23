Return-Path: <linux-kernel-owner+w=401wt.eu-S1751552AbZJWHph@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751552AbZJWHph (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Oct 2009 03:45:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751305AbZJWHph
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Oct 2009 03:45:37 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:44319 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751083AbZJWHpg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Oct 2009 03:45:36 -0400
Date: Fri, 23 Oct 2009 09:45:33 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>,
       =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
Subject: [performance problem] CONFIG_DYNAMIC_FTRACE: Increased kernel
	build times
Message-ID: <20091023074533.GA10067@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.19 (2009-01-05)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Steve,

i did an 64-bit allyesconfig build test (with debug_info disabled), with 
and without CONFIG_DYNAMIC_FTRACE set.

The build time results are:

  -CONFIG_DYNAMIC_FTRACE:   266.30
  +CONFIG_DYNAMIC_FTRACE:   296.07 (+11.2%)

So we get more than 10% build time overhead.

That's quite high - higher than what i remember having measured 
originally when the first iteration of the mcount code went in.

This extra overhead comes from the mcount post-processing script 
(scripts/recordmcount.pl) that runs objcopy as well and is written in 
Perl. I think this whole angle needs to be improved - 10% is way too 
high of a price to pay.

	Ingo
