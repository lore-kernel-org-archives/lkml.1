Return-Path: <linux-kernel-owner+w=401wt.eu-S933618AbXCKXGv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933618AbXCKXGv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Mar 2007 19:06:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933643AbXCKXGQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Mar 2007 19:06:16 -0400
Received: from cantor2.suse.de ([195.135.220.15]:40642 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933637AbXCKXGG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Mar 2007 19:06:06 -0400
From: Neil Brown <neilb@suse.de>
To: Andy Isaacson <adi@hexapodia.org>
Date: Mon, 12 Mar 2007 10:05:52 +1100
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <17908.35664.68737.48529@notabene.brown>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] fix read past end of array in md/linear.c
In-Reply-To: message from Andy Isaacson on Thursday March 8
References: <20070308205204.GA12152@hexapodia.org>
	<20070308205341.GA13663@hexapodia.org>
X-Mailer: VM 7.19 under Emacs 21.4.1
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YD\ui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$\YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday March 8, adi@hexapodia.org wrote:
> On Thu, Mar 08, 2007 at 12:52:04PM -0800, Andy Isaacson wrote:
> > Index: linus/drivers/md/linear.c
> > ===================================================================
> > --- linus.orig/drivers/md/linear.c	2007-03-02 11:35:55.000000000 -0800
> > +++ linus/drivers/md/linear.c	2007-03-07 13:10:30.000000000 -0800
> > @@ -188,7 +188,7 @@
> >  	for (i=0; i < cnt-1 ; i++) {
> >  		sector_t sz = 0;
> >  		int j;
> > -		for (j=i; i<cnt-1 && sz < min_spacing ; j++)
> > +		for (j=i; j<cnt-1 && sz < min_spacing ; j++)
> >  			sz += conf->disks[j].size;
> >  		if (sz >= min_spacing && sz < conf->hash_spacing)
> >  			conf->hash_spacing = sz;
> 
> Forgot to add:
> 
> Signed-off-by: Andrew Isaacson <adi@hexapodia.org>

And
 Acked-by: NeilBrown <neilb@suse.de>

Thanks!

I would have replied earlier but I wanted to make sure I understood
exactly what the possible consequences of this bug were.. and they are
quite benign.
The worst possible outcome is going so far off the end of the array
that you hit un-mapped memory and Oops.

If that doesn't happen, then the next worst option is that the hash
table is sized poorly and you spend a few more cycles than needed
choosing the target device for the request (we still always choose the
right device).

Thanks,
NeilBrown
