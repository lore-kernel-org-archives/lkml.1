Return-Path: <linux-kernel-owner+w=401wt.eu-S1763332AbZFIKjy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763332AbZFIKjy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jun 2009 06:39:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762192AbZFIKcI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Jun 2009 06:32:08 -0400
Received: from cantor2.suse.de ([195.135.220.15]:36113 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762211AbZFIKcH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jun 2009 06:32:07 -0400
Date: Tue, 9 Jun 2009 12:32:08 +0200
From: Jan Kara <jack@suse.cz>
To: Mike Galbraith <efault@gmx.de>
Cc: Diego Calleja <diegocg@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: Performance regressions in 2.6.30-rc7?
Message-ID: <20090609103208.GB9235@duck.suse.cz>
References: <200905282249.28592.diegocg@gmail.com> <20090529210718.bef7a9c1.akpm@linux-foundation.org> <200905301851.47708.diegocg@gmail.com> <20090603195806.GA9571@atrey.karlin.mff.cuni.cz> <1244100382.7131.12.camel@marge.simson.net> <20090604112109.GC2859@duck.suse.cz> <1244142795.5731.31.camel@marge.simson.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1244142795.5731.31.camel@marge.simson.net>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 04-06-09 21:13:15, Mike Galbraith wrote:
> On Thu, 2009-06-04 at 13:21 +0200, Jan Kara wrote:
> 
> > > Sequential Writes
> > > 2.6.30-smp-ordered            6000  65536  32   50.16 508.9%    31.996    45595.78   0.64965  0.02402    10
> > > 2.6.29.4-smp-ordered          6000  65536  32   52.70 543.2%    33.658    23794.92   0.71754  0.00836    10
> > > 
> > > 2.6.30-smp-writeback          6000  65536  32   47.82 525.4%    35.003    32588.84   0.56192  0.02298     9
> > > 2.6.29.4-smp-writeback        6000  65536  32   52.52 467.6%    32.397    12972.78   0.53580  0.00522    11
> > > 
> > > 2.6.30-smp-ordered            6000  65536  16   56.08 254.9%    15.463    33000.68   0.39687  0.00521    22
> > > 2.6.29.4-smp-ordered          6000  65536  16   62.40 308.4%    14.701    13455.02   0.13125  0.00208    20
> > > 
> > > 2.6.30-smp-writeback          6000  65536  16   51.90 281.4%    17.098    12869.85   0.36771  0.00104    18
> > > 2.6.29.4-smp-writeback        6000  65536  16   60.53 272.6%    14.977     8637.08   0.21146  0.00000    22
> > > 
> > > 2.6.30-smp-ordered            6000  65536   8   51.09 113.4%     8.700    14856.55   0.06771  0.00417    45
> > > 2.6.29.4-smp-ordered          6000  65536   8   56.13 130.6%     8.098     8400.45   0.03958  0.00000    43
> > > 
> > > 2.6.30-smp-writeback          6000  65536   8   50.19 131.7%     8.680    16821.04   0.11979  0.00208    38
> > > 2.6.29.4-smp-writeback        6000  65536   8   54.90 130.7%     8.244     4925.48   0.10000  0.00000    42
> >   It really seems write has some problems... There's consistently lower
> > throughput and it also seems some writes take really long. I'll try to
> > reproduce it here.
> 
> Looked "pretty solid" to me.  I haven't observed enough to ~trust.
  OK, I did a few runs of tiobench here and I can confirm that I see about
6% performance regression in Sequential Write throughput between 2.6.29
and 2.6.30-rc8. I'll try to find what's causing it.

									Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
