Return-Path: <linux-kernel-owner+w=401wt.eu-S1759527AbYBSBuH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759527AbYBSBuH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2008 20:50:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753439AbYBSBt4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Feb 2008 20:49:56 -0500
Received: from ns2.suse.de ([195.135.220.15]:40825 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755021AbYBSBtz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2008 20:49:55 -0500
Date: Tue, 19 Feb 2008 02:49:12 +0100
From: Nick Piggin <npiggin@suse.de>
To: Andi Kleen <andi@firstfloor.org>
Cc: Jens Axboe <jens.axboe@oracle.com>,
       "Alan D. Brunelle" <Alan.Brunelle@hp.com>, linux-kernel@vger.kernel.org,
       dgc@sgi.com, arjan@linux.intel.com
Subject: Re: IO queueing and complete affinity w/ threads: Some results
Message-ID: <20080219014911.GD21165@wotan.suse.de>
References: <47B0B69B.1050807@hp.com> <47B46008.9020804@hp.com> <20080218123717.GW23197@kernel.dk> <p73ablyxuci.fsf@bingen.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <p73ablyxuci.fsf@bingen.suse.de>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 18, 2008 at 02:33:17PM +0100, Andi Kleen wrote:
> Jens Axboe <jens.axboe@oracle.com> writes:
> 
> > and that scrapping the remote
> > softirq trigger stuff is sanest.
> 
> I actually liked Nick's queued smp_function_call_single() patch. So even
> if it was not used for block I would still like to see it being merged 
> in some form to speed up all the other IPI users.

Yeah, that hasn't been forgotten (nor have your comments about folding
my special function into smp_call_function_single).

The call function path is terribly unscalable at the moment on a lot
of architectures, and also it isn't allowed to be used with interrupts
off due to deadlock (which the queued version can allow, provided
that wait=0).

I will get around to sending that upstream soon.
