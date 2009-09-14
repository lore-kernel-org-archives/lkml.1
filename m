Return-Path: <linux-kernel-owner+w=401wt.eu-S933886AbZINU1a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933886AbZINU1a (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Sep 2009 16:27:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933864AbZINU13
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Sep 2009 16:27:29 -0400
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:34866 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933829AbZINU12 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Sep 2009 16:27:28 -0400
Date: Mon, 14 Sep 2009 16:27:18 -0400 (EDT)
From: Tim Abbott <tabbott@ksplice.com>
X-X-Sender: tabbott@dr-wily.mit.edu
To: Jesper Nilsson <Jesper.Nilsson@axis.com>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Sam Ravnborg <sam@ravnborg.org>,
       Mikael Starvik <mikael.starvik@axis.com>,
       dev-etrax <dev-etrax@axis.com>
Subject: Re: [PATCH] cris: Cleanup linker script using new linker script
 macros.
In-Reply-To: <20090914085922.GG4592@axis.com>
Message-ID: <alpine.DEB.1.10.0909141313310.31119@dr-wily.mit.edu>
References: <1252292793-12674-1-git-send-email-tabbott@ksplice.com> <20090914085922.GG4592@axis.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Flag: NO
X-Spam-Score: 0.00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 14 Sep 2009, Jesper Nilsson wrote:

> On Mon, Sep 07, 2009 at 05:06:33AM +0200, Tim Abbott wrote:
> >  	. = ALIGN (4);
> >  	___data_start = . ;
> >  	__Sdata = . ;
> > -	.data : {			/* Data */
> > -		DATA_DATA
> > -	}
> > +	RW_DATA_SECTION(0, PAGE_SIZE, PAGE_SIZE)
> 
> This causes some problems, and I'm not ldscript guru enough to immediately
> grasp the problem. What I get is this:
> 
> ...
>   LD      vmlinux
> arch/cris/kernel/vmlinux.lds:326 cannot move location counter backwards (from c017e000 to 00000000)
> make[1]: *** [vmlinux] Error 1
> make: *** [sub-make] Error 2

Hmm.  I spent a bit looking at it, and I don't have a guess for what the 
problem is there.

> I've dropped that part of the patch, and I'll try to
> boot test the rest of the patch this week.

Yeah, it's probably fine to just drop it for now, since it has fairly 
small cleanup impact on cris.

However, just dropping that hunk is not going to work -- you'll need to 
re-add the .data.init_task hunk below (which had been part of 
RW_DATA_SECTION).

	-Tim Abbott

> >  	__edata = . ;			/* End of data section. */
> >  	_edata = . ;
> >  
> > -	. = ALIGN(PAGE_SIZE);	/* init_task and stack, must be aligned. */
> > -	.data.init_task : { *(.data.init_task) }
> > -
> >  	. = ALIGN(PAGE_SIZE);		/* Init code and data. */
> >  	__init_begin = .;
