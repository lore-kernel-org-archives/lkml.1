Return-Path: <linux-kernel-owner+w=401wt.eu-S1761809AbZE2Pv4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761809AbZE2Pv4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 May 2009 11:51:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758603AbZE2Pvs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 May 2009 11:51:48 -0400
Received: from complete.lackof.org ([198.49.126.79]:57968 "EHLO
	complete.lackof.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758231AbZE2Pvr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 May 2009 11:51:47 -0400
Date: Fri, 29 May 2009 09:51:48 -0600
From: Grant Grundler <grundler@parisc-linux.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Alexander Beregalov <a.beregalov@gmail.com>, linux-parisc@vger.kernel.org,
       linux-kernel@vger.kernel.org, alan@lxorguk.ukuu.org.uk
Subject: Re: [PATCH 2/2] serial: 8250_gsc: fix printk format warning
Message-ID: <20090529155148.GB28355@lackof.org>
References: <1242652291-1868-1-git-send-email-a.beregalov@gmail.com> <20090527225106.10fc9cc6.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090527225106.10fc9cc6.akpm@linux-foundation.org>
X-Home-Page: http://www.parisc-linux.org/
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 27, 2009 at 10:51:06PM -0700, Andrew Morton wrote:
> On Mon, 18 May 2009 17:11:31 +0400 Alexander Beregalov <a.beregalov@gmail.com> wrote:
> 
> > Fix this build warning:
> > drivers/serial/8250_gsc.c:44: warning: format '%lx' expects type
> > 'long unsigned int', but argument 2 has type 'resource_size_t'
> > 
> 
> The patch does more than fix a "warning".  It fixes an actual error. 
> The caller will prepare a 64-bit argument and the callee will print
> only 32 bits of it.

On parisc, AFAIK, GSC devices are always at a 32-bit addresses.
So whatever compiles clean is fine.

Please add "Reviewed by: Grant Grundler <grundler@parisc-linux.org>"

thanks,
grant

> > ---
> >  drivers/serial/8250_gsc.c |    2 +-
> >  1 files changed, 1 insertions(+), 1 deletions(-)
> > 
> > diff --git a/drivers/serial/8250_gsc.c b/drivers/serial/8250_gsc.c
> > index 418b4fe..a7b02a5 100644
> > --- a/drivers/serial/8250_gsc.c
> > +++ b/drivers/serial/8250_gsc.c
> > @@ -41,7 +41,7 @@ static int __init serial_init_chip(struct parisc_device *dev)
> >  			printk(KERN_INFO
> >  				"Serial: device 0x%lx not configured.\n"
> >  				"Enable support for Wax, Lasi, Asp or Dino.\n",
> > -				dev->hpa.start);
> > +				(unsigned long)dev->hpa.start);
> 
> Nope.  hpa.start can be u32 or u64.  We need to cast that to the wider
> type so that it will correctly print in all circumstances.
> 
> So I changed both patches to print with %ll and to cast to
> unsigned long long.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-parisc" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
