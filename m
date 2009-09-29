Return-Path: <linux-kernel-owner+w=401wt.eu-S1753386AbZI2IG4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753386AbZI2IG4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Sep 2009 04:06:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753222AbZI2IGz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Sep 2009 04:06:55 -0400
Received: from mail-ew0-f211.google.com ([209.85.219.211]:36930 "EHLO
	mail-ew0-f211.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753097AbZI2IGx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Sep 2009 04:06:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=I6XXcXQds6ADPn3iWNCNY8vsqATE9dxfOYzlt+pNgDKnLMEe0d6p6a4CrkzYvIG0ZA
         ScN0ZNnaxeOz2oxlb5XOvl6Gi2swLCH17/GS++1GIgylBRmpawVki3iqp4IDYaHl4npt
         6eQpAwTt03MWelYu7yTf5gWtaLEYxdD/V4RD8=
Date: Tue, 29 Sep 2009 10:06:57 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: John Kacur <jkacur@redhat.com>
Cc: mingo@elte.hu, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       linux-kernel@vger.kernel.org, linux-perf-users@vger.kernel.org
Subject: Re: [PATCH] Put common histogram functions for perf in their own
	file
Message-ID: <20090929080654.GC5233@nowhere>
References: <alpine.LFD.2.00.0909281457530.8316@localhost.localdomain> <20090928140158.GA6178@nowhere> <alpine.LFD.2.00.0909281652001.10299@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0909281652001.10299@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 28, 2009 at 05:04:07PM +0200, John Kacur wrote:
> perf annotate still will not sort the entries with these changes.
> because callchain will be equal to zero.



The sorting does not only applies to callchains but also on
histogram entries.


 
> Calling output__resort(total) will be harmless because the calculation
> will be thrown away in output__insert_entry() here:
> if (callchain)
> 		callchain_param.sort(&he->sorted_chain, &he->callchain,
> 				      min_callchain_hits, &callchain_param);



Hmm, but the histogram entries will still be sorted, I might be wrong
but it doesn't seem to be needed.

That said it's not something introduced by your patch, it was
already there, but I guess it would be a nice separate cleanup patch.


> From 7c6a2035c32d17db0e566a36c7e345ec2182f722 Mon Sep 17 00:00:00 2001
> From: John Kacur <jkacur@redhat.com>
> Date: Mon, 28 Sep 2009 14:53:08 +0200
> Subject: [PATCH] Put common histogram functions for perf in their own file
> 
> Move histogram related functions into their own files (hist.c and hist.h)
> and make use of them in builtin-annotate.c and builtin-report.c
> 
> Signed-off-by: John Kacur <jkacur@redhat.com>


Acked-by: Frederic Weisbecker <fweisbec@gmail.com>

Thanks!

