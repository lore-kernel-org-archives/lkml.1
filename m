Return-Path: <linux-kernel-owner+w=401wt.eu-S1751407AbXE2WGe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751407AbXE2WGe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2007 18:06:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751101AbXE2WGQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 May 2007 18:06:16 -0400
Received: from mx1.redhat.com ([66.187.233.31]:60024 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751000AbXE2WGN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2007 18:06:13 -0400
Date: Tue, 29 May 2007 23:05:00 +0100
From: Alasdair G Kergon <agk@redhat.com>
To: Stefan Bader <sbader3@googlemail.com>
Cc: device-mapper development <dm-devel@redhat.com>,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-raid@vger.kernel.org, Jens Axboe <jens.axboe@oracle.com>,
       David Chinner <dgc@sgi.com>, Phillip Susi <psusi@cfl.rr.com>,
       Stefan Bader <Stefan.Bader@de.ibm.com>,
       Andreas Dilger <adilger@clusterfs.com>, Tejun Heo <htejun@gmail.com>
Subject: Re: [dm-devel] Re: [RFD] BIO_RW_BARRIER - what it means for devices, filesystems, and dm/md.
Message-ID: <20070529220500.GA6513@agk.fab.redhat.com>
Mail-Followup-To: Stefan Bader <sbader3@googlemail.com>,
	device-mapper development <dm-devel@redhat.com>,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-raid@vger.kernel.org, Jens Axboe <jens.axboe@oracle.com>,
	David Chinner <dgc@sgi.com>, Phillip Susi <psusi@cfl.rr.com>,
	Stefan Bader <Stefan.Bader@de.ibm.com>,
	Andreas Dilger <adilger@clusterfs.com>,
	Tejun Heo <htejun@gmail.com>
References: <18006.38689.818186.221707@notabene.brown> <18010.12472.209452.148229@notabene.brown> <20070528094358.GM25091@agk.fab.redhat.com> <5201e28f0705290225v14fdac44hb0382a4137a84d01@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5201e28f0705290225v14fdac44hb0382a4137a84d01@mail.gmail.com>
User-Agent: Mutt/1.4.1i
Organization: Red Hat UK Ltd. Registered in England and Wales, number 03798903. Registered Office: Amberley Place, 107-111 Peascod Street, Windsor, Berkshire, SL4 1TE.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 29, 2007 at 11:25:42AM +0200, Stefan Bader wrote:
> doing a sort of suspend, issuing the
> barrier request, calling flush to all mapped devices and then wait for
> in-flight I/O to go to zero? 

Something like that is needed for some dm targets to support barriers.
(We needn't always wait for *all* in-flight I/O.)
When faced with -EOPNOTSUP, do all callers fall back to a sync in
the places a barrier would have been used, or are there any more
sophisticated strategies attempting to optimise code without barriers?

> I am not a hundred percent sure about
> that but I think that just passing the barrier flag on to mapped
> devices might in some (maybe they are rare) cases cause a layer above
> to think all data is on-disk while this isn't necessarily true (see my
> previous post). What do you think?

An efficient I/O barrier implementation would not normally involve
flushing AFAIK: dm surely wouldn't "cause" a higher layer to assume
stronger semantics than are provided.
 
Alasdair
-- 
agk@redhat.com
