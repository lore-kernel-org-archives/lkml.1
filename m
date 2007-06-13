Return-Path: <linux-kernel-owner+w=401wt.eu-S1757186AbXFMItX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757186AbXFMItX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2007 04:49:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755255AbXFMItQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jun 2007 04:49:16 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:58832 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755199AbXFMItP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2007 04:49:15 -0400
Subject: Re: [PATCH 1/18] splice: abstract out actor data
From: Peter Zijlstra <peterz@infradead.org>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Eric Dumazet <dada1@cosmosbay.com>, linux-kernel@vger.kernel.org
In-Reply-To: <20070612162215.GM18832@kernel.dk>
References: <11816314942627-git-send-email-jens.axboe@oracle.com>
	 <11816314942637-git-send-email-jens.axboe@oracle.com>
	 <20070612173150.80f6f7e3.dada1@cosmosbay.com>
	 <20070612162215.GM18832@kernel.dk>
Content-Type: text/plain
Date: Wed, 13 Jun 2007 10:48:51 +0200
Message-Id: <1181724531.7348.338.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-06-12 at 18:22 +0200, Jens Axboe wrote:
> On Tue, Jun 12 2007, Eric Dumazet wrote:
> > On Tue, 12 Jun 2007 08:57:57 +0200
> > Jens Axboe <jens.axboe@oracle.com> wrote:
> > 
> > 
> > > +	struct splice_desc sd = {
> > > +		.total_len = len,
> > > +		.flags = flags,
> > > +		.pos = *ppos,
> > > +	};
> > > +
> > > +	sd.file = out;
> > 
> > minor remark, why sd.file is setup differently than other fields ?
> > 
> > (this several times on this patch)
> 
> yeah, it's inside an anonymous union, and apparently gcc doesn't like it
> being initialized that way.

The one time I had such a situation something along the lines of:

struct splice_desc sd = {
	.total_len = len,
	.flags = flags,
	.pos = *ppos,
	{ .file = out },
};

worked.

