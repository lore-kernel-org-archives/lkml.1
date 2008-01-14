Return-Path: <linux-kernel-owner+w=401wt.eu-S1754857AbYANJ5L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754857AbYANJ5L (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2008 04:57:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752097AbYANJ46
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jan 2008 04:56:58 -0500
Received: from styx.suse.cz ([82.119.242.94]:38989 "EHLO duck.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751969AbYANJ45 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2008 04:56:57 -0500
Date: Mon, 14 Jan 2008 10:56:55 +0100
From: Jan Kara <jack@suse.cz>
To: Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 10/16] udf: create common function for changing free
	space counter
Message-ID: <20080114095655.GA4214@duck.suse.cz>
References: <1200002792-8449-1-git-send-email-marcin.slusarz@gmail.com> <1200002792-8449-11-git-send-email-marcin.slusarz@gmail.com> <20080110232449.GF17430@duck.suse.cz> <20080112131309.GA24828@joi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080112131309.GA24828@joi>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat 12-01-08 14:13:31, Marcin Slusarz wrote:
> On Fri, Jan 11, 2008 at 12:24:49AM +0100, Jan Kara wrote:
> > On Thu 10-01-08 23:06:26, marcin.slusarz@gmail.com wrote:
> > > Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
> > > CC: Jan Kara <jack@suse.cz>
> > > CC: Christoph Hellwig <hch@infradead.org>
> >   Just two minor comment...
> > 
> > > ---
> > >  fs/udf/balloc.c |   49 ++++++++++++++++++++-----------------------------
> > >  1 files changed, 20 insertions(+), 29 deletions(-)
> > > 
> > > diff --git a/fs/udf/balloc.c b/fs/udf/balloc.c
> > > index dc9f8a9..78dbf1d 100644
> > > --- a/fs/udf/balloc.c
> > > +++ b/fs/udf/balloc.c
> > > @@ -140,6 +140,20 @@ static inline int load_block_bitmap(struct super_block *sb,
> > >  	return slot;
> > >  }
> > >  
> > > +static bool udf_inc_free_space(struct udf_sb_info *sbi,
> >   Maybe because you use the function for both increasing and decreasing
> > free space, you could call is udf_add_free_space?
> Ok. Done.
> 
> > 
> > > +				u16 partition, u32 cnt)
> > > +{
> > > +	struct logicalVolIntegrityDesc *lvid;
> > > +
> > > +	if (sbi->s_lvid_bh)
> > > +		return false;
> > > +
> > > +	lvid = (struct logicalVolIntegrityDesc *)sbi->s_lvid_bh->b_data;
> > > +	lvid->freeSpaceTable[partition] = cpu_to_le32(le32_to_cpu(
> > > +					lvid->freeSpaceTable[partition]) + cnt);
> >   I think macro like le32_add_cpu() just went into the kernel so you could
> > use that...
> I didn't want to rely on too many patches, so I intentionally left it.
> I'll convert it together with other le*_add_cpu changes.
  OK, fair enough.

> Can you ack this patch with udf_inc_free_space rename?
  Yes.
  Acked-by: Jan Kara <jack@suse.cz>

										Honza

-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
