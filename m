Return-Path: <linux-kernel-owner+w=401wt.eu-S1752668AbYIFFXk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752668AbYIFFXk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Sep 2008 01:23:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751478AbYIFFXb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Sep 2008 01:23:31 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46563 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751076AbYIFFXb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Sep 2008 01:23:31 -0400
Date: Fri, 5 Sep 2008 22:23:20 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Hiroshi DOYU <Hiroshi.DOYU@nokia.com>
Cc: linux-kernel@vger.kernel.org, tony@atomide.com
Subject: Re: [PATCH] Add missing macro argument for devm_release_* family
Message-Id: <20080905222320.36eb3bfa.akpm@linux-foundation.org>
In-Reply-To: <20080906.081841.03994201.Hiroshi.DOYU@nokia.com>
References: <1220662823-19106-1-git-send-email-Hiroshi.DOYU@nokia.com>
	<20080905185254.78706060.akpm@linux-foundation.org>
	<20080906.081841.03994201.Hiroshi.DOYU@nokia.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 06 Sep 2008 08:18:41 +0300 (EEST) Hiroshi DOYU <Hiroshi.DOYU@nokia.com> wrote:

> From: "ext Andrew Morton" <akpm@linux-foundation.org>
> Subject: Re: [PATCH] Add missing macro argument for devm_release_* family
> Date: Fri, 5 Sep 2008 18:52:54 -0700
> 
> > On Sat,  6 Sep 2008 04:00:23 +0300 Hiroshi DOYU <Hiroshi.DOYU@nokia.com> wrote:
> > 
> > > From: ext Hiroshi DOYU <Hiroshi.DOYU@nokia.com>
> > > 
> > > Signed-off-by: Hiroshi DOYU <Hiroshi.DOYU@nokia.com>
> > > ---
> > >  include/linux/ioport.h |    4 ++--
> > >  1 files changed, 2 insertions(+), 2 deletions(-)
> > > 
> > > diff --git a/include/linux/ioport.h b/include/linux/ioport.h
> > > index 22d2115..c813c63 100644
> > > --- a/include/linux/ioport.h
> > > +++ b/include/linux/ioport.h
> > > @@ -158,9 +158,9 @@ extern struct resource * __devm_request_region(struct device *dev,
> > >  				struct resource *parent, resource_size_t start,
> > >  				resource_size_t n, const char *name);
> > >  
> > > -#define devm_release_region(start,n) \
> > > +#define devm_release_region(dev,start,n) \
> > >  	__devm_release_region(dev, &ioport_resource, (start), (n))
> > > -#define devm_release_mem_region(start,n) \
> > > +#define devm_release_mem_region(dev,start,n) \
> > >  	__devm_release_region(dev, &iomem_resource, (start), (n))
> > >  
> > >  extern void __devm_release_region(struct device *dev, struct resource *parent,
> > 
> > um, OK.
> > 
> > But none of these things appear to have any callers anywhere.  Why
> > don't we just delete it all?
> 
> Not sure for others, but at least, I am using this in my developing
> driver;)

yeah, I was just trolling ;)

I queued this fix for 2.6.27.
