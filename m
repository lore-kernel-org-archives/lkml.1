Return-Path: <linux-kernel-owner+w=401wt.eu-S1756267AbZBBMDa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756267AbZBBMDa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Feb 2009 07:03:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752810AbZBBMDW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Feb 2009 07:03:22 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:60602 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752348AbZBBMDV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Feb 2009 07:03:21 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Nigel Cunningham <ncunningham@crca.org.au>
Subject: Re: [linux-pm] [PATCH 3/3] PCI PM: Make warning in pci_legacy_suspend more useful
Date: Mon, 2 Feb 2009 13:02:30 +0100
User-Agent: KMail/1.11.0 (Linux/2.6.29-rc2-tst; KDE/4.2.0; x86_64; ; )
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>,
       Linux PCI <linux-pci@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
References: <200902012229.27517.rjw@sisk.pl> <200902012234.25165.rjw@sisk.pl> <1233540601.21871.10.camel@nigel-laptop>
In-Reply-To: <1233540601.21871.10.camel@nigel-laptop>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902021302.31158.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 02 February 2009, Nigel Cunningham wrote:
> Hi again.
> 
> On Sun, 2009-02-01 at 22:34 +0100, Rafael J. Wysocki wrote:
> > From: Rafael J. Wysocki <rjw@sisk.pl>
> > 
> > The warning in pci_legacy_suspend() would be much more useful if it
> > printed the name of the function that did the wrong thing.  Make it
> > do so.
> > 
> > Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
> > ---
> >  drivers/pci/pci-driver.c |    4 +++-
> >  1 file changed, 3 insertions(+), 1 deletion(-)
> > 
> > Index: linux-2.6/drivers/pci/pci-driver.c
> > ===================================================================
> > --- linux-2.6.orig/drivers/pci/pci-driver.c
> > +++ linux-2.6/drivers/pci/pci-driver.c
> > @@ -365,7 +365,9 @@ static int pci_legacy_suspend(struct dev
> >  		if (pci_dev->state_saved)
> >  			goto Fixup;
> >  
> > -		if (WARN_ON_ONCE(pci_dev->current_state != PCI_D0))
> > +		if (WARN_ONCE(pci_dev->current_state != PCI_D0,
> > +				"PCI PM: Device state not saved by %pF\n",
> > +				drv->suspend))
> >  			goto Fixup;
> >  	}
> 
> Am I right in thinking that WARN_ONCE will only warn about the first
> driver that has the problem? If so, wouldn't it be better to make it
> warn about all drivers that have the problem, but only once per device?

That would be better, but I don't think we are going to see many of these
anyway. :-)

Thanks,
Rafael
