Return-Path: <linux-kernel-owner+w=401wt.eu-S1755463AbXLUKXf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755463AbXLUKXf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2007 05:23:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750876AbXLUKX2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Dec 2007 05:23:28 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:51463 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750740AbXLUKX1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2007 05:23:27 -0500
Date: Fri, 21 Dec 2007 11:19:11 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Andrew Morton <akpm@linux-foundation.org>, trond.myklebust@fys.uio.no,
       tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
       linux-kernel@vger.kernel.org
Subject: Re: Linux 2.6.24-rc5 x86 architecture no longer Oopses...
Message-ID: <20071221101911.GA22452@elte.hu>
References: <1198190447.29917.9.camel@heimdal.trondhjem.org> <20071220145415.f737e7f3.akpm@linux-foundation.org> <20071220145621.90ffb08a.akpm@linux-foundation.org> <200712210155.18527.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200712210155.18527.rjw@sisk.pl>
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


* Rafael J. Wysocki <rjw@sisk.pl> wrote:

> > btw, I think we should track this as a regression, please.
> 
> Added, http://bugzilla.kernel.org/show_bug.cgi?id=9610, thanks.

fixed by:

 commit c0a698b7443a9fce76b0a849f06c45ac78f3b0a0
 Author: Ingo Molnar <mingo@elte.hu>
 Date:   Fri Dec 21 01:27:19 2007 +0100

    x86: fix die() to not be preemptible

    Andrew "Eagle Eye" Morton noticed that we use raw_local_save_flags()
    instead of raw_local_irq_save(flags) in die(). This allows the
    preemption of oopsing contexts - which is highly undesirable. It also
    causes CONFIG_DEBUG_PREEMPT to complain, as reported by Miles Lane.

