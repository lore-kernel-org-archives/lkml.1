Return-Path: <linux-kernel-owner+w=401wt.eu-S1753344AbZI2X3x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753344AbZI2X3x (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Sep 2009 19:29:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752858AbZI2X3w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Sep 2009 19:29:52 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:45052 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752180AbZI2X3w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Sep 2009 19:29:52 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alex Chiang <achiang@hp.com>
Subject: Re: [PATCH] acpi: pci_root: fix NULL pointer deref after resume from suspend
Date: Wed, 30 Sep 2009 01:31:14 +0200
User-Agent: KMail/1.12.1 (Linux/2.6.31-rjw; KDE/4.3.1; x86_64; ; )
Cc: Danny Feng <dfeng@redhat.com>, lenb@kernel.org, bjorn.helgaas@hp.com,
       andrew.patterson@hp.com, jbarnes@virtuousgeek.org,
       linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1254119480-9730-1-git-send-email-dfeng@redhat.com> <200909292208.18203.rjw@sisk.pl> <20090929204948.GA31574@ldl.fc.hp.com>
In-Reply-To: <20090929204948.GA31574@ldl.fc.hp.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200909300131.15046.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 29 September 2009, Alex Chiang wrote:
> * Rafael J. Wysocki <rjw@sisk.pl>:
> > On Tuesday 29 September 2009, Danny Feng wrote:
> > > Is there any cases that pdev->subordinate is NULL while pdev is bridge 
> > > device?
> > >  From pci_slot.c::walk_p2p_bridge, there's code like following:
> > > 
> > >          dev = pci_get_slot(pci_bus, PCI_DEVFN(device, function));
> > >          if (!dev || !dev->subordinate)
> > >                  goto out;
> > > 
> > > It looks like dev->subordinate can be NULL even if in p2p
> > > bridge, right?
> 
> In the code you post above, that results from doing an ACPI
> namespace walk, which will definitely find non-bridge devices.
>  
> > Right, in general, but in this particular case each device we
> > inspect is supposed to be a parent of another device, which
> > implies that there's a bus below it (given that it's a PCI
> > device).
> 
> Right, that's why I'm surprised that my assumption broke. But now
> that I see that a dock device is involved, maybe that's not so
> surprising.

Yeah.  Still, I'd like to know the root cause.

Thanks,
Rafael
