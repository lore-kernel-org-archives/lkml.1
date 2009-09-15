Return-Path: <linux-kernel-owner+w=401wt.eu-S1755210AbZIOHdb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755210AbZIOHdb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Sep 2009 03:33:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932106AbZIOHd1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Sep 2009 03:33:27 -0400
Received: from krynn.se.axis.com ([193.13.178.10]:59095 "EHLO
	krynn.se.axis.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758186AbZIOHd0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Sep 2009 03:33:26 -0400
Date: Tue, 15 Sep 2009 09:33:13 +0200
From: Jesper Nilsson <Jesper.Nilsson@axis.com>
To: Tim Abbott <tabbott@ksplice.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Sam Ravnborg <sam@ravnborg.org>,
       Mikael Starvik <mikael.starvik@axis.com>,
       dev-etrax <dev-etrax@axis.com>
Subject: Re: [PATCH] cris: Cleanup linker script using new linker script
	macros.
Message-ID: <20090915073313.GO4592@axis.com>
References: <1252292793-12674-1-git-send-email-tabbott@ksplice.com> <20090914085922.GG4592@axis.com> <alpine.DEB.1.10.0909141313310.31119@dr-wily.mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0909141313310.31119@dr-wily.mit.edu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 14, 2009 at 10:27:18PM +0200, Tim Abbott wrote:
> On Mon, 14 Sep 2009, Jesper Nilsson wrote:
> > On Mon, Sep 07, 2009 at 05:06:33AM +0200, Tim Abbott wrote:
> > >  	. = ALIGN (4);
> > >  	___data_start = . ;
> > >  	__Sdata = . ;
> > > -	.data : {			/* Data */
> > > -		DATA_DATA
> > > -	}
> > > +	RW_DATA_SECTION(0, PAGE_SIZE, PAGE_SIZE)
> > 
> > This causes some problems, and I'm not ldscript guru enough to immediately
> > grasp the problem. What I get is this:
> > 
> > ...
> >   LD      vmlinux
> > arch/cris/kernel/vmlinux.lds:326 cannot move location counter backwards (from c017e000 to 00000000)
> > make[1]: *** [vmlinux] Error 1
> > make: *** [sub-make] Error 2
> 
> Hmm.  I spent a bit looking at it, and I don't have a guess for what the 
> problem is there.
> 
> > I've dropped that part of the patch, and I'll try to
> > boot test the rest of the patch this week.
> 
> Yeah, it's probably fine to just drop it for now, since it has fairly 
> small cleanup impact on cris.
> 
> However, just dropping that hunk is not going to work -- you'll need to 
> re-add the .data.init_task hunk below (which had been part of 
> RW_DATA_SECTION).

Yes, sorry, I did that, but didn't mention it.
Or rather, I added: INIT_TASK_DATA_SECTION(PAGE_SIZE) instead.

> 	-Tim Abbott
> 
> > >  	__edata = . ;			/* End of data section. */
> > >  	_edata = . ;
> > >  
> > > -	. = ALIGN(PAGE_SIZE);	/* init_task and stack, must be aligned. */
> > > -	.data.init_task : { *(.data.init_task) }
> > > -
> > >  	. = ALIGN(PAGE_SIZE);		/* Init code and data. */
> > >  	__init_begin = .;

/^JN - Jesper Nilsson
-- 
               Jesper Nilsson -- jesper.nilsson@axis.com
