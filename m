Return-Path: <linux-kernel-owner+w=401wt.eu-S1751827AbZJ2Hpj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751827AbZJ2Hpj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Oct 2009 03:45:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751333AbZJ2Hpj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Oct 2009 03:45:39 -0400
Received: from brick.kernel.dk ([93.163.65.50]:54829 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751328AbZJ2Hpi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Oct 2009 03:45:38 -0400
Date: Thu, 29 Oct 2009 08:45:42 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Mike Snitzer <snitzer@redhat.com>
Cc: Andrew Patterson <andrew.patterson@hp.com>,
       Mikulas Patocka <mpatocka@redhat.com>,
       device-mapper development <dm-devel@redhat.com>,
       Mark McLoughlin <markmc@redhat.com>, ". troy.heber"@hp.com,
       Rusty Russell <rusty@rustcorp.com.au>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       virtualization <virtualization@lists.linux-foundation.org>,
       Alasdair G Kergon <agk@redhat.com>
Subject: Re: block: silently error unsupported empty barriers too
Message-ID: <20091029074542.GX10727@kernel.dk>
References: <1249557257.3721.55.camel@blaa> <20090806114550.GL29899@agk-dp.fab.redhat.com> <Pine.LNX.4.64.0908062148060.8764@hs20-bc2-1.build.redhat.com> <1256761141.5830.79.camel@grinch> <20091028210325.GC1143@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091028210325.GC1143@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 28 2009, Mike Snitzer wrote:
> On Wed, Oct 28 2009 at  4:19pm -0400,
> Andrew Patterson <andrew.patterson@hp.com> wrote:
> 
> > On Thu, 2009-08-06 at 21:50 -0400, Mikulas Patocka wrote:
> > > On Thu, 6 Aug 2009, Alasdair G Kergon wrote:
> > > 
> > > > On Thu, Aug 06, 2009 at 12:14:17PM +0100, Mark McLoughlin wrote:
> > > > > We should error all barriers, even empty barriers, on devices like
> > > > > virtio_blk which don't support them.
> > > >  
> > > > Have you considered whether or not virtio_blk actually needs to
> > > > support empty barriers?
> > > > 
> > > > Alasdair
> > > 
> > > This is only for request-based drivers, where it is the responsibility of 
> > > blk-core to translate barriers. I think the empty barrier request anyway 
> > > in blk_do_ordered, but with an error message. So the patch changes it to 
> > > discard it early and queitly. It seems ok.
> > > 
> > > Mikulas
> > > --
> > 
> > This patch seems to have been dropped.  I can reproduce the error using
> > the following:
> > 
> >      1. Create an LVM logical volume on top of a cciss device (note that
> >         the cciss driver does not support barriers)
> >      2. Create an ext3 file system on top of the logical volume
> >      3. Mount the file-system using -obarrier=1
> >      4. Copy some files onto the file-system
> >      5. Run sync (dm_flush is called)
> > 
> > If I apply the patch (with some munging), the 
> > 
> > "end_request: I/O error, dev cciss/cXdY, sector 0"
> > 
> > messages go away.
> > 
> > This is not strictly a regression, given that the problem was introduced
> > in 2.6.31, but I think it should still be fixed for 2.6.32.
> 
> It was resubmitted last Friday:
> http://lkml.org/lkml/2009/10/23/196
> 
> And is queued in Jens' 'for-linus' branch (meaning it should get
> upstream in time for 2.6.32), see:
> http://git.kernel.org/?p=linux/kernel/git/axboe/linux-2.6-block.git;a=commit;h=6cafb12dc85a5bdc722791cc5070968413264909

I sent out a pull request yesterday, but it isn't in yet. Any day now...

-- 
Jens Axboe

