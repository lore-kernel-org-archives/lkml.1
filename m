Return-Path: <linux-kernel-owner+w=401wt.eu-S1759502AbZJMLcJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759502AbZJMLcJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 07:32:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756504AbZJMLcI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 07:32:08 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59046 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754466AbZJMLcH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 07:32:07 -0400
Date: Tue, 13 Oct 2009 13:30:20 +0200 (CEST)
From: John Kacur <jkacur@redhat.com>
X-X-Sender: jkacur@localhost.localdomain
To: Greg Ungerer <gerg@snapgear.com>, Thomas Gleixner <tglx@linutronix.de>
cc: linux-kernel@vger.kernel.org, Frederic Weisbecker <fweisbec@gmail.com>,
       Vincent Sanders <vince@simtec.co.uk>, Ingo Molnar <mingo@elte.hu>,
       Christoph Hellwig <hch@infradead.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jonathan Corbet <corbet@lwn.net>, Mike Frysinger <vapier@gentoo.org>,
       David Howells <dhowells@redhat.com>,
       Yoshinori Sato <ysato@users.sourceforge.jp>,
       Roman Zippel <zippel@linux-m68k.org>, Greg Ungerer <gerg@uclinux.org>,
       Koichi Yasutake <yasutake.koichi@jp.panasonic.com>
Subject: Re: [PATCH 5/6 RFC] arch/m68knommu/kernel/process.c: Remove the BKL
 from sys_execve
In-Reply-To: <4AD45A06.2090606@snapgear.com>
Message-ID: <alpine.LFD.2.00.0910131328260.3781@localhost.localdomain>
References: <alpine.LFD.2.00.0910122350140.3658@localhost.localdomain> <alpine.LFD.2.00.0910130007240.3658@localhost.localdomain> <alpine.LFD.2.00.0910130008320.3658@localhost.localdomain> <alpine.LFD.2.00.0910130010000.3658@localhost.localdomain>
 <alpine.LFD.2.00.0910130011180.3658@localhost.localdomain> <alpine.LFD.2.00.0910130014520.3658@localhost.localdomain> <4AD45A06.2090606@snapgear.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 13 Oct 2009, Greg Ungerer wrote:

> Hi John,
> 
> On 10/13/2009 08:34 AM, John Kacur wrote:
> > > From e36c53d296132bc0ddbf6d9fb43ea5ea56dbd4a2 Mon Sep 17 00:00:00 2001
> > From: John Kacur<jkacur@redhat.com>
> > Date: Mon, 12 Oct 2009 23:37:28 +0200
> > Subject: [PATCH] arch/m68knommu/kernel/process.c: Remove the BKL from
> > sys_execve
> > 
> > This looks like a copy-and-paste of functionality that no-longer needs the
> > bkl.
> > Just remove it.
> > 
> > Signed-off-by: John Kacur<jkacur@redhat.com>
> 
> Tested and runs fine on m68knommu.
> 
> Acked-by: Greg Ungerer <gerg@uclinux.org>
> 
> Do you want me to push this into the m68knommu git tree,
> for eventual merging into Linus' tree?  Or are you going
> to push the whole set of patches together?
> 
> Regards
> Greg
 
@Thomas - do you want to pick this up for your proposed kill bkl tree and
push it to Linus during this next merge window - or in this case is it 
more appropriate for Greg as the m68knommu maintainer to do so?

Thanks

John 

 
> > ---
> >   arch/m68knommu/kernel/process.c |    5 +----
> >   1 files changed, 1 insertions(+), 4 deletions(-)
> > 
> > diff --git a/arch/m68knommu/kernel/process.c
> > b/arch/m68knommu/kernel/process.c
> > index 8f8f4ab..5c9ecd4 100644
> > --- a/arch/m68knommu/kernel/process.c
> > +++ b/arch/m68knommu/kernel/process.c
> > @@ -352,15 +352,12 @@ asmlinkage int sys_execve(char *name, char **argv,
> > char **envp)
> >   	char * filename;
> >   	struct pt_regs *regs = (struct pt_regs *)&name;
> > 
> > -	lock_kernel();
> >   	filename = getname(name);
> >   	error = PTR_ERR(filename);
> >   	if (IS_ERR(filename))
> > -		goto out;
> > +		return error;
> >   	error = do_execve(filename, argv, envp, regs);
> >   	putname(filename);
> > -out:
> > -	unlock_kernel();
> >   	return error;
> >   }
> > 
> 
> -- 
> ------------------------------------------------------------------------
> Greg Ungerer  --  Principal Engineer        EMAIL:     gerg@snapgear.com
> SnapGear Group, McAfee                      PHONE:       +61 7 3435 2888
> 825 Stanley St,                             FAX:         +61 7 3891 3630
> Woolloongabba, QLD, 4102, Australia         WEB: http://www.SnapGear.com
> 
