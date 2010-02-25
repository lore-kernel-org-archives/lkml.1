Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932993Ab0BYTZm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Feb 2010 14:25:42 -0500
Received: from ovro.ovro.caltech.edu ([192.100.16.2]:45929 "EHLO
	ovro.ovro.caltech.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932633Ab0BYTZl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Feb 2010 14:25:41 -0500
Date: Thu, 25 Feb 2010 11:25:39 -0800
From: "Ira W. Snyder" <iws@ovro.caltech.edu>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: "Steven J. Magnani" <steve@digidescorp.com>, Zhang Wei <zw@zh-kernel.org>,
       Dan Williams <dan.j.williams@intel.com>, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org
Subject: Re: [async_tx-next PATCH 2/2] fsldma: Fix cookie issues
Message-ID: <20100225192539.GB32092@ovro.caltech.edu>
References: <1266860439-17352-1-git-send-email-steve@digidescorp.com>
 <Pine.LNX.4.64.1002222123350.4120@axis700.grange>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.1002222123350.4120@axis700.grange>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.0 (ovro.ovro.caltech.edu); Thu, 25 Feb 2010 11:25:40 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 22, 2010 at 09:26:13PM +0100, Guennadi Liakhovetski wrote:
> On Mon, 22 Feb 2010, Steven J. Magnani wrote:
> 
> > diff -uprN a/include/linux/dmaengine.h b/include/linux/dmaengine.h
> > --- a/include/linux/dmaengine.h	2010-02-22 11:18:11.000000000 -0600
> > +++ b/include/linux/dmaengine.h	2010-02-22 11:18:30.000000000 -0600
> > @@ -31,6 +31,8 @@
> >   * if dma_cookie_t is >0 it's a DMA request cookie, <0 it's an error code
> >   */
> >  typedef s32 dma_cookie_t;
> > +#define DMA_MIN_COOKIE	1
> > +#define DMA_MAX_COOKIE	2147483647
> 
> Taking into account, that dma_cookie_t is 32 bits:
> 
> +#define DMA_MAX_COOKIE		((1 << 31) - 1)
> 

Steven,

After you take Guennadi's comment into acount, the rest of the patch
looks good. I'm sure I've never rolled the cookie around during testing.

Ira
