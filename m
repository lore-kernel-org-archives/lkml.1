Return-Path: <linux-kernel-owner+w=401wt.eu-S1760181AbYEIK02@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760181AbYEIK02 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2008 06:26:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753549AbYEIK0U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 May 2008 06:26:20 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:55463 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753477AbYEIK0T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2008 06:26:19 -0400
Date: Fri, 9 May 2008 12:26:07 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Christoph Lameter <clameter@sgi.com>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: Spinlocks: Factor our GENERIC_LOCKBREAK in order to avoid spin
	with irqs disable
Message-ID: <20080509102607.GF19617@elte.hu>
References: <Pine.LNX.4.64.0805061220570.30604@schroedinger.engr.sgi.com> <20080507073017.GJ32195@elte.hu> <Pine.LNX.4.64.0805071002330.3110@schroedinger.engr.sgi.com> <Pine.LNX.4.64.0805071022230.3173@schroedinger.engr.sgi.com> <Pine.LNX.4.64.0805071148240.8441@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0805071148240.8441@schroedinger.engr.sgi.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0004]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Christoph Lameter <clameter@sgi.com> wrote:

> Subject: Spinlocks: Factor our GENERIC_LOCKBREAK in order to avoid 
> spin with irqs disabled
> 
> The nice spinlock functions that enable interrupts while spinning are 
> only usable if GENERIC_LOCKBREAK is set (and we do not debug locks but 
> lock debugging would not be used for a production configuration).
> 
> Factor out the dependencies on the ->lock_break field from the nice 
> functions into a set of BREAKLOCK macros (cannot be functions since 
> the type of the lock variable varies).
> 
> The nice spinlock function can then also be used if !GENERIC_LOCKBREAK

hm, there was some lockdep complication in this area. I guess we could 
use the 'nice' variants too if their irq-enabling/disabling was properly 
lockdep annotated and tracked by the irqflags machinery?

	Ingo
