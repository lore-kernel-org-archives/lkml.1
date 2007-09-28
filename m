Return-Path: <linux-kernel-owner+w=401wt.eu-S1754663AbXI1Les@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754663AbXI1Les (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2007 07:34:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751320AbXI1Lel
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Sep 2007 07:34:41 -0400
Received: from nf-out-0910.google.com ([64.233.182.185]:9871 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750878AbXI1Lek (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2007 07:34:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=ms+tum3vgDKQpmK3RIix2uUeD/+uMf64ja9xKvciFGIbiH4CbAd3gKMMuoiChVqvOtb1zOh++RvGtIsftBjT67aw+Yfa4x2BbFedRLsuPg7+LdVC1VbEeHBY1YaRQJkhJ362CGHqWlVz9ms7akKJc07aFWmtb9M0Iay4eFsu5Kg=
From: Denys Vlasenko <vda.linux@googlemail.com>
To: Greg KH <greg@kroah.com>
Subject: Re: drivers/usb/misc/emi*.c have the biggest data objects in the whole tree
Date: Fri, 28 Sep 2007 12:34:29 +0100
User-Agent: KMail/1.9.1
Cc: tapio.laxstrom@iptime.fi, linux-kernel@vger.kernel.org
References: <200709141135.35239.vda.linux@googlemail.com> <20070928044111.GB24458@kroah.com>
In-Reply-To: <20070928044111.GB24458@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709281234.29646.vda.linux@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 28 September 2007 05:41, Greg KH wrote:
> On Fri, Sep 14, 2007 at 11:35:34AM +0100, Denys Vlasenko wrote:
> > Hi Tapio,
> > 
> > You are the author of these files. Are you still maintaining them?
> > If not, do you know who is the current maintainer?
> > 
> > These two object files hold the biggest data objects in the whole Linux kernel
> > after lockdep:
> > 
> >    text    data     bss     dec     hex filename
> >    1258  160516       0  161774   277ee ./drivers/usb/misc/emi26.o
> >    1504  209296       0  210800   33770 ./drivers/usb/misc/emi62.o
> > 
> > Basically, these are big arrays of the following structures:
> > 
> > typedef struct _INTEL_HEX_RECORD
> > {
> >         __u32   length;
> >         __u32   address;
> >         __u32   type;
> >         __u8    data[MAX_INTEL_HEX_RECORD_LENGTH];
> > } INTEL_HEX_RECORD;
> > 
> > I suggest the following optimizations:
> > 
> > Change structure to
> > 
> > typedef struct _INTEL_HEX_RECORD
> > {
> >         __u8   type;
> >         __u8   length;
> >         __u16   address;
> >         __u8    data[MAX_INTEL_HEX_RECORD_LENGTH];
> > } INTEL_HEX_RECORD __attribute__((__packed__));
> 
> Only if you redo the whole firmware image too :)

I did. It wasn't hard.

> What is this really hurting?  It's only relevant if you load the
> specific module

By this logic, no space wastage in modules is worth fixing.
--
vda
