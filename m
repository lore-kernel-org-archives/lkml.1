Return-Path: <linux-kernel-owner+w=401wt.eu-S1763434AbYJJUGa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763434AbYJJUGa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2008 16:06:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760565AbYJJUGW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Oct 2008 16:06:22 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:41662 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760421AbYJJUGV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2008 16:06:21 -0400
Date: Fri, 10 Oct 2008 22:05:28 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-ide@vger.kernel.org, torvalds@osdl.org
Subject: Re: libata: set queue SSD flag for SSD devices
Message-ID: <20081010200528.GJ19428@kernel.dk>
References: <200810101904.m9AJ42Gq018897@hera.kernel.org> <20081010202515.446857cc@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081010202515.446857cc@lxorguk.ukuu.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 10 2008, Alan Cox wrote:
> > +	ATA_ID_ROT_SPEED	= 217,
> >  	ATA_ID_PIO4		= (1 << 1),
> >  
> >  	ATA_ID_SERNO_LEN	= 20,
> > @@ -691,6 +692,11 @@ static inline int ata_id_is_cfa(const u16 *id)
> >  	return 0;
> >  }
> >  
> > +static inline int ata_id_is_ssd(const u16 *id)
> > +{
> > +	return id[ATA_ID_ROT_SPEED] == 0x01;
> > +}
> 
> This patch is buggy.
> 
> Word 217 only has a defined meaning in late revision ATA standards so a
> version check is needed. Please copy ATA patch copies to linux-ide.

Good point, I'll be sure to submit an updated patch. I did mean to copy
linux-ide, the intention was actually to pass this libata enable patch
through Jeff after testing, but it slipped through.

In this specific patch, it'll do no harm at least since I very much
doubt we'll see a false positive. And even if, the consequences wont be
dire. But it does want the version check, of course.

-- 
Jens Axboe

