Return-Path: <linux-kernel-owner+w=401wt.eu-S932438AbXLTMv5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932438AbXLTMv5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 07:51:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759624AbXLTMvs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 07:51:48 -0500
Received: from styx.suse.cz ([82.119.242.94]:54893 "EHLO duck.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754102AbXLTMvr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 07:51:47 -0500
Date: Thu, 20 Dec 2007 13:51:45 +0100
From: Jan Kara <jack@suse.cz>
To: Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: linux-kernel@vger.kernel.org,
       Ben Fennema <bfennema@falcon.csc.calpoly.edu>
Subject: Re: [PATCH 6/6] udf: fix sparse warnings (shadowing & mismatch
	between declaration and definition)
Message-ID: <20071220125145.GB9125@duck.suse.cz>
References: <20071216021741.GG26986@joi> <20071217165017.GJ6979@atrey.karlin.mff.cuni.cz> <20071219183511.GC18104@joi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071219183511.GC18104@joi>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 19-12-07 19:35:14, Marcin Slusarz wrote:
> On Mon, Dec 17, 2007 at 05:50:17PM +0100, Jan Kara wrote:
> > > fix warnings:
> > > fs/udf/super.c:1320:24: warning: symbol 'bh' shadows an earlier one
> > > fs/udf/super.c:1240:21: originally declared here
> > > fs/udf/super.c:1583:4: warning: symbol 'i' shadows an earlier one
> > > fs/udf/super.c:1418:6: originally declared here
> > > fs/udf/super.c:1585:4: warning: symbol 'i' shadows an earlier one
> > > fs/udf/super.c:1418:6: originally declared here
> > > fs/udf/super.c:1658:4: warning: symbol 'i' shadows an earlier one
> > > fs/udf/super.c:1648:6: originally declared here
> > > fs/udf/super.c:1660:4: warning: symbol 'i' shadows an earlier one
> > > fs/udf/super.c:1648:6: originally declared here
> > > fs/udf/super.c:450:6: warning: symbol 'udf_write_super' was not declared. Should it be static?
> > >
> > > Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
> > > CC: Ben Fennema <bfennema@falcon.csc.calpoly.edu>
> >   Thanks for the patch.  The 'bh' change is fine. The problems with 'i'
> > should be solved differently I think. Those functions UDF_SB_FREE,
> > UDF_SB_ALLOC_PARTMAPS should be functions and not macros. Please convert
> > those to either inline functions if they are small or to regular
> > functions if they are larger.  It won't be completely trivial because of
> > the hackery e.g. in UDF_SB_ALLOC_BITMAP. It gets an argument meaning on
> > which struct member something should be performed. But for example in
> > the UDF_SB_ALLOC_BITMAP case you can simply make the function return the
> > pointer to allocated and initialized space and the caller would assign
> > it to a proper element of the superblock.
> Ok, I'll try to do it.
  Thanks.

> > This would help the overall
> > code quality of UDF (which is sadly quite poor).
> If you have other suggestions how to clean up this code, let me know.
> I'll see what I can do with them ;)
  Hmm, it's hard to formulate precisely. It's nothing particular but all in
all the code is simply hard to read - all those strange names of variables,
unusual sideeffects of functions, ... But one specific problem I'm aware of
is the lack of error handling so in case of IO error or filesystem
corruption results are quite spectacular (kernel crash, etc.).

									Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
