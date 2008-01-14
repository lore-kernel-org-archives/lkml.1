Return-Path: <linux-kernel-owner+w=401wt.eu-S1753545AbYANIOl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753545AbYANIOl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2008 03:14:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752236AbYANIOe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jan 2008 03:14:34 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:39087 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752219AbYANIOd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2008 03:14:33 -0500
Date: Mon, 14 Jan 2008 09:14:18 +0100
From: Ingo Molnar <mingo@elte.hu>
To: travis@sgi.com
Cc: Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@suse.de>,
       Christoph Lameter <clameter@sgi.com>, Jack Steiner <steiner@sgi.com>,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/10] x86: Reduce memory and intra-node effects with
	large count NR_CPUs
Message-ID: <20080114081418.GB18296@elte.hu>
References: <20080113183453.973425000@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080113183453.973425000@sgi.com>
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


* travis@sgi.com <travis@sgi.com> wrote:

> This patchset addresses the kernel bloat that occurs when NR_CPUS is 
> increased. The memory numbers below are with NR_CPUS = 1024 which I've 
> been testing (4 and 32 real processors, the rest "possible" using the 
> additional_cpus start option.) These changes are all specific to the 
> x86 architecture, non-arch specific changes will follow.

thanks, i'll try this patchset in x86.git.

> 32cpus			  1kcpus-before		    1kcpus-after
>    7172678 Total	   +23314404 Total	       -147590 Total

1kcpus-after means it's +23314404-147590, i.e. +23166814? (i.e. a 0.6% 
reduction of the bloat?)

i.e. we've got ~22K bloat per CPU - which is not bad, but because it's a 
static component, it hurts smaller boxes. For distributors to enable 
CONFIG_NR_CPU=1024 by default i guess that bloat has to drop below 1-2K 
per CPU :-/ [that would still mean 1-2MB total bloat but that's much 
more acceptable than 23MB]

	Ingo
