Return-Path: <linux-kernel-owner+w=401wt.eu-S935821AbZLPWCX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935821AbZLPWCX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 17:02:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935812AbZLPWCM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 17:02:12 -0500
Received: from rcsinet12.oracle.com ([148.87.113.124]:59134 "EHLO
	rcsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935813AbZLPWCG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 17:02:06 -0500
Date: Wed, 16 Dec 2009 14:02:01 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Borislav Petkov <petkovbb@googlemail.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>,
       Borislav Petkov <borislav.petkov@amd.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -next] x86 msrs: alloc/free for CONFIG_SMP=n
Message-Id: <20091216140201.5ef21b90.randy.dunlap@oracle.com>
In-Reply-To: <20091216215808.GB27228@liondog.tnic>
References: <20091216183212.118c5e14.sfr@canb.auug.org.au>
	<20091216092424.5f87214c.randy.dunlap@oracle.com>
	<4B2919BD.40001@zytor.com>
	<20091216174524.GH11618@aftab>
	<4B2928AC.3020807@zytor.com>
	<20091216135119.e283e525.randy.dunlap@oracle.com>
	<20091216215808.GB27228@liondog.tnic>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Auth-Type: Internal IP
X-Source-IP: acsinet15.oracle.com [141.146.126.227]
X-CT-RefId: str=0001.0A090208.4B2958D6.0212:SCFMA922111,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 16 Dec 2009 22:58:08 +0100 Borislav Petkov wrote:

> On Wed, Dec 16, 2009 at 01:51:19PM -0800, Randy Dunlap wrote:
> > From: Randy Dunlap <randy.dunlap@oracle.com>
> > 
> > Rearrange arch/x86/lib/msr.c so that alloc/free are built and
> > usable when CONFIG_SMP=n.  Fixes build of amd64_edac.
> > 
> > ERROR: "msrs_free" [drivers/edac/amd64_edac_mod.ko] undefined!
> > ERROR: "msrs_alloc" [drivers/edac/amd64_edac_mod.ko] undefined!
> >
> > ---
> >  arch/x86/lib/Makefile |    2 -
> >  arch/x86/lib/msr.c    |   42 ++++++++++++++++++++--------------------
> >  2 files changed, 23 insertions(+), 21 deletions(-)
> 
> Haha, I just sent a very similar one :)

Yes, I noticed.

> > 
> > --- linux-next-20091216.orig/arch/x86/lib/Makefile
> > +++ linux-next-20091216/arch/x86/lib/Makefile
> > @@ -14,7 +14,7 @@ $(obj)/inat.o: $(obj)/inat-tables.c
> >  
> >  clean-files := inat-tables.c
> >  
> > -obj-$(CONFIG_SMP) := msr.o
> > +obj-$(CONFIG_X86_MSR) := msr.o
> 
> however, CONFIG_X86_MSR is the x86 MSR access module and the <lib/msr.c>
> is the library of MSR accessing functions which is always in. So this
> should be unconditional as in my version or Peter might have a better
> idea...?

Sure, whichever is OK with me.

---
~Randy
