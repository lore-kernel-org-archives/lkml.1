Return-Path: <linux-kernel-owner+w=401wt.eu-S1757253AbZAXPo3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757253AbZAXPo3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Jan 2009 10:44:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750970AbZAXPoT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Jan 2009 10:44:19 -0500
Received: from mu-out-0910.google.com ([209.85.134.187]:5703 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750789AbZAXPoS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Jan 2009 10:44:18 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-disposition:message-id:content-type
         :content-transfer-encoding;
        b=v6ufnA92DXH4vFSS93XOo/mNSgnkuJ9Rj7bUA7iis3uybMlkvKB1qGeE7WzCEjq0/L
         WRlYBbN5/T8wpnVhX7fIBrBQn+Y9EabA1WwXjYFeREVrIXKoXL3tlGGLze0Wt3a7fWGW
         xkZXrItCTCaE6sHBjVS5dyRcNNz4msIGHyEl4=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Russell King <rmk+lkml@arm.linux.org.uk>
Subject: Re: [PATCH] icside: use struct ide_port_info also for PCB version 5
Date: Sat, 24 Jan 2009 16:44:16 +0100
User-Agent: KMail/1.10.3 (Linux/2.6.29-rc2-next-20090123; KDE/4.1.3; i686; ; )
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
References: <200901241514.23036.bzolnier@gmail.com> <20090124145051.GA26833@flint.arm.linux.org.uk>
In-Reply-To: <20090124145051.GA26833@flint.arm.linux.org.uk>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200901241644.16601.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 24 January 2009, Russell King wrote:
> On Sat, Jan 24, 2009 at 03:14:22PM +0100, Bartlomiej Zolnierkiewicz wrote:
> > From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> > Subject: [PATCH] icside: use struct ide_port_info also for PCB version 5
> > 
> > This fixes hwif->channel and drive->dn assignments.
> 
> I really don't care about this driver anymore - people should
> be using the PATA version instead.

I really don't see major technical arguments for using libata version
(especially after 2.6.29 IDE changes) but it's your call so if you want
icside removed just send me a patch and I'll apply it (given that there
are no complaints from users).

[ No strong feelings here as it will allow me to better use my time
  and concentrate on working on code that people care about. ]

> Nevertheless, this patch looks broken.
> 
> > @@ -534,7 +538,7 @@ icside_register_v6(struct icside_state *
>                       ^^^^^^^^^^^^^^^^^^ v6 function
> 
> >  		d.dma_ops = NULL;
> >  	}
> >  
> > -	ret = ide_host_register(host, NULL, hws);
> > +	ret = ide_host_register(host, &icside_v5_port_info, hws);
>                                       ^^^^^^^^^^^^^^^^^^^^^ v5 info

Grrr.. and the other icside patch has v5->v6 mismatch.

Thanks for noticing.  I'll post corrected patches in few minutes.
