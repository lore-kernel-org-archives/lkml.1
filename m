Return-Path: <linux-kernel-owner+w=401wt.eu-S1760601AbYB2Smq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760601AbYB2Smq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Feb 2008 13:42:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932456AbYB2SmV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Feb 2008 13:42:21 -0500
Received: from mx1.redhat.com ([66.187.233.31]:56829 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757822AbYB2SmU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Feb 2008 13:42:20 -0500
Subject: Re: [IA64] fix userspace compile error in gcc_intrin.h
From: Doug Chapman <doug.chapman@hp.com>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Tony Luck <tony.luck@intel.com>
In-Reply-To: <1204309483.18955.66.camel@shinybook.infradead.org>
References: <200802052007.m15K7vuv005319@hera.kernel.org>
	 <1204309483.18955.66.camel@shinybook.infradead.org>
Content-Type: text/plain
Date: Fri, 29 Feb 2008 13:41:30 -0500
Message-Id: <1204310490.8186.11.camel@athlon>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-1.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 2008-02-29 at 13:24 -0500, David Woodhouse wrote:
> On Tue, 2008-02-05 at 20:07 +0000, Linux Kernel Mailing List wrote:
> > Gitweb:     http://git.kernel.org/git/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=0df29025fd0379d5950d206314d0b10a2c8a9607
> > Commit:     0df29025fd0379d5950d206314d0b10a2c8a9607
> > Parent:     d2fc0bacd5c438cb459fdf531eff00ab18422a00
> > Author:     Doug Chapman <doug.chapman@hp.com>
> > AuthorDate: Mon Jan 28 15:33:28 2008 -0800
> > Committer:  Tony Luck <tony.luck@intel.com>
> > CommitDate: Mon Feb 4 15:08:25 2008 -0800
> > 
> >     [IA64] fix userspace compile error in gcc_intrin.h
> >     
> >     Fixes userspace build errors when linux/ipv6.h is included such as in the
> >     dhcpv6 package under fedora.  Likely causes other userspace build errors as
> >     well.  I found this in akpm's tree from 2.6.18 but could not find any case
> >     of anyone proposing it for the main tree.
> >     
> >     Signed-off-by: Doug Chapman <doug.chapman@hp.com>
> >     Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> >     Signed-off-by: Tony Luck <tony.luck@intel.com>
> > ---
> >  include/asm-ia64/gcc_intrin.h |    2 ++
> >  1 files changed, 2 insertions(+), 0 deletions(-)
> > 
> > diff --git a/include/asm-ia64/gcc_intrin.h b/include/asm-ia64/gcc_intrin.h
> > index 5b6665c..de2ed2c 100644
> > --- a/include/asm-ia64/gcc_intrin.h
> > +++ b/include/asm-ia64/gcc_intrin.h
> > @@ -24,7 +24,9 @@
> >  extern void ia64_bad_param_for_setreg (void);
> >  extern void ia64_bad_param_for_getreg (void);
> >  
> > +#ifdef __KERNEL__
> >  register unsigned long ia64_r13 asm ("r13") __used;
> > +#endif
> >  
> >  #define ia64_setreg(regnum, val)						\
> >  ({										\
> 
> You also want to move gcc_interin.h from $(header-y) to $(unifdef-y) in
> include/asm-ia64/Kbuild.
> 

David,

Thanks for catching that.  I will post a patch for the Kbuild part later
today.

- Doug


