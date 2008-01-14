Return-Path: <linux-kernel-owner+w=401wt.eu-S1755427AbYANKL7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755427AbYANKL7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2008 05:11:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754127AbYANKLv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jan 2008 05:11:51 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:57340 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754017AbYANKLu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2008 05:11:50 -0500
Date: Mon, 14 Jan 2008 11:11:33 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Andi Kleen <ak@suse.de>
Cc: travis@sgi.com, Andrew Morton <akpm@linux-foundation.org>,
       Christoph Lameter <clameter@sgi.com>, Jack Steiner <steiner@sgi.com>,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/10] x86: Reduce memory and intra-node effects with
	large count NR_CPUs
Message-ID: <20080114101133.GA23238@elte.hu>
References: <20080113183453.973425000@sgi.com> <20080114081418.GB18296@elte.hu> <200801141104.18789.ak@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200801141104.18789.ak@suse.de>
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


* Andi Kleen <ak@suse.de> wrote:

> > i.e. we've got ~22K bloat per CPU - which is not bad, but because 
> > it's a static component, it hurts smaller boxes. For distributors to 
> > enable CONFIG_NR_CPU=1024 by default i guess that bloat has to drop 
> > below 1-2K per CPU :-/ [that would still mean 1-2MB total bloat but 
> > that's much more acceptable than 23MB]
> 
> Even 1-2MB overhead would be too much for distributors I think. 
> Ideally there must be near zero overhead for possible CPUs (and I see 
> no principle reason why this is not possible) Worst case a low few 
> hundred KBs, but even that would be much.

i think this patchset already gives a net win, by moving stuff from 
NR_CPUS arrays into per_cpu area. (Travis please confirm that this is 
indeed what the numbers show)

The (total-)size of the per-cpu area(s) grows linearly with the number 
of CPUs, so we'll have the expected near-zero overhead on 4-8-16-32 CPUs 
and the expected larger total overhead on 1024 CPUs.

	Ingo
