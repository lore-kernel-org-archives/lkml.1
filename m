Return-Path: <linux-kernel-owner+w=401wt.eu-S1753880AbYI2RUa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753880AbYI2RUa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2008 13:20:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751939AbYI2RUV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Sep 2008 13:20:21 -0400
Received: from outbound-mail-02.bluehost.com ([69.89.21.12]:46899 "HELO
	outbound-mail-02.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751478AbYI2RUT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2008 13:20:19 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id:X-Identified-User;
	b=Isro1ls32zRf7J+6uAJZvb/jwjdU0axuu4bctfyEbHr8SkFHxF0Zh4+1XuYOSiQTLm3A4MckMNdv5cVBgwqJIq/jngfU3bMtICxHOTu2jY3Ra/EA2VDPAac3+/78AzOR;
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Rolf Eike Beer <eike-kernel@sf-tec.de>
Subject: Re: [PATCH 01/19] pci: introduce an pci_ioremap(pdev, barnr) function
Date: Mon, 29 Sep 2008 10:20:11 -0700
User-Agent: KMail/1.9.9
Cc: Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org,
       linux-pci@vger.kernel.org
References: <20080928163611.3df8a9e0@infradead.org> <200809291902.44813.eike-kernel@sf-tec.de>
In-Reply-To: <200809291902.44813.eike-kernel@sf-tec.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200809291020.12942.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, September 29, 2008 10:02 am Rolf Eike Beer wrote:
> Arjan van de Ven wrote:
> > The patch below introduces a pci_ioremap() function that should make it
> > easier for driver authors to do the right thing for the simple, common
> > case.
> >
> > There's also 18 patches that introduce users of this; to reduce lkml
> > noise I've only stuck them in a git tree at
> > git://git.kernel.org/pub/scm/linux/kernel/git/arjan/linux-2.6-pci_ioremap
> >.g it
> > (http://git.kernel.org/?p=linux/kernel/git/arjan/linux-2.6-pci_ioremap.gi
> >t; a=summary)
> >
> >
> > From fef1dd836bc7dc07962a0ae4019af9efd373c76f Mon Sep 17 00:00:00 2001
> > From: Arjan van de Ven <arjan@linux.intel.com>
> > Date: Fri, 26 Sep 2008 16:34:52 -0700
> > Subject: [PATCH 01/19] pci: introduce an pci_ioremap(pdev, barnr)
> > function
> >
> > A common thing in many PCI drivers is to ioremap() an entire bar.
> > This is a slightly fragile thing right now, needing both an address and a
> > size, and many driver writers do.. various things there.
> >
> > This patch introduces an pci_ioremap() function taking just a PCI device
> > struct and the bar number as arguments, and figures this all out itself,
> > in one place. In addition, we can add various sanity checks to this
> > function (the patch already checks to make sure that the bar in question
> > really is a MEM bar; few to no drivers do that sort of thing).
>
> This is the same like pci_iomap(pdev, number, 0), no?

Yeah... Looks like that function isn't that widely used though.  Is the maxlen 
param really needed?  Looks like the drivers that use it often pass 0 or the 
BAR length anyway, and Arjan converted existing drivers too, which is where 
the real work is.

Jesse
