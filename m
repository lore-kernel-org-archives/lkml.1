Return-Path: <linux-kernel-owner+w=401wt.eu-S1763756AbYALNMB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763756AbYALNMB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jan 2008 08:12:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762271AbYALNLy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Jan 2008 08:11:54 -0500
Received: from fg-out-1718.google.com ([72.14.220.158]:6048 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757853AbYALNLx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jan 2008 08:11:53 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=IlTLzuvWQ2j6WyK0v7jU84tclitYIEFzak1o3wf+NUcisa+6cDhq/HAooeimfk/U77N6fRAxp8l2FfhMyDIkCAj5hbcs8R4hRSJObrcQNP4t0iq7Kxo/tyBWHwJ6K4NhAxBX7P5s7jgn4Kg7J7m97Bq9l+iMul0jx2YXQVPPU58=
Date: Sat, 12 Jan 2008 14:13:31 +0100
From: Marcin Slusarz <marcin.slusarz@gmail.com>
To: Jan Kara <jack@suse.cz>
Cc: LKML <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 10/16] udf: create common function for changing free
	space counter
Message-ID: <20080112131309.GA24828@joi>
References: <1200002792-8449-1-git-send-email-marcin.slusarz@gmail.com> <1200002792-8449-11-git-send-email-marcin.slusarz@gmail.com> <20080110232449.GF17430@duck.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20080110232449.GF17430@duck.suse.cz>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 11, 2008 at 12:24:49AM +0100, Jan Kara wrote:
> On Thu 10-01-08 23:06:26, marcin.slusarz@gmail.com wrote:
> > Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
> > CC: Jan Kara <jack@suse.cz>
> > CC: Christoph Hellwig <hch@infradead.org>
>   Just two minor comment...
> 
> > ---
> >  fs/udf/balloc.c |   49 ++++++++++++++++++++-----------------------------
> >  1 files changed, 20 insertions(+), 29 deletions(-)
> > 
> > diff --git a/fs/udf/balloc.c b/fs/udf/balloc.c
> > index dc9f8a9..78dbf1d 100644
> > --- a/fs/udf/balloc.c
> > +++ b/fs/udf/balloc.c
> > @@ -140,6 +140,20 @@ static inline int load_block_bitmap(struct super_block *sb,
> >  	return slot;
> >  }
> >  
> > +static bool udf_inc_free_space(struct udf_sb_info *sbi,
>   Maybe because you use the function for both increasing and decreasing
> free space, you could call is udf_add_free_space?
Ok. Done.

> 
> > +				u16 partition, u32 cnt)
> > +{
> > +	struct logicalVolIntegrityDesc *lvid;
> > +
> > +	if (sbi->s_lvid_bh)
> > +		return false;
> > +
> > +	lvid = (struct logicalVolIntegrityDesc *)sbi->s_lvid_bh->b_data;
> > +	lvid->freeSpaceTable[partition] = cpu_to_le32(le32_to_cpu(
> > +					lvid->freeSpaceTable[partition]) + cnt);
>   I think macro like le32_add_cpu() just went into the kernel so you could
> use that...
I didn't want to rely on too many patches, so I intentionally left it.
I'll convert it together with other le*_add_cpu changes.

Can you ack this patch with udf_inc_free_space rename?

Marcin
