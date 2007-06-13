Return-Path: <linux-kernel-owner+w=401wt.eu-S1757418AbXFMIvY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757418AbXFMIvY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2007 04:51:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756021AbXFMIvS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jun 2007 04:51:18 -0400
Received: from brick.kernel.dk ([80.160.20.94]:26158 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755582AbXFMIvR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2007 04:51:17 -0400
Date: Wed, 13 Jun 2007 10:48:50 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Eric Dumazet <dada1@cosmosbay.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/18] splice: abstract out actor data
Message-ID: <20070613084850.GA18832@kernel.dk>
References: <11816314942627-git-send-email-jens.axboe@oracle.com> <11816314942637-git-send-email-jens.axboe@oracle.com> <20070612173150.80f6f7e3.dada1@cosmosbay.com> <20070612162215.GM18832@kernel.dk> <1181724531.7348.338.camel@twins>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1181724531.7348.338.camel@twins>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 13 2007, Peter Zijlstra wrote:
> On Tue, 2007-06-12 at 18:22 +0200, Jens Axboe wrote:
> > On Tue, Jun 12 2007, Eric Dumazet wrote:
> > > On Tue, 12 Jun 2007 08:57:57 +0200
> > > Jens Axboe <jens.axboe@oracle.com> wrote:
> > > 
> > > 
> > > > +	struct splice_desc sd = {
> > > > +		.total_len = len,
> > > > +		.flags = flags,
> > > > +		.pos = *ppos,
> > > > +	};
> > > > +
> > > > +	sd.file = out;
> > > 
> > > minor remark, why sd.file is setup differently than other fields ?
> > > 
> > > (this several times on this patch)
> > 
> > yeah, it's inside an anonymous union, and apparently gcc doesn't like it
> > being initialized that way.
> 
> The one time I had such a situation something along the lines of:
> 
> struct splice_desc sd = {
> 	.total_len = len,
> 	.flags = flags,
> 	.pos = *ppos,
> 	{ .file = out },
> };
> 
> worked.

OK, that looks pretty handy. But I just threw the towel into the ring
and named the union instead yesterday. The outside initialization of
file/userptr/data was an eyesore to me.

-- 
Jens Axboe

