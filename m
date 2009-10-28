Return-Path: <linux-kernel-owner+w=401wt.eu-S932589AbZJ1HZp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932589AbZJ1HZp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Oct 2009 03:25:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932342AbZJ1HZo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Oct 2009 03:25:44 -0400
Received: from mail.gmx.net ([213.165.64.20]:60700 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S932219AbZJ1HZo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Oct 2009 03:25:44 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX19Flu05VpJFmnx5ISZjmy5hL9tbUrKmeirsGbFT4H
	2gj+fcK2y9B90E
Subject: Re: [PATCH 3/3] sched: Disable affine wakeups by default
From: Mike Galbraith <efault@gmx.de>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Arjan van de Ven <arjan@infradead.org>, mingo@elte.hu,
       linux-kernel@vger.kernel.org
In-Reply-To: <1256654138.17752.7.camel@marge.simson.net>
References: <20091024125853.35143117@infradead.org>
	 <20091024130432.0c46ef27@infradead.org>
	 <20091024130728.051c4d7c@infradead.org>
	 <1256453725.12138.40.camel@marge.simson.net>
	 <20091025095109.449bac9e@infradead.org>
	 <1256492289.14241.40.camel@marge.simson.net>
	 <20091025123319.2b76bf69@infradead.org>
	 <1256508287.17306.14.camel@marge.simson.net>
	 <1256522035.7356.19.camel@laptop>
	 <1256654138.17752.7.camel@marge.simson.net>
Content-Type: text/plain
Date: Wed, 28 Oct 2009 08:25:41 +0100
Message-Id: <1256714741.10387.4.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.53
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-10-27 at 15:35 +0100, Mike Galbraith wrote:
> On Mon, 2009-10-26 at 02:53 +0100, Peter Zijlstra wrote:
> > On Sun, 2009-10-25 at 23:04 +0100, Mike Galbraith wrote:
> > >                 if (want_affine && (tmp->flags & SD_WAKE_AFFINE) &&
> > > -                   cpumask_test_cpu(prev_cpu, sched_domain_span(tmp))) {
> > > +                               (level == SD_LV_SIBLING || level == SD_LV_MC)) {
> > 
> > quick comment without actually having looked at the patch, we should
> > really get rid of sd->level and encode properties of the sched domains
> > in sd->flags.
> 
> I used SD_PREFER_SIBLING in the below.  Did I break anything?

Um, other than taskset.

> +				if (candidate == -1 || candidate == cpu) {
> +					for_each_cpu(i, sched_domain_span(tmp)) {

                                                if (!cpumask_test_cpu(i, &p->cpus_allowed))
                                                        continue;

(i think i'm going to need that domain flag in a few minutes anyway)

	-Mike

