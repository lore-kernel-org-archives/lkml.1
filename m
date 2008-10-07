Return-Path: <linux-kernel-owner+w=401wt.eu-S1756635AbYJGUTk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756635AbYJGUTk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2008 16:19:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754584AbYJGUTa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Oct 2008 16:19:30 -0400
Received: from mail.suse.de ([195.135.220.2]:38527 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754226AbYJGUT3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2008 16:19:29 -0400
Date: Tue, 7 Oct 2008 13:19:27 -0700
From: Mark Fasheh <mfasheh@suse.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, joel.becker@oracle.com,
       ocfs2-devel@oss.oracle.com, linux-fsdevel@vger.kernel.org,
       tao.ma@oracle.com
Subject: Re: [PATCH 11/39] ocfs2: Add extent tree operation for xattr value btrees
Message-ID: <20081007201927.GD26373@wotan.suse.de>
Reply-To: Mark Fasheh <mfasheh@suse.com>
References: <1222293680-15451-1-git-send-email-mfasheh@suse.com> <1222293680-15451-12-git-send-email-mfasheh@suse.com> <20081001231201.ece971cf.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081001231201.ece971cf.akpm@linux-foundation.org>
Organization: SUSE Labs, Novell, Inc
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 01, 2008 at 11:12:01PM -0700, Andrew Morton wrote:
> > On Wed, 24 Sep 2008 15:00:52 -0700 Mark Fasheh <mfasheh@suse.com> wrote:
> > +	void *private;
> >  };
> >  
> >  static void ocfs2_dinode_set_last_eb_blk(struct ocfs2_extent_tree *et,
> > @@ -136,9 +137,50 @@ static struct ocfs2_extent_tree_operations ocfs2_dinode_et_ops = {
> >  	.sanity_check		= ocfs2_dinode_sanity_check,
> >  };
> >  
> > +static void ocfs2_xattr_value_set_last_eb_blk(struct ocfs2_extent_tree *et,
> > +					      u64 blkno)
> > +{
> > +	struct ocfs2_xattr_value_root *xv =
> > +		(struct ocfs2_xattr_value_root *)et->private;
> 
> unneeded and undesirable cast of void*
> 
> > +	xv->xr_last_eb_blk = cpu_to_le64(blkno);
> > +}
> > +
> > +static u64 ocfs2_xattr_value_get_last_eb_blk(struct ocfs2_extent_tree *et)
> > +{
> > +	struct ocfs2_xattr_value_root *xv =
> > +		(struct ocfs2_xattr_value_root *) et->private;
> 
> many etceteras.

Thanks, luckily though, it seems these got fixed later in the series :)
	--Mark

--
Mark Fasheh
