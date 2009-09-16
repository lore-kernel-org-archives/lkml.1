Return-Path: <linux-kernel-owner+w=401wt.eu-S1751585AbZIPPe0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751585AbZIPPe0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 11:34:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752729AbZIPPeX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 11:34:23 -0400
Received: from kroah.org ([198.145.64.141]:33667 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752596AbZIPPeT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 11:34:19 -0400
Date: Wed, 16 Sep 2009 08:34:16 -0700
From: Greg KH <greg@kroah.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       devel@driverdev.osuosl.org
Subject: Re: [GIT PATCH] STAGING patches for 2.6.31-git
Message-ID: <20090916153416.GA27133@kroah.com>
References: <20090915190520.GA834@kroah.com>
 <alpine.LFD.2.01.0909160813400.4950@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.01.0909160813400.4950@localhost.localdomain>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 16, 2009 at 08:26:14AM -0700, Linus Torvalds wrote:
> 
> 
> On Tue, 15 Sep 2009, Greg KH wrote:
> > 
> > Overall, we almost broke even with our cleanups and removals for what
> > was done here:
> >  1267 files changed, 297615 insertions(+), 214568 deletions(-)
> 
> Actually, it's
> 
>  1253 files changed, 287789 insertions(+), 209389 deletions(-)
> 
> but there are so many changed files that the default rename detection 
> limit kicks in, and your git will have only looked at 100% identical 
> renames. So you missed things like:
> 
>  rename drivers/staging/{rt2860 => rt3090}/link_list.h (99%)
>  copy drivers/staging/{rt2870/md4.h => rt3090/mlme_ex.h} (56%)
>  copy drivers/staging/{rt2860/md4.h => rt3090/mlme_ex_def.h} (67%)
>  copy drivers/staging/{rt2860/md4.h => rt3090/netif_block.h} (72%)
>  rename drivers/staging/{rt2870/md4.h => rt3090/rt33xx.h} (79%)
>  ...
> 
> Now, admittedly the 'copy' ones are dubious: it's picking up on the 
> f*cking Ralink GPL copyright template, which is the bulk of those files. 
> But that in itself is interesting information, even if I personally find 
> mindless copyright templates very annoying.
> 
> Anyway, extended rename detection (ie the non-exact one that can't just 
> look at the SHA1's and say "those are identical") gets disabled if your 
> rename matrix is large (cost function: n*m where 'n' is number of added 
> files, and 'm' is number of deleted ones), which triggers for your staging 
> tree because you had both deletions and creations.
> 
> The default git limit is set fairly low, because it's set for small 
> machines with limited amounts of memory in particular. I suspect you might 
> want to add
> 
> 	[diff]
> 		renamelimit=0
> 
> to your ~/.gitconfig, since you probably don't use particularly weak 
> machines, and that will disable the limiting. Then you'd get the full 
> renames in all their glory.

Ah, ok, will do, didn't know about that.  Thanks for the info.

> Without it, you'll see just:
> 
>  copy drivers/staging/{rtl8192su => rtl8192e}/dot11d.h (100%)
>  rename drivers/staging/{rtl8192su => rtl8192e/ieee80211}/dot11d.h (100%)
>  rename drivers/staging/{rtl8192su => rtl8192e}/ieee80211/rtl_crypto.h (100%)
>  rename drivers/staging/{rtl8187se => rtl8192e}/ieee80211_crypt.h (100%)
> 
> while with it, you'll see examples of lots of cases of header files where 
> there is more copyright header than actual content ;(

Yeah, this company is known for just taking a whole new version of
everything for their next driver, and only changing tiny bits.  It's
something I'm working on getting resolved with them...

thanks,

greg k-h
