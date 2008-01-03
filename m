Return-Path: <linux-kernel-owner+w=401wt.eu-S1758475AbYACLK5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758475AbYACLK5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2008 06:10:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752353AbYACLKu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jan 2008 06:10:50 -0500
Received: from mtagate7.uk.ibm.com ([195.212.29.140]:30152 "EHLO
	mtagate7.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751404AbYACLKt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2008 06:10:49 -0500
Date: Thu, 3 Jan 2008 11:10:58 +0000
From: Andy Whitcroft <andyw@uk.ibm.com>
To: Christer Weinigel <christer@weinigel.se>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] teach checkpatch.pl about list_for_each
Message-ID: <20080103111058.GE10861@shadowen.org>
References: <20071202130335.690a8daf@cw05lap>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071202130335.690a8daf@cw05lap>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 02, 2007 at 01:03:35PM +0100, Christer Weinigel wrote:
> Hi Andy,
> 
> you seem to be the last person messing around with checkpatch.pl so I'm
> addressing this to you. :-)
> 
> checkpatch complains about the following:
> 
> WARNING: no space between function name and open parenthesis '('
> #520: FILE: drivers/spi/spi_s3c24xx_dma.c:478:
> +       list_for_each_entry (transfer, &message->transfers, transfer_list) {
> 
> which I think is a bit bogus since it actually is a for statement in
> disguise.  The following patch adds list_for_each to the list of things
> that look like functions that it shouldn't complain about.

We have had some stabs at changing this, but no consensus was reached on
whether it was a "for" or a "function".  My memory is of there being
slightly more "without a space" tenders than the other and so it has not
been changed.  This thread also seems so far to have not really
generated a concensus.  So I would tend to leave things as they are.  

A third option might be to accept either on *for_each* constructs.
That might tend to lead to divergance.  Difficult.  However, also see my
later comments on "style guide".

> 
> By the way, what is the consensus on lines over 80 characters?
> checkpatch complains about the following:
> 
> WARNING: line over 80 characters
> #762: FILE: drivers/spi/spi_s3c24xx_dma.c:720:
> +       printk(KERN_INFO "S3C24xx SPI DMA driver (c) 2007 Nordnav Technologies AB\n");
> 
> I can of course break this into:
> 
>         printk(KERN_INFO "S3C24xx SPI DMA driver (c) 2007 Nordnav "
> 	       "Technologies AB\n");
> 
> but in my opinion that becomes more even unreadable.  Would it be
> possible to add a special case so that checkpatch ignores long strings
> that go beyond 80 characters?  Do you think it is a good idea?

I think you are miss-understanding the point of checkpatch here.  It has
flagged this line as suspect.  You are happy it is better as it is.  You
should therefore leave it as it is as you "are happy to justify that
checkpatch failure".  Checkpatch is a style guide, if it complains you
should think about its complaint and act as you see fit in response.
Sometimes you will ignore it, that is fine.

-apw
