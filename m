Return-Path: <linux-kernel-owner+w=401wt.eu-S1031531AbXD3JxV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031531AbXD3JxV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 05:53:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031534AbXD3JxV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 05:53:21 -0400
Received: from nic.NetDirect.CA ([216.16.235.2]:36568 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031531AbXD3JxT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 05:53:19 -0400
X-Originating-Ip: 74.109.98.66
Date: Mon, 30 Apr 2007 05:52:59 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@localhost.localdomain
To: Jan Engelhardt <jengelh@linux01.gwdg.de>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: can a kmalloc be both GFP_ATOMIC and GFP_KERNEL at the same
 time?
In-Reply-To: <Pine.LNX.4.61.0704301048390.22744@yvahk01.tjqt.qr>
Message-ID: <Pine.LNX.4.64.0704300551130.2275@localhost.localdomain>
References: <Pine.LNX.4.64.0704280937060.24917@localhost.localdomain>
 <20070430001311.84d0291f.akpm@linux-foundation.org>
 <Pine.LNX.4.64.0704300445460.17536@localhost.localdomain>
 <Pine.LNX.4.61.0704301048390.22744@yvahk01.tjqt.qr>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Net-Direct-Inc-MailScanner-Information: Please contact the ISP for more information
X-Net-Direct-Inc-MailScanner: Found to be clean
X-Net-Direct-Inc-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
	score=-36.8, required 5, autolearn=not spam, ALL_TRUSTED -1.80,
	BAYES_00 -15.00, INIT_RECVD_OUR_AUTH -20.00)
X-Net-Direct-Inc-MailScanner-From: rpjday@mindspring.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 30 Apr 2007, Jan Engelhardt wrote:

>
> On Apr 30 2007 04:46, Robert P. J. Day wrote:
> >> >
> >> >   i'd always assumed that the type flags of GFP_ATOMIC and GFP_KERNEL
> >> > were mutually exclusive when it came to calling kmalloc(), at least
> >> > based on everything i'd read.  so i'm not sure how to interpret the
> >> > following:
> >> >
> >> > drivers/scsi/aic7xxx_old.c:  aic_dev = kmalloc(sizeof(struct aic_dev_data), GFP_ATOMIC | GFP_KERNEL);
> >> > drivers/message/i2o/device.c:   resblk = kmalloc(buflen + 8, GFP_KERNEL | GFP_ATOMIC);
> >> >
> >> >   clarification?
> >>
> >> GFP_ATOMIC implies that the memory comes from the zones which
> >> GFP_KERNEL also uses.  So the above usage of GFP_KERNEL is redundant
> >> and should be removed.
> >
> >hang on ... based on an email i just got, is that reference to
> >GFP_KERNEL "redundant" or "conflicting"?  big difference there.  and
> >is the proper fix to remove "GFP_KERNEL" in both cases?
>
> include/linux/gfp.h:
> #define GFP_ATOMIC (__GFP_HIGH)
> #define GFP_KERNEL (__GFP_WAIT | __GFP_IO | __GFP_FS)
>
> So combining GFP_ATOMIC with GFP_KERNEL gives you
> "allow io, allow fs, allow waiting, and use emergency pools when it's getting
> tight"
> which to me looks like a valid, but probably unwanted combination.

... snip ...

at this point, maybe i'll just leave this in the hands of those who
know far more about it than i do.  but, while we're here, are there
any *other* combinations that wouldn't make any sense?  might as well
check for those in my cleanup script as well.

rday

p.s.  as a suggestion that borders on overkill, one could always add a
configuration debugging option that, when set, compiles code into
kmalloc() that does a sanity check on its type flag arguments.

-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://fsdev.net/wiki/index.php?title=Main_Page
========================================================================
