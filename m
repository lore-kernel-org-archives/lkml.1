Return-Path: <linux-kernel-owner+w=401wt.eu-S1758469AbYAYP5u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758469AbYAYP5u (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 10:57:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754518AbYAYP5n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 10:57:43 -0500
Received: from mu-out-0910.google.com ([209.85.134.191]:14809 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753276AbYAYP5k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 10:57:40 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=idhNvfcmzirG0O3ujxiY2BXmAw/63gfQmW4ESJmO/vBYCxChpNWPgS7b9qZ6fbzFzXUOkhssgx/K7xbpBCN6TzjFFw6BQf83bVdAZkfrfZ0HP7Mkb+m9N3RNuf7pjzGoVe2En92YbUch5ZFjr6pVizYW6SnGuvRbUf1aqkqKcAQ=
Date: Fri, 25 Jan 2008 18:57:18 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: jack@suse.cz, akpm@linux-foundation.org, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 25/26] mount options: fix udf
Message-ID: <20080125155718.GC7233@cvg>
References: <20080124193341.166753833@szeredi.hu> <20080124193456.220272889@szeredi.hu> <20080124202034.GC6724@cvg> <E1JIKsD-0001Kf-Bz@pomaz-ex.szeredi.hu> <20080125152702.GD28856@atrey.karlin.mff.cuni.cz> <E1JIQop-0002AW-TW@pomaz-ex.szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1JIQop-0002AW-TW@pomaz-ex.szeredi.hu>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Miklos Szeredi - Fri, Jan 25, 2008 at 04:50:15PM +0100]
| > > > | +	/* is this correct? */
| > > > | +	if (sbi->s_anchor[2] != 0)
| > > > | +		seq_printf(seq, ",anchor=%u", sbi->s_anchor[2]);
| > > > 
| > > > you know, I would prefer to use form UDF_SB_ANCHOR(sb)[2]
| > > > in sake of style unification but we should wait for Jan's
| > > > decision (i'm not the expert in this area ;)
| > > 
| > > I think UDF_SB_ANCHOR macro was removed by some patch in -mm.
| >   Yes, it's going to be removed so don't use it. Actually, basing this
| > patch on top of -mm is a good idea because there are quite some changes
| > in Andrew's queue.
| > 
| > > I'm more interested if the second element of the s_anchor array really
| > > does always have the value of the 'anchor=N' mount option.  I haven't
| > > been able to verify that fully.  Do you have some insight into that?
| >   As Cyrill wrote, it could be zeroed out in case there is no anchor in
| > the specified block. So I guess you have to store the passed value
| > somewhere else..
| 
| But in that case, would the value of the anchor= option matter?
| 
| This is actually a somewhat philosophical question about what the
| mount options in /proc/mounts mean:
| 
|  1) Options _given_ by the user for the mount
|  2) Options which are _effective_ for the mount
| 
| If we take interpretation 2) and there was no anchor (whatever that
| means), then the anchor=N option wasn't effective, and not giving it
| would have had the same effect.
| 
| This could be confusing to the user, though...
| 
| Thanks,
| Miklos
| 

I think _effective_ options is much more important - they could
show you that something bad happened (and if this zeroing of anchor
has been happened udf print debug message) Anyway, Miklos, I think
the options _given_ by a user does not mean anything in that case
because it just doesn't reveal what is being used in _real_.

		- Cyrill -
