Return-Path: <linux-kernel-owner+w=401wt.eu-S1759741AbYEFMcx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759741AbYEFMcx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2008 08:32:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752547AbYEFMcp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 May 2008 08:32:45 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:43320 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753018AbYEFMcp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2008 08:32:45 -0400
Date: Tue, 6 May 2008 14:32:29 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Adrian Bunk <bunk@kernel.org>
Cc: Christoph Lameter <clameter@sgi.com>, travis@sgi.com,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 4/4] x86: e820 unification: Extract common functions
Message-ID: <20080506123229.GL32591@elte.hu>
References: <20080505190213.714827651@sgi.com> <20080505190247.676948211@sgi.com> <20080506113500.GB2359@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080506113500.GB2359@cs181133002.pp.htv.fi>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0002]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Adrian Bunk <bunk@kernel.org> wrote:

> >  int
> > -e820_any_mapped(u64 start, u64 end, unsigned type)
> > +e820_any_mapped(unsigned long start,unsigned long end, unsigned type)
> >  {
> >  	int i;
> >  	for (i = 0; i < e820.nr_map; i++) {
> 
> This changes the parameters from 64bit to 32bit which looks fishy.

good catch! This could lead to bugs on 32-bit that has physical RAM 
addresses over 4GB.

> Are you sure the solution that would both match and be correct isn't 
> to change the 64bit one to u64?

agreed.

	Ingo
