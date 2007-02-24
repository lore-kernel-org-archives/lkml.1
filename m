Return-Path: <linux-kernel-owner+w=401wt.eu-S932747AbXBXFQH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932747AbXBXFQH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Feb 2007 00:16:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932758AbXBXFQG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Feb 2007 00:16:06 -0500
Received: from cantor2.suse.de ([195.135.220.15]:49420 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932747AbXBXFQE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Feb 2007 00:16:04 -0500
Date: Sat, 24 Feb 2007 06:15:56 +0100
From: Nick Piggin <npiggin@suse.de>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [rfc][patch] dynamic resizing dentry hash using RCU
Message-ID: <20070224051556.GB16601@wotan.suse.de>
References: <20070223153743.GA26141@wotan.suse.de> <20070224130723.01f3c429.kamezawa.hiroyu@jp.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070224130723.01f3c429.kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 24, 2007 at 01:07:23PM +0900, KAMEZAWA Hiroyuki wrote:
> On Fri, 23 Feb 2007 16:37:43 +0100
> Nick Piggin <npiggin@suse.de> wrote:
> 
> > +static void dcache_hash_resize(unsigned int new_shift);
> > +static void mod_nr_dentry(int mod)
> > +{
> > +	unsigned long dentry_size;
> > +
> > +	dentry_stat.nr_dentry += mod;
> > +
> > +	dentry_size = 1 << dentry_hash->shift;
> > +	if (unlikely(dentry_stat.nr_dentry > dentry_size+(dentry_size>>1)))
> > +		dcache_hash_resize(dentry_hash->shift+1);
> > +	else if (unlikely(dentry_stat.nr_dentry < (dentry_size>>1)))
> > +		dcache_hash_resize(dentry_hash->shift-1);
> > +}
> > +
> 
> Do we need to do this kind of resizing in implicit automatic way ?
> I think it's good to show contention rate by /proc and add sysctl for
> resize this.

Well having the kernel automatically adjust to the workload is better
than a sysctl. But it could well be the case that these simple heuristics
are bad (though they're fine for my system).

But a manual override is a good idea as well.
