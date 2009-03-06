Return-Path: <linux-kernel-owner+w=401wt.eu-S1751555AbZCFJfe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751555AbZCFJfe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Mar 2009 04:35:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750810AbZCFJfZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Mar 2009 04:35:25 -0500
Received: from brick.kernel.dk ([93.163.65.50]:51929 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750744AbZCFJfY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Mar 2009 04:35:24 -0500
Date: Fri, 6 Mar 2009 10:35:21 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: scameron@beardog.cca.cpqcorp.net, linux-kernel@vger.kernel.org,
       mike.miller@hp.com, akpm@linux-foundation.org,
       linux-scsi@vger.kernel.org, coldwell@redhat.com, hare@novell.com,
       iss_storagedev@hp.com
Subject: Re: [PATCH] hpsa: SCSI driver for HP Smart Array controllers
Message-ID: <20090306093520.GV11787@kernel.dk>
References: <20090306085529.GP11787@kernel.dk> <20090306181302X.fujita.tomonori@lab.ntt.co.jp> <20090306092114.GS11787@kernel.dk> <20090306182705P.fujita.tomonori@lab.ntt.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090306182705P.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 06 2009, FUJITA Tomonori wrote:
> On Fri, 6 Mar 2009 10:21:14 +0100
> Jens Axboe <jens.axboe@oracle.com> wrote:
> 
> > On Fri, Mar 06 2009, FUJITA Tomonori wrote:
> > > On Fri, 6 Mar 2009 09:55:29 +0100
> > > Jens Axboe <jens.axboe@oracle.com> wrote:
> > > 
> > > > > If it's settable at init time, that would probably be enough for
> > > > > the vast majority of uses (and more flexible than what we have now)
> > > > > and a lot easier to implement.
> > > > 
> > > > Completely agree, don't waste time implementing something that nobody
> > > > will ever touch. The only reason to fiddle with such a setting would be
> > > > to increase it, because ios are too small. And even finding out that the
> > > > segment limit is the one killing you would take some insight and work
> > > > from the user.
> > > > 
> > > > Just make it Big Enough to cover most cases. 32 is definitely small, 256
> > > > entries would get you 1MB ios which I guess is more appropriate.
> > > 
> > > I guess that the dynamic scheme is overdoing but seems that vendors
> > > like some way to configure the sg entry size. The new MPT2SAS driver
> > > has SCSI_MPT2SAS_MAX_SGE kernel config option:
> > > 
> > > http://marc.info/?l=linux-scsi&m=123619290803547&w=2
> > > 
> > > 
> > > The kernel module option for this might be appropriate.
> > 
> > Dunno, still seems pretty pointless to me. The config option there
> > quotes memory consumption as the reason to reduce the number of sg
> > entries, however I think that's pretty silly. Additionally, a kernel
> > config entry just means that customers will be stuck with a fixed value
> > anyway. So I just don't see any merit to doing it that way either.
> 
> Yeah, agreed. the kernel config option is pretty pointless. But I'm
> not sure that reducing memory consumption is completely pointless.

Agree, depends on how you do it. If you preallocate all the memory
required for 1024 entries times the queue depth, then it may not be that
small. But you can do it a bit more cleverly than that, and then I don't
think it makes a lot of sense to provide any options for shrinking it.

-- 
Jens Axboe

