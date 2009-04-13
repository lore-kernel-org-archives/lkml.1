Return-Path: <linux-kernel-owner+w=401wt.eu-S1754248AbZDMXsK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754248AbZDMXsK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Apr 2009 19:48:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754673AbZDMXru
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Apr 2009 19:47:50 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:60221 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753801AbZDMXrs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Apr 2009 19:47:48 -0400
Date: Tue, 14 Apr 2009 01:47:41 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Theodore Tso <tytso@mit.edu>, Steven Rostedt <rostedt@goodmis.org>,
       Linux Kernel Developers List <linux-kernel@vger.kernel.org>,
       Tom Zanussi <tzanussi@gmail.com>, Li Zefan <lizf@cn.fujitsu.com>,
       =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH, RFC 0/3] Improvements to the tracing documentation
Message-ID: <20090413234741.GI817@elte.hu>
References: <1239479479-2603-1-git-send-email-tytso@mit.edu> <20090412092524.GA30349@elte.hu> <20090412121533.GB10547@mit.edu> <20090412130105.GB20281@elte.hu> <20090412172344.GC10547@mit.edu> <20090413213124.GB8514@elte.hu> <20090413223526.GB32182@mit.edu> <20090413225542.GJ8514@elte.hu> <20090413233953.GA955@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090413233953.GA955@mit.edu>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
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


* Theodore Tso <tytso@mit.edu> wrote:

> On Tue, Apr 14, 2009 at 12:55:42AM +0200, Ingo Molnar wrote:
> > 
> > It could be worked around right now by converting it to an 
> > integer but i think what we want is native support for kdev_t, 
> > together with all the usual convenience forms of specifying it: 
> > sda1 should work the same way as 8:1 or 0801. Even /dev/sda1 
> > should be recognized in a filter expression.
> 
> Yeah, I could just drop in the integer now, and and just have 
> TP_printk() display "(8, 2)" instead of "sda2".  It's really a 
> question of how far we want to take pretty-printing and parsing 
> for ftrace, I suppose.

We try to do it as far as daily use in /debug/tracing/ dictates. 
Interacting with the kernel on such a direct channel is really 
intuitive and useful in debugging and development sessions IMHO.

Raw binary records would encode it in an efficient and 
well-specified manner, so information density is not hurt by 
pretty-printing.

> But if we are going to have end-users use it, having real 
> pretty-printed names would be a good thing, IMHO.  Especially if 
> major/minor numbers start becoming completely random beasts, as 
> some have proposed.  (I think it's a terrible idea, but I'm 
> clearly not politically correct.  :-)

Sounds like a terrible idea to me too. If more space is needed then 
perhaps dynamically allocate the _new_ bits needed - but leave the 
well-established spaces alone. Making everything random looking is 
just asking for all sorts of trouble IMO. Making the system harder 
to understand at a glance, on such a fundamental level, seems silly.

	Ingo
