Return-Path: <linux-kernel-owner+w=401wt.eu-S1751790AbZEYLdA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751790AbZEYLdA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 May 2009 07:33:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751221AbZEYLcv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 May 2009 07:32:51 -0400
Received: from cantor.suse.de ([195.135.220.2]:33749 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751092AbZEYLcv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 May 2009 07:32:51 -0400
Date: Mon, 25 May 2009 13:32:51 +0200
From: Nick Piggin <npiggin@suse.de>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Jens Axboe <jens.axboe@oracle.com>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, chris.mason@oracle.com,
       david@fromorbit.com, hch@infradead.org, akpm@linux-foundation.org,
       jack@suse.cz, yanmin_zhang@linux.intel.com,
       Christoph Lameter <cl@linux-foundation.org>,
       Matthew Wilcox <willy@linux.intel.com>
Subject: Re: [PATCH 03/13] scsi: unify allocation of scsi command and sense buffer
Message-ID: <20090525113251.GC24071@wotan.suse.de>
References: <1243236668-3398-1-git-send-email-jens.axboe@oracle.com> <1243236668-3398-6-git-send-email-jens.axboe@oracle.com> <84144f020905250115m1dffb51er51f8f339ab58a704@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <84144f020905250115m1dffb51er51f8f339ab58a704@mail.gmail.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 25, 2009 at 11:15:42AM +0300, Pekka Enberg wrote:
> On Mon, May 25, 2009 at 10:30 AM, Jens Axboe <jens.axboe@oracle.com> wrote:
> > Fold the sense buffer into the command, thereby eliminating a slab
> > allocation and free per command.
> >
> > Signed-off-by: Jens Axboe <jens.axboe@oracle.com>
> 
> Interesting. I wonder how this affects the SLAB vs. SLUB regression
> people are seeing on high end machines in OLTP benchmarks.

It could improve it. I think these (bios, requests, commands etc) allocations
are what SLUB has trouble with in that workload, so eliminating one of them
should help it. I guess it will help the other allocators as well, but maybe
a smaller relative improvement?

