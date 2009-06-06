Return-Path: <linux-kernel-owner+w=401wt.eu-S1753758AbZFFBGm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753758AbZFFBGm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 21:06:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753049AbZFFBGd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 21:06:33 -0400
Received: from mail-fx0-f213.google.com ([209.85.220.213]:46533 "EHLO
	mail-fx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752776AbZFFBGc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 21:06:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=A/3bZM+pr49HcPkRbRaFCNXaU3N3PxnvT9O9Fty5i7e1RecPWw6cIFMpO7VCOn8BDr
         ymko533bQ6D1NZW/v9dBARSe60BHnDvlXnkPA43T679kePCvMPdl0ZzUlHL1j8pf3clZ
         RJyHyeVuTqtCoHFMMPXjmStznHR5Gxw2Wlw7o=
Date: Sat, 6 Jun 2009 03:06:30 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Jan Kara <jack@suse.cz>
Cc: Chris Mason <chris.mason@oracle.com>, Jens Axboe <jens.axboe@oracle.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, tytso@mit.edu, david@fromorbit.com,
       hch@infradead.org, yanmin_zhang@linux.intel.com,
       richard@rsk.demon.co.uk, damien.wyart@free.fr
Subject: Re: [PATCH 0/11] Per-bdi writeback flusher threads v9
Message-ID: <20090606010629.GC7809@nowhere>
References: <20090604152040.GA6007@nowhere> <20090604120726.708a2211.akpm@linux-foundation.org> <20090604191309.GA4862@nowhere> <20090604195013.GB11363@kernel.dk> <20090604201012.GD11363@kernel.dk> <20090604223449.GA13780@nowhere> <20090605191528.GV11363@kernel.dk> <20090605211438.GA11650@duck.suse.cz> <20090606001814.GD3824@think> <20090606002339.GH11650@duck.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090606002339.GH11650@duck.suse.cz>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 06, 2009 at 02:23:40AM +0200, Jan Kara wrote:
> On Fri 05-06-09 20:18:15, Chris Mason wrote:
> > On Fri, Jun 05, 2009 at 11:14:38PM +0200, Jan Kara wrote:
> > > On Fri 05-06-09 21:15:28, Jens Axboe wrote:
> > > > On Fri, Jun 05 2009, Frederic Weisbecker wrote:
> > > > > The result with noop is even more impressive.
> > > > > 
> > > > > See: http://kernel.org/pub/linux/kernel/people/frederic/dbench-noop.pdf
> > > > > 
> > > > > Also a comparison, noop with pdflush against noop with bdi writeback:
> > > > > 
> > > > > http://kernel.org/pub/linux/kernel/people/frederic/dbench-noop-cmp.pdf
> > > > 
> > > > OK, so things aren't exactly peachy here to begin with. It may not
> > > > actually BE an issue, or at least now a new one, but that doesn't mean
> > > > that we should not attempt to quantify the impact.
> > >   What looks interesting is also the overall throughput. With pdflush we
> > > get to 2.5 MB/s + 26 MB/s while with per-bdi we get to 2.7 MB/s + 13 MB/s.
> > > So per-bdi seems to be *more* fair but throughput suffers a lot (which
> > > might be inevitable due to incurred seeks).
> > >   Frederic, how much does dbench achieve for you just on one partition
> > > (test both consecutively if possible) with as many threads as have those
> > > two dbench instances together? Thanks.
> > 
> > Is the graph showing us dbench tput or disk tput?  I'm assuming it is
> > disk tput, so bdi may just be writing less?
>   Good, question. I was assuming dbench throughput :).
> 
> 									Honza


Yeah it's dbench. May be that's not the right tool to measure the writeback
layer, even though dbench results are necessarily influenced by the writeback
behaviour.

May be I should use something else?

Note that if you want I can put some surgicals trace_printk()
in fs/fs-writeback.c


> 
> -- 
> Jan Kara <jack@suse.cz>
> SUSE Labs, CR

