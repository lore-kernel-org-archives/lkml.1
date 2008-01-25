Return-Path: <linux-kernel-owner+w=401wt.eu-S1757998AbYAYP1V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757998AbYAYP1V (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 10:27:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756318AbYAYP1H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 10:27:07 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.31.123]:37033 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756255AbYAYP1D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 10:27:03 -0500
Date: Fri, 25 Jan 2008 16:27:02 +0100
From: Jan Kara <jack@suse.cz>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: gorcunov@gmail.com, akpm@linux-foundation.org,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       jack@suse.cz
Subject: Re: [patch 25/26] mount options: fix udf
Message-ID: <20080125152702.GD28856@atrey.karlin.mff.cuni.cz>
References: <20080124193341.166753833@szeredi.hu> <20080124193456.220272889@szeredi.hu> <20080124202034.GC6724@cvg> <E1JIKsD-0001Kf-Bz@pomaz-ex.szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1JIKsD-0001Kf-Bz@pomaz-ex.szeredi.hu>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > | +	/* is this correct? */
> > | +	if (sbi->s_anchor[2] != 0)
> > | +		seq_printf(seq, ",anchor=%u", sbi->s_anchor[2]);
> > 
> > you know, I would prefer to use form UDF_SB_ANCHOR(sb)[2]
> > in sake of style unification but we should wait for Jan's
> > decision (i'm not the expert in this area ;)
> 
> I think UDF_SB_ANCHOR macro was removed by some patch in -mm.
  Yes, it's going to be removed so don't use it. Actually, basing this
patch on top of -mm is a good idea because there are quite some changes
in Andrew's queue.

> I'm more interested if the second element of the s_anchor array really
> does always have the value of the 'anchor=N' mount option.  I haven't
> been able to verify that fully.  Do you have some insight into that?
  As Cyrill wrote, it could be zeroed out in case there is no anchor in
the specified block. So I guess you have to store the passed value
somewhere else..

									Honza
-- 
Jan Kara <jack@suse.cz>
SuSE CR Labs
