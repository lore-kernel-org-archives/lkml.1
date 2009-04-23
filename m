Return-Path: <linux-kernel-owner+w=401wt.eu-S1758457AbZDWV10@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758457AbZDWV10 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Apr 2009 17:27:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755437AbZDWV1R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Apr 2009 17:27:17 -0400
Received: from mail-bw0-f163.google.com ([209.85.218.163]:63151 "EHLO
	mail-bw0-f163.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756901AbZDWV1Q convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Apr 2009 17:27:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-disposition:message-id:content-type
         :content-transfer-encoding;
        b=GNje1TH2MFHro5Hx8xBmAI9AwwevYMDDkmSmcwFT8LJgt/rZDsIf+hcU2daedj1Uz2
         VqILmqwcr1CeXCRL6Tq5+dDphtynGjP9B6UFtGNUiqXKlkrTfY6iy3ULrRpKphnUw1CW
         N4e5fv2OkRufiHGheJzKHMqNeJ01B7mNl6kv0=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: =?iso-8859-1?q?Rog=E9rio_Brito?= <rbrito@ime.usp.br>
Subject: Re: Quick question about libata and hdparm
Date: Thu, 23 Apr 2009 23:31:13 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.29-next-20090403; KDE/4.2.2; i686; ; )
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Jeff Garzik <jeff@garzik.org>,
       Michael Tokarev <mjt@tls.msk.ru>, Mark Lord <lkml@rtr.ca>,
       linux-kernel@vger.kernel.org
References: <E693AEE4-7895-4650-A1DC-1FB16D409D5B@ime.usp.br> <200904211459.26965.bzolnier@gmail.com> <20090423055618.GA23042@ime.usp.br>
In-Reply-To: <20090423055618.GA23042@ime.usp.br>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200904232331.13729.bzolnier@gmail.com>
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 23 April 2009 07:56:19 Rogério Brito wrote:
> Hi, Bart, Alan.
> 
> On Apr 21 2009, Bartlomiej Zolnierkiewicz wrote:
> > Incremental patch (a certain theory to verify).
> (...)
> > +	/* FIXME: this thrashes internal UDMA timings previously set by
> > +	   controller on SET FEATURES - XFER MODE command "snooping" */
> >  	/* The DMA clocks may have been trashed by a reset. FIXME: make conditional
> >  	   and move to qc_issue ? */
> > -	pdc202xx_set_dmamode(ap, qc->dev);
> > +	/* pdc202xx_set_dmamode(ap, qc->dev); */
> 
> This didn't work. I still get those same messages. If you want, I can try
> compiling the 2.6.30-rc3 kernel that was released now (as I mentioned
> before, I was using 2.6.29).

I think that testing -rc3 won't hurt but don't get your hopes too high. ;)

> I can test whatever you want me to.

You can try booting with "libata.force=1.00:mwdma2" kernel paramater to
force use of "regular" MWDMA2 transfer mode instead of UDMA ones so we are
sure that the issue is specific to pata_pdc202xx_old + UDMA.

Other than that I'm out of ideas, though the hint that the original driver
works just fine should help driver's maintainer in fixing this regression.

Thanks,
Bart
