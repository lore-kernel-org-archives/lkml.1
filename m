Return-Path: <linux-kernel-owner+w=401wt.eu-S1757164AbXKTGGF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757164AbXKTGGF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2007 01:06:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752459AbXKTGFy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Nov 2007 01:05:54 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:57835 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750702AbXKTGFx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2007 01:05:53 -0500
Date: Tue, 20 Nov 2007 07:05:25 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Greg KH <gregkh@suse.de>, Greg KH <greg@kroah.com>,
       David <david@unsolicited.net>,
       Javier Kohen <jkohen@users.sourceforge.net>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       stable@kernel.org
Subject: Re: [stable] Soft lockups since stable kernel upgrade to 2.6.23.8
Message-ID: <20071120060525.GF20436@elte.hu>
References: <1195323695.5240.16.camel@null.tough.com.ar> <20071117191211.GA12757@kroah.com> <473F498D.9090703@unsolicited.net> <20071117203705.GA21045@kroah.com> <473F88B0.1030309@goop.org> <20071119232252.GC3528@suse.de> <47423B26.1090607@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47423B26.1090607@goop.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Jeremy Fitzhardinge <jeremy@goop.org> wrote:

> Greg KH wrote:
> > Can you try applying the patch below to see if that solves the problem
> > for you?
> >   
> 
> I don't think this patch will help; it only has cosmetic changes in
> addition to the original message printing fix.  I think it also needs
> change a3b13c23f186ecb57204580cc1f2dbe9c284953a:
> 
> diff -r 79f0ea1e0e70 -r 06f060ab58aa kernel/softlockup.c

yes, it does need the cpu_clock() changes as i mentioned.

  commit a3b13c23f186ecb57204580cc1f2dbe9c284953a
  Author: Ingo Molnar <mingo@elte.hu>
  Date:   Tue Oct 16 23:26:06 2007 -0700

    softlockup: use cpu_clock() instead of sched_clock()

    sched_clock() is not a reliable time-source, use cpu_clock() instead.

but we only have cpu_clock() from v2.6.23 onwards - so we should not 
apply the original patch to v2.6.22. (we should not have applied your 
patch that started the mess to begin with - but that's another matter.)

	Ingo
