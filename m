Return-Path: <linux-kernel-owner+w=401wt.eu-S1422772AbXDRKie@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422772AbXDRKie (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2007 06:38:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422811AbXDRKid
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Apr 2007 06:38:33 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:47558 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422772AbXDRKid (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2007 06:38:33 -0400
Date: Wed, 18 Apr 2007 12:37:57 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Christoph Pfister <christophpfister@gmail.com>
Cc: =?utf-8?B?Uy7Dh2HEn2xhcg==?= Onur <caglar@pardus.org.tr>,
       linux-kernel@vger.kernel.org, Michael Lothian <mike@fireburn.co.uk>,
       Christophe Thommeret <hftom@free.fr>, Jurgen Kofler <kaffeine@gmx.net>,
       Ulrich Drepper <drepper@redhat.com>
Subject: Re: Kaffeine problem with CFS
Message-ID: <20070418103757.GA2673@elte.hu>
References: <20070418082744.GA14009@elte.hu> <19a3b7a80704180157g604f4cecna51a49bd1f4c7d38@mail.gmail.com> <20070418090117.GA20764@elte.hu> <19a3b7a80704180213i1ac84b2ch2b35220b62e3b67a@mail.gmail.com> <20070418091714.GA23446@elte.hu> <19a3b7a80704180225x3c8d6d60g366126862f05150@mail.gmail.com> <20070418092805.GA23125@elte.hu> <19a3b7a80704180252j72c955bcna5df5cb7057e6756@mail.gmail.com> <20070418101706.GA29031@elte.hu> <20070418103252.GA1621@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070418103252.GA1621@elte.hu>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Ingo Molnar <mingo@elte.hu> wrote:

> hm. I've reviewed all uses of demux_lock. ./src/xine-engine/demux.c 
> does this:

plus it does this too:

      pthread_mutex_unlock( &stream->demux_lock );
      xine_usec_sleep(100000);
      pthread_mutex_lock( &stream->demux_lock );

this would explain the nanosleep() strace entries. But the task stuck on 
demux_lock never gets the unlock event. Weird.

	Ingo
