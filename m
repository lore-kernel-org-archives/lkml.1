Return-Path: <linux-kernel-owner+w=401wt.eu-S1758197AbYACLYB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758197AbYACLYB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2008 06:24:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753214AbYACLXx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jan 2008 06:23:53 -0500
Received: from fk-out-0910.google.com ([209.85.128.187]:42301 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751956AbYACLXw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2008 06:23:52 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=mp25z60fihW4UALANLlxTSfI3mapU9FSvdHm5QOadNPr5YbRdd3VD5VUm/1LMuklxpPw3O/rNDOAG/iiZCZJzcBOlZnV5xsL0V2O37oLZj6e4AMZ04WlGO0MmX857yYzIkZgsc+oA/eBNpUp7UrLlCj/iQvcN3r6iWdGmRa2lhw=
Message-ID: <74d0deb30801030323o5462506fi908ec167710f25fc@mail.gmail.com>
Date: Thu, 3 Jan 2008 12:23:50 +0100
From: "pHilipp Zabel" <philipp.zabel@gmail.com>
To: "Christer Weinigel" <christer@weinigel.se>
Subject: Re: [PATCH] teach checkpatch.pl about list_for_each
Cc: "Andy Whitcroft" <apw@uk.ibm.com>, linux-kernel@vger.kernel.org
In-Reply-To: <20071202130335.690a8daf@cw05lap>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20071202130335.690a8daf@cw05lap>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Dec 2, 2007 1:03 PM, Christer Weinigel <christer@weinigel.se> wrote:
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
>                "Technologies AB\n");

I'd not split it in the middle of a name or phrase if possible.
        printk(KERN_INFO "S3C24xx SPI DMA driver"
                "(c) 2007 Nordnav Technologies AB\n");
but ...

> but in my opinion that becomes more even unreadable.  Would it be
> possible to add a special case so that checkpatch ignores long strings
> that go beyond 80 characters?  Do you think it is a good idea?

... in this case
       pr_info("S3C24xx SPI DMA driver (c) 2007 Nordnav Technologies AB\n");
might just push it under the limit.

cheers
Philipp
