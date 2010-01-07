Return-Path: <linux-kernel-owner+w=401wt.eu-S1752884Ab0AGSA7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752884Ab0AGSA7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jan 2010 13:00:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752558Ab0AGSA4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jan 2010 13:00:56 -0500
Received: from cantor2.suse.de ([195.135.220.15]:50549 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752626Ab0AGSAy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jan 2010 13:00:54 -0500
Date: Thu, 7 Jan 2010 09:58:09 -0800
From: Greg KH <gregkh@suse.de>
To: Mike Frysinger <vapier.adi@gmail.com>
Cc: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, David Howells <dhowells@redhat.com>,
       James Morris <jmorris@namei.org>
Subject: Re: [PATCH 59/97] NOMMU: Optimise away the {dac_,}mmap_min_addr
 tests
Message-ID: <20100107175809.GA17276@suse.de>
References: <20100105003133.GA7199@kroah.com>
 <1262651630-7354-59-git-send-email-gregkh@suse.de>
 <8bd0f97a1001061803xe3cdd80l1a3c416902452134@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <8bd0f97a1001061803xe3cdd80l1a3c416902452134@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 06, 2010 at 09:03:31PM -0500, Mike Frysinger wrote:
> On Mon, Jan 4, 2010 at 19:33, Greg Kroah-Hartman wrote:
> > --- a/kernel/sysctl.c
> > +++ b/kernel/sysctl.c
> > @@ -1200,6 +1200,7 @@ static struct ctl_table vm_table[] = {
> >                .extra2         = (void *)&hugetlb_infinity,
> >        },
> >  #endif
> > +#ifdef CONFIG_MMU
> >        {
> >                .ctl_name       = VM_LOWMEM_RESERVE_RATIO,
> >                .procname       = "lowmem_reserve_ratio",
> > @@ -1353,6 +1354,7 @@ static struct ctl_table vm_table[] = {
> >                .mode           = 0644,
> >                .proc_handler   = &mmap_min_addr_handler,
> >        },
> > +#endif
> >  #ifdef CONFIG_NUMA
> >        {
> >                .ctl_name       = CTL_UNNUMBERED,
> 
> seems there was a merge error here when adding the patch to the stable
> branch.  this change disables a large number of things when it should
> only be disabling mmap_min_addr.  notice how the first #ifdef appears
> at line ~1200 while the second appears at line ~1353.  the original
> commit was ~1214 to ~1221.

Ah crap :(

Can you send me a patch against 2.6.32.3 that fixes this up so I can get
a new release out with it?

thanks,

greg k-h
