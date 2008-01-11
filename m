Return-Path: <linux-kernel-owner+w=401wt.eu-S1761303AbYAKJme@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761303AbYAKJme (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2008 04:42:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757447AbYAKJm1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jan 2008 04:42:27 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:32875 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754504AbYAKJm0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2008 04:42:26 -0500
Date: Fri, 11 Jan 2008 10:42:05 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: David Dillow <dillowda@ornl.gov>, Guillaume Chazarain <guichaz@yahoo.fr>,
       linux-kernel@vger.kernel.org, linux-btrace@vger.kernel.org,
       mingo@redhat.com, tglx@linutronix.de
Subject: Re: CONFIG_NO_HZ breaks blktrace timestamps
Message-ID: <20080111094205.GE8143@elte.hu>
References: <1199918912.8388.13.camel@lap75545.ornl.gov> <1199996752.9159.46.camel@lap75545.ornl.gov> <20080110234438.4826f658@inria.fr> <1200020661.5099.3.camel@obelisk.thedillows.org> <20080111090723.GI6258@kernel.dk> <20080111092334.GA8143@elte.hu> <20080111092513.GO6258@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080111092513.GO6258@kernel.dk>
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


* Jens Axboe <jens.axboe@oracle.com> wrote:

> > they are from the scheduler git tree (except the first debug patch), 
> > but queued up for v2.6.25 at the moment.
> 
> So this means that blktrace will be broken with CONFIG_NO_HZ for 
> 2.6.24? That's clearly a regression.

64-bit CONFIG_NO_HZ is a new feature in v2.6.24. If it happens on 32-bit 
too and it didnt happen in v2.6.23 32-bit then it's a regression.

all this comes from blktrace's original decision of using sched_clock()
:-) It's not a global timesource and it's not trivial to turn it into a
halfways usable global timesource.

	Ingo
