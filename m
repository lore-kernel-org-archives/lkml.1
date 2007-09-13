Return-Path: <linux-kernel-owner+w=401wt.eu-S1761735AbXIMRBT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761735AbXIMRBT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2007 13:01:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753121AbXIMRBL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Sep 2007 13:01:11 -0400
Received: from nz-out-0506.google.com ([64.233.162.232]:42819 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752334AbXIMRBK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2007 13:01:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=LwANbuIDlSrASCtdtiWwaQXBpAdDJRjGIlwAyv7/CKRfFSS2XtMKkXlEcCWFQkXxBsiUVw9KmpVAgjSkHOYaBhSY7uENkm4ikpS6MfZbcVfTtAU++IEoCRsadM1Txt+JhRJ8dy5KzRYUHw9vcdSHpblAnMiJ9c8a2tKX0cKKvCk=
Message-ID: <86802c440709131001w4b758921r52a23f1732a6e9c8@mail.gmail.com>
Date: Thu, 13 Sep 2007 10:01:09 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Andi Kleen" <ak@suse.de>
Subject: Re: [PATCH] x86_64: set cfg_size for AMD Family 10h in case MMCONFIG is used
Cc: "Greg KH" <greg@kroah.com>, "Andrew Morton" <akpm@linux-foundation.org>,
       "Jeff Garzik" <jeff@garzik.org>, "Martin Mares" <mj@ucw.cz>,
       "dean gaudet" <dean@arctic.org>,
       "Robert Richter" <robert.richter@amd.com>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <200709131353.15752.ak@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200709121921.43950.yinghai.lu@sun.com>
	 <200709131147.43446.ak@suse.de> <20070913104704.GA3878@kroah.com>
	 <200709131353.15752.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/13/07, Andi Kleen <ak@suse.de> wrote:
> On Thursday 13 September 2007 12:47, Greg KH wrote:
> > On Thu, Sep 13, 2007 at 11:47:42AM +0200, Andi Kleen wrote:
> > > On Thursday 13 September 2007 04:21, Yinghai Lu wrote:
> > > > [PATCH] x86_64: set cfg_size for AMD Family 10h in case MMCONFIG is
> > > > used.
> > > >
> > > > reuse pci_cfg_space_size but skip check pci express and pci-x CAP ID.
> > >
> > > I just rejected a similar patch -- this should be done using MMCONFIG
> >
> > But what about for broken machines without the proper MMCONFIG entries?
> > They still need a way to get access to this config space,
>
> If there are any devices that need it. IBS and PCI-E error handling
> do, but they're quite obscure.
>
> Also so far we don't know of any Fam 10h systems without MMCONFIG
> entries. Fam10h requires a new BIOS so it's reasonable to assume
> that the new BIOSes will do better.

BIOS guys also said that fam 10h need mmconfig via eax accessing, may
need OS do sth, so it is safe to stay with MCFG entry for SB like
mcp55...

but latest kernel already have that workaround to make mmconfig via eax...

YH
