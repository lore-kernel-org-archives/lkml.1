Return-Path: <linux-kernel-owner+w=401wt.eu-S1752539AbZI2UuW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752539AbZI2UuW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Sep 2009 16:50:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752094AbZI2UuV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Sep 2009 16:50:21 -0400
Received: from g6t0185.atlanta.hp.com ([15.193.32.62]:2597 "EHLO
	g6t0185.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751485AbZI2UuU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Sep 2009 16:50:20 -0400
Date: Tue, 29 Sep 2009 14:49:48 -0600
From: Alex Chiang <achiang@hp.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Danny Feng <dfeng@redhat.com>, lenb@kernel.org, bjorn.helgaas@hp.com,
       andrew.patterson@hp.com, jbarnes@virtuousgeek.org,
       linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] acpi: pci_root: fix NULL pointer deref after resume
	from suspend
Message-ID: <20090929204948.GA31574@ldl.fc.hp.com>
References: <1254119480-9730-1-git-send-email-dfeng@redhat.com> <200909290050.13833.rjw@sisk.pl> <4AC1DD52.5040607@redhat.com> <200909292208.18203.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200909292208.18203.rjw@sisk.pl>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Rafael J. Wysocki <rjw@sisk.pl>:
> On Tuesday 29 September 2009, Danny Feng wrote:
> > Is there any cases that pdev->subordinate is NULL while pdev is bridge 
> > device?
> >  From pci_slot.c::walk_p2p_bridge, there's code like following:
> > 
> >          dev = pci_get_slot(pci_bus, PCI_DEVFN(device, function));
> >          if (!dev || !dev->subordinate)
> >                  goto out;
> > 
> > It looks like dev->subordinate can be NULL even if in p2p
> > bridge, right?

In the code you post above, that results from doing an ACPI
namespace walk, which will definitely find non-bridge devices.
 
> Right, in general, but in this particular case each device we
> inspect is supposed to be a parent of another device, which
> implies that there's a bus below it (given that it's a PCI
> device).

Right, that's why I'm surprised that my assumption broke. But now
that I see that a dock device is involved, maybe that's not so
surprising.

/ac

