Return-Path: <linux-kernel-owner+w=401wt.eu-S1756321AbYCCMxF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756321AbYCCMxF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 07:53:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756169AbYCCMwr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 07:52:47 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:54249 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755016AbYCCMwq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 07:52:46 -0500
Date: Mon, 3 Mar 2008 13:52:27 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Michael Kerrisk <mtk.manpages@googlemail.com>
Cc: Arnd Bergmann <arnd@arndb.de>, Christoph Hellwig <hch@lst.de>,
       cbe-oss-dev@ozlabs.org, Jeremy Kerr <jk@ozlabs.org>,
       linux-kernel@vger.kernel.org
Subject: Re: SCHED_IDLE documentation
Message-ID: <20080303125227.GA22160@elte.hu>
References: <1203376368.275756.252634247263.1.gpush@pokey> <200803030612.28039.arnd@arndb.de> <20080303051719.GA26102@lst.de> <200803030721.52869.arnd@arndb.de> <20080303073311.GB5934@elte.hu> <cfd18e0f0803030040l667dd2b7v6298e78c5b21bfec@mail.gmail.com> <20080303092422.GA18281@elte.hu> <cfd18e0f0803030431n69df391dw53843d5079d906dd@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cfd18e0f0803030431n69df391dw53843d5079d906dd@mail.gmail.com>
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


* Michael Kerrisk <mtk.manpages@googlemail.com> wrote:

> > > * What's the difference between SCHED_IDLE and SCHED_BATCH?
> >
> > SCHED_BATCH can still have nice levels from -20 to +19, it is a 
> > modified SCHED_OTHER/SCHED_NORMAL for "throughput oriented" 
> > workloads.
> 
> So, suppose we have two CPU intensive jobs, one SCHED_OTHER and the 
> other SCHED_BATCH.  If they have the same nice value, will/should the 
> scheduler favour one over the other?

yes - SCHED_BATCH does not modify the CPU usage proportion for 
CPU-intense tasks, it's their nice value that controls the proportion. 
What it will influence is wakeup behavior - i.e. wakeup-intense 
workloads should schedule less with SCHED_BATCH. (but how that is done 
is really fluid and will probably tweaked in the future.)

	Ingo
