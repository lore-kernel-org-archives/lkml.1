Return-Path: <linux-kernel-owner+w=401wt.eu-S935728AbXHJOLs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935728AbXHJOLs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2007 10:11:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759019AbXHJOLk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Aug 2007 10:11:40 -0400
Received: from ns2.suse.de ([195.135.220.15]:52331 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759192AbXHJOLj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2007 10:11:39 -0400
Date: Fri, 10 Aug 2007 16:11:38 +0200
From: Jan Blunck <jblunck@suse.de>
To: Andi Kleen <ak@suse.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] oprofile: Make callgraph use dump_trace() on
	i386/x86_64
Message-ID: <20070810141137.GG29553@hasse.suse.de>
References: <20070810133528.883477787@suse.de> <20070810133635.821996956@suse.de> <200708101545.22498.ak@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200708101545.22498.ak@suse.de>
Organization: SUSE LINUX Products GmbH, GF Markus Rex, HRB 16746 (AG
	Nuernberg)
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 10, Andi Kleen wrote:

> On Friday 10 August 2007 15:35:29 jblunck@suse.de wrote:
> > This patch improves oprofile callgraphs for i386/x86_64. The old backtracing
> > code was unable to produce even kernel backtraces if the kernel wasn't
> > compiled with framepointers. The code now uses dump_trace().
> 
> Hmm one issue i didn't notice before: with imprecise backtrace
> the profiling could be a little random because even if the same
> call chain is hit repeatedly the garbage left over stack entries also
> reported could vary and then cause oprofile to put it into different
> buckets. But there is probably not much that can be 
> done about that.

Yes, but before we didn't had any callgraphs for x86_64 since with
framepointers enabled the backtrace is having very strange results too.

I guess this is the best what we can achieve at the moment. Eventually when we
have fast, precise backtraces in the kernel the oprofile code benefits from
that automatically with this patch.
