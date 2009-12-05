Return-Path: <linux-kernel-owner+w=401wt.eu-S1757735AbZLEEgc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757735AbZLEEgc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Dec 2009 23:36:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757701AbZLEEga
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Dec 2009 23:36:30 -0500
Received: from g4t0014.houston.hp.com ([15.201.24.17]:20839 "EHLO
	g4t0014.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757686AbZLEEg3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Dec 2009 23:36:29 -0500
Date: Fri, 4 Dec 2009 21:36:35 -0700
From: Alex Chiang <achiang@hp.com>
To: Rakib Mullick <rakib.mullick@gmail.com>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>, linux-pci@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] pci: Make pci_dev struct point to NULL.
Message-ID: <20091205043635.GA10777@ldl.fc.hp.com>
References: <b9df5fa10912040835k3e23702o8700d2d8ad2349a4@mail.gmail.com> <20091204202709.GA32347@ldl.fc.hp.com> <b9df5fa10912041753n27e60020x2dd41eb50f4608ff@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b9df5fa10912041753n27e60020x2dd41eb50f4608ff@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Rakib Mullick <rakib.mullick@gmail.com>:
> On 12/5/09, Alex Chiang <achiang@hp.com> wrote:
> > * Rakib Mullick <rakib.mullick@gmail.com>:
> >
> > This is from Linus's latest tree:
> >
> >   974
> >   975         if (slot->flags & SLOT_ENABLED)
> >   976                 goto err_exit;
> 
> I'm talking about this line. From here we can hit 'goto err_exit' without
> using pci_get_slot.

Right, so what's the problem? If the slot is not enabled, we goto
err_exit and return, never touching dev.

> >   977
> >   978         /* sanity check: dev should be NULL when hot-plugged in */
> >   979         dev = pci_get_slot(bus, PCI_DEVFN(slot->device, 0));
> >   980         if (dev) {
> >
> >  I assume your line 975 is my line 980.
> 
> Nope, my line 975 is also yours.
> >
> >  pci_get_slot() returns NULL if it doesn't find the devfn, so as
> >  far as I can tell, there's no need to initialize dev to NULL.
> >
> >  Were you fixing a real bug with this patch? Did you actually get
> >  the "pci_dev structure already exists.\n" error message?
> >
> No - i'm trying to make sure that we're not referencing into a trash.

I must be slow, because I don't understand how we might reference
trash.

Care to explain it to me?

Thanks,
/ac

