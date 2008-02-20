Return-Path: <linux-kernel-owner+w=401wt.eu-S1758065AbYBTIIg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758065AbYBTIIg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 03:08:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752782AbYBTII2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 03:08:28 -0500
Received: from brick.kernel.dk ([87.55.233.238]:26270 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752213AbYBTII1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 03:08:27 -0500
Date: Wed, 20 Feb 2008 09:08:25 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Mike Travis <travis@sgi.com>
Cc: Paul Jackson <pj@sgi.com>, Alan.Brunelle@hp.com,
       linux-kernel@vger.kernel.org, npiggin@suse.de, dgc@sgi.com,
       arjan@linux.intel.com
Subject: Re: IO queueing and complete affinity w/ threads: Some results
Message-ID: <20080220080824.GP23197@kernel.dk>
References: <47B0B69B.1050807@hp.com> <47B46008.9020804@hp.com> <20080218123717.GW23197@kernel.dk> <20080219151418.97557f0f.pj@sgi.com> <47BB4AB8.9020509@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47BB4AB8.9020509@sgi.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 19 2008, Mike Travis wrote:
> Paul Jackson wrote:
> > Jens wrote:
> >> My main worry with the current code is the ->lock in the per-cpu
> >> completion structure.
> > 
> > Drive-by-comment here:  Does the patch posted later this same day by Mike Travis:
> > 
> >   [PATCH 0/2] percpu: Optimize percpu accesses v3
> > 
> > help with this lock issue any?  (I have no real clue here -- just connecting
> > up the pretty colored dots ;).
> > 
> 
> I'm not sure of the context here but a big motivation for doing the
> zero-based per_cpu variables was to optimize access to the local
> per cpu variables to one instruction, reducing the need for locks.

I'm afraid the two things aren't related, although faster access to
per-cpu is of course a benefit for this as well. My expressed concern
was the:

        spin_lock(&bc->lock);
        was_empty = list_empty(&bc->list);
        list_add_tail(&req->donelist, &bc->list);
        spin_unlock(&bc->lock);

where 'bc' may be per-cpu data of another CPU

-- 
Jens Axboe

