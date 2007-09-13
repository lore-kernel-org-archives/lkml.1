Return-Path: <linux-kernel-owner+w=401wt.eu-S1754074AbXIMLyt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754074AbXIMLyt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2007 07:54:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751699AbXIMLyl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Sep 2007 07:54:41 -0400
Received: from ns2.suse.de ([195.135.220.15]:56136 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751453AbXIMLyk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2007 07:54:40 -0400
From: Andi Kleen <ak@suse.de>
To: Greg KH <greg@kroah.com>
Subject: Re: [PATCH] x86_64: set cfg_size for AMD Family 10h in case MMCONFIG is used
Date: Thu, 13 Sep 2007 13:53:15 +0200
User-Agent: KMail/1.9.1
Cc: Yinghai Lu <Yinghai.Lu@sun.com>, Andrew Morton <akpm@linux-foundation.org>,
       Jeff Garzik <jeff@garzik.org>, Martin Mares <mj@ucw.cz>,
       dean gaudet <dean@arctic.org>, Robert Richter <robert.richter@amd.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <200709121921.43950.yinghai.lu@sun.com> <200709131147.43446.ak@suse.de> <20070913104704.GA3878@kroah.com>
In-Reply-To: <20070913104704.GA3878@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709131353.15752.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 13 September 2007 12:47, Greg KH wrote:
> On Thu, Sep 13, 2007 at 11:47:42AM +0200, Andi Kleen wrote:
> > On Thursday 13 September 2007 04:21, Yinghai Lu wrote:
> > > [PATCH] x86_64: set cfg_size for AMD Family 10h in case MMCONFIG is
> > > used.
> > >
> > > reuse pci_cfg_space_size but skip check pci express and pci-x CAP ID.
> >
> > I just rejected a similar patch -- this should be done using MMCONFIG
>
> But what about for broken machines without the proper MMCONFIG entries?
> They still need a way to get access to this config space,

If there are any devices that need it. IBS and PCI-E error handling 
do, but they're quite obscure.

Also so far we don't know of any Fam 10h systems without MMCONFIG
entries. Fam10h requires a new BIOS so it's reasonable to assume
that the new BIOSes will do better.

-Andi
