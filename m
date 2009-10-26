Return-Path: <linux-kernel-owner+w=401wt.eu-S1754252AbZJZEvV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754252AbZJZEvV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Oct 2009 00:51:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753465AbZJZEvU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Oct 2009 00:51:20 -0400
Received: from casper.infradead.org ([85.118.1.10]:38068 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754040AbZJZEvU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Oct 2009 00:51:20 -0400
Date: Sun, 25 Oct 2009 21:52:25 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Mike Galbraith <efault@gmx.de>
Cc: Peter Zijlstra <peterz@infradead.org>, mingo@elte.hu,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] sched: Disable affine wakeups by default
Message-ID: <20091025215225.05ac9ac9@infradead.org>
In-Reply-To: <1256531907.7117.31.camel@marge.simson.net>
References: <20091024125853.35143117@infradead.org>
	<20091024130432.0c46ef27@infradead.org>
	<20091024130728.051c4d7c@infradead.org>
	<1256453725.12138.40.camel@marge.simson.net>
	<20091025095109.449bac9e@infradead.org>
	<1256492289.14241.40.camel@marge.simson.net>
	<20091025123319.2b76bf69@infradead.org>
	<1256508287.17306.14.camel@marge.simson.net>
	<1256522035.7356.19.camel@laptop>
	<1256531907.7117.31.camel@marge.simson.net>
Organization: Intel
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.16.6; i586-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 26 Oct 2009 05:38:27 +0100
Mike Galbraith <efault@gmx.de> wrote:

> On Mon, 2009-10-26 at 02:53 +0100, Peter Zijlstra wrote:
> > On Sun, 2009-10-25 at 23:04 +0100, Mike Galbraith wrote:
> > >                 if (want_affine && (tmp->flags & SD_WAKE_AFFINE)
> > > &&
> > > -                   cpumask_test_cpu(prev_cpu,
> > > sched_domain_span(tmp))) {
> > > +                               (level == SD_LV_SIBLING || level
> > > == SD_LV_MC)) {
> > 
> > quick comment without actually having looked at the patch, we should
> > really get rid of sd->level and encode properties of the sched
> > domains in sd->flags.
> 
> Yeah, sounds right, while writing that, it looked kinda ugly.  I
> suppose arch land needs to encode cache property somehow if I really
> want to be able to target cache on multicore.  Booting becomes..
> exciting when I tinker down there.

or we just use SD_WAKE_AFFINE / SD_BALANCE_WAKE for this...



-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
