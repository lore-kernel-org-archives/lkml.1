Return-Path: <linux-kernel-owner+w=401wt.eu-S1756248AbYACRCl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756248AbYACRCl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2008 12:02:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752685AbYACRCd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jan 2008 12:02:33 -0500
Received: from krynn.se.axis.com ([193.13.178.10]:49123 "EHLO
	krynn.se.axis.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751861AbYACRCd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2008 12:02:33 -0500
Date: Thu, 3 Jan 2008 18:02:18 +0100
From: Jesper Nilsson <jesper.nilsson@axis.com>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Yuusei KUWANA <kuwana@nyanyan.to>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       mikael.starvik@axis.com
Subject: Re: [PATCH] arch/cris/arch-v10/vmlinux.lds.S fix boot problem
Message-ID: <20080103170218.GB9512@axis.com>
References: <47636D45.6010006@nyanyan.to> <20071221151404.GM10888@axis.com> <20071221155446.GN10888@axis.com> <20071221160718.GO10888@axis.com> <20071222083717.GB22653@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071222083717.GB22653@uranus.ravnborg.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 22, 2007 at 09:37:17AM +0100, Sam Ravnborg wrote:
> Hi Jesper.
> 
> >  		__initramfs_end = .;
> > -		/* We fill to the next page, so we can discard all init
> > -		   pages without needing to consider what payload might be
> > -		   appended to the kernel image.  */
> > -		FILL (0); 
> > -		. = ALIGN (8192);
> >  	}
> >  #endif
> > -	
> >  	__vmlinux_end = .;            /* last address of the physical file */
> > -  	__init_end = .;
> > +
> > +	/*
> > +	 * We fill to the next page, so we can discard all init
> > +	 * pages without needing to consider what payload might be
> > +	 * appended to the kernel image.
> > +	 */
> > +	.init.fill : {
> > +		FILL (0);
> > +		. = ALIGN (8192);
> > +	}
> > +
> > +	__init_end = .;
> 
> Can we please have the hardcoded 8192 replaced with a proper constant.
> I assume this is PAGESIZE?

Yes, quite so.

> See hwat other archs does to make PAGESIZE available for assembly
> files and ldscripts. The macro AC is the key point here.

Ok, will do.

> And then please explain why it make a diffrence to put the
> alignment in a section like you do.
> I do not see it used in the other archs.

I'm not an expert on ld-scripts, so I only know that the linker didn't
respect the other way of doing the alignment, but did when added in a
section.

Perhaps Mikael has a better explanation when he's back from vacation.

> 	Sam

Best regards,

/^JN - Jesper Nilsson
--
               Jesper Nilsson -- jesper.nilsson@axis.com
