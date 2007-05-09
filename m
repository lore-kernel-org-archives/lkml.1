Return-Path: <linux-kernel-owner+w=401wt.eu-S968781AbXEIHYf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968781AbXEIHYf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2007 03:24:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S967942AbXEIHYZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 May 2007 03:24:25 -0400
Received: from mail.macqel.be ([194.78.208.39]:1443 "EHLO mail.macqel.be"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967810AbXEIHYY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2007 03:24:24 -0400
Date: Wed, 9 May 2007 09:24:22 +0200
From: Philippe De Muyter <phdm@macqel.be>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Linus Torvalds <torvalds@osdl.org>, Andrew Morton <akpm@osdl.org>,
       Linux/m68k <linux-m68k@vger.kernel.org>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: Re: retry [PATCH] partition : add support for sysv68 partitions
Message-ID: <20070509072422.GA13119@ingate.macqel.be>
References: <20070413135501.GA27439@ingate.macqel.be> <Pine.LNX.4.64.0705082217340.12497@anakin>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0705082217340.12497@anakin>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Geert,

On Tue, May 08, 2007 at 10:21:12PM +0200, Geert Uytterhoeven wrote:
> 	Hi Philippe,
> 
> On Fri, 13 Apr 2007, Philippe De Muyter wrote:
> > Add support for the Motorola sysv68 disk partition table (slices in motorola
> > doc).
> > 
> > Signed-off-by: Philippe De Muyter <phdm@macqel.be>
> > 
> > diff -r 1b54f1d81bc5 fs/partitions/Kconfig
> > --- a/fs/partitions/Kconfig	Thu Apr 12 15:44:52 2007 -0700
> > +++ b/fs/partitions/Kconfig	Fri Apr 13 15:51:58 2007 +0200
> > @@ -236,3 +236,12 @@ config EFI_PARTITION
> >  	help
> >  	  Say Y here if you would like to use hard disks under Linux which
> >  	  were partitioned using EFI GPT.
> > +
> > +config SYSV68_PARTITION
> > +	bool "SYSV68 partition table support" if PARTITION_ADVANCED
> > +	default y if M68K
>         ^^^^^^^^^^^^^^^^^
> > +	help
> > +	  Say Y here if you would like to be able to read the hard disk
> > +	  partition table format used by Motorola Delta machines (using
> > +	  sysv68).
> > +	  Otherwise, say N.
> 
> Bummer, I saw your patch before, but I never noticed the `default y if M68K'.
> 
> Can you please tell me on which platforms SYSV68 partition tables are commonly
> used (I guess the Motorola MVME boards?), so we can enable it by default on a

The Motorola VME boards are the only ones I am aware of.  I must also add
that the partitions themselves are sysv partitions.

> more sensible subset of M68K?

Feel free to replace or suppress the `default' directive.  I actually wrote
that for a i586 laptop to access/reinstall disks of sysV68 machines using
a USB/SCSI adapter, but I don't think `default y' is a good idea :).

What do you think of
	`default y if VME'
or
	`default y if M68K && SYSV_FS'

Best regards 

Philippe
