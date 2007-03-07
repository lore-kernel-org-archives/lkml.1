Return-Path: <linux-kernel-owner+w=401wt.eu-S1422704AbXCGJwQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422704AbXCGJwQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 04:52:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422699AbXCGJwQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 04:52:16 -0500
Received: from mx2.suse.de ([195.135.220.15]:41752 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422704AbXCGJwP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 04:52:15 -0500
Date: Wed, 7 Mar 2007 10:52:12 +0100
From: Nick Piggin <npiggin@suse.de>
To: Ingo Molnar <mingo@elte.hu>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Memory Management <linux-mm@kvack.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: [patch 4/6] mm: merge populate and nopage into fault (fixes nonlinear)
Message-ID: <20070307095212.GF8609@wotan.suse.de>
References: <20070221023656.6306.246.sendpatchset@linux.site> <20070221023735.6306.83373.sendpatchset@linux.site> <20070306225101.f393632c.akpm@linux-foundation.org> <20070307070853.GB15877@wotan.suse.de> <20070307081948.GA9563@wotan.suse.de> <20070307082755.GA25733@elte.hu> <20070307085944.GA17433@wotan.suse.de> <20070307092252.GA6499@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070307092252.GA6499@elte.hu>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 07, 2007 at 10:22:52AM +0100, Ingo Molnar wrote:
> 
> * Nick Piggin <npiggin@suse.de> wrote:
> 
> > After these patches, I don't think there is too much burden. The main 
> > thing left really is just the objrmap stuff, but that is just handled 
> > with a minimal 'dumb' algorithm that doesn't cost much.
> 
> ok. What do you think about the sys_remap_file_pages_prot() thing that 
> Paolo has done in a nicely split up form - does that complicate things 
> in any fundamental way? That is what is useful to UML.

Last time I looked (a while ago), the only issue I had was that he was
doing a weird special case rather than using another !present pte bit
for his "nonlinear protection" ptes.

I think he fixed that now and so it should be quite good now.
