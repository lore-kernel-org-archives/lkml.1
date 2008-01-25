Return-Path: <linux-kernel-owner+w=401wt.eu-S1755578AbYAYQLV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755578AbYAYQLV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 11:11:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752572AbYAYQLG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 11:11:06 -0500
Received: from fxip-0047f.externet.hu ([88.209.222.127]:57044 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752334AbYAYQLF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 11:11:05 -0500
To: jack@suse.cz
CC: miklos@szeredi.hu, gorcunov@gmail.com, akpm@linux-foundation.org,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
In-reply-to: <20080125160726.GB1767@duck.suse.cz> (message from Jan Kara on
	Fri, 25 Jan 2008 17:07:26 +0100)
Subject: Re: [patch 25/26] mount options: fix udf
References: <20080124193341.166753833@szeredi.hu> <20080124193456.220272889@szeredi.hu> <20080124202034.GC6724@cvg> <E1JIKsD-0001Kf-Bz@pomaz-ex.szeredi.hu> <20080125152702.GD28856@atrey.karlin.mff.cuni.cz> <E1JIQop-0002AW-TW@pomaz-ex.szeredi.hu> <20080125160726.GB1767@duck.suse.cz>
Message-Id: <E1JIR8n-0002Ec-MY@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Fri, 25 Jan 2008 17:10:53 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Fri 25-01-08 16:50:15, Miklos Szeredi wrote:
> > > > > | +	/* is this correct? */
> > > > > | +	if (sbi->s_anchor[2] != 0)
> > > > > | +		seq_printf(seq, ",anchor=%u", sbi->s_anchor[2]);
> > > > > 
> > > > > you know, I would prefer to use form UDF_SB_ANCHOR(sb)[2]
> > > > > in sake of style unification but we should wait for Jan's
> > > > > decision (i'm not the expert in this area ;)
> > > > 
> > > > I think UDF_SB_ANCHOR macro was removed by some patch in -mm.
> > >   Yes, it's going to be removed so don't use it. Actually, basing this
> > > patch on top of -mm is a good idea because there are quite some changes
> > > in Andrew's queue.
> > > 
> > > > I'm more interested if the second element of the s_anchor array really
> > > > does always have the value of the 'anchor=N' mount option.  I haven't
> > > > been able to verify that fully.  Do you have some insight into that?
> > >   As Cyrill wrote, it could be zeroed out in case there is no anchor in
> > > the specified block. So I guess you have to store the passed value
> > > somewhere else..
> > 
> > But in that case, would the value of the anchor= option matter?
>   No, it would not.
> 
> > This is actually a somewhat philosophical question about what the
> > mount options in /proc/mounts mean:
> > 
> >  1) Options _given_ by the user for the mount
> >  2) Options which are _effective_ for the mount
> > 
> > If we take interpretation 2) and there was no anchor (whatever that
> > means), then the anchor=N option wasn't effective, and not giving it
> > would have had the same effect.
> > 
> > This could be confusing to the user, though...
>   Hmm, given that options are modified by remount for some filesystems,
> it's probably the best to display the effective state. So your code should
> display the right thing as it is.

OK.  Cyrill, Jan, thanks for the reviews.

Miklos
