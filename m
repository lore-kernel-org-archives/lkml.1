Return-Path: <linux-kernel-owner+w=401wt.eu-S934780AbZJNPwq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934780AbZJNPwq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Oct 2009 11:52:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934749AbZJNPwo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Oct 2009 11:52:44 -0400
Received: from g1t0029.austin.hp.com ([15.216.28.36]:47202 "EHLO
	g1t0029.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934613AbZJNPwm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Oct 2009 11:52:42 -0400
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Subject: Re: [PATCH v2 0/9] PCI, PNP: print resources consistently
Date: Wed, 14 Oct 2009 09:52:01 -0600
User-Agent: KMail/1.9.10
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>, linux-pci@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
       Joe Perches <joe@perches.com>, Len Brown <lenb@kernel.org>
References: <20091013192040.22336.84876.stgit@bob.kio> <86802c440910132347x1913d2a1taf35f385af50e17c@mail.gmail.com>
In-Reply-To: <86802c440910132347x1913d2a1taf35f385af50e17c@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200910140952.02879.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 14 October 2009 12:47:33 am Yinghai Lu wrote:
> On Tue, Oct 13, 2009 at 12:21 PM, Bjorn Helgaas <bjorn.helgaas@hp.com> wrote:
> > These enhance %pR so we can print resource types and flags more easily.
> > This doesn't really add anything (other than a couple new messages
> > about host bridge apertures), but hopefully it will make things more
> > consistent and a bit easier to debug.  Sample change (with "pci=use_crs"):
> >
> >    -pci 0000:00:03.0: reg 10 32bit mmio: [0xf6000000-0xf6ffffff]
> >    -pci 0000:00:03.0: reg 14 io port: [0x2400-0x24ff]
> >    -pci 0000:00:03.0: reg 18 32bit mmio: [0xf5ff0000-0xf5ff0fff]
> >    -pci 0000:00:03.0: reg 30 32bit mmio pref: [0x000000-0x01ffff]
> >    +pci_root PNP0A03:00: host bridge window [io  0x0000-0x0cff]
> >    +pci_root PNP0A03:00: host bridge window [io  0x0000-0x2cfe]
> >    +pci_root PNP0A03:00: host bridge window [io  0x03b0-0x03bb]
> >    +pci_root PNP0A03:00: host bridge window [io  0x03c0-0x03df]
> >    +pci_root PNP0A03:00: host bridge window [mem 0xf5d00000-0xf6ffffff]
> >    +pci_root PNP0A03:00: host bridge window [mem 0x000a0000-0x000bffff]
> >    +pci 0000:00:03.0: reg 10: [mem 0xf6000000-0xf6ffffff]
> >    +pci 0000:00:03.0: reg 14: [io  0x2400-0x24ff]
> >    +pci 0000:00:03.0: reg 18: [mem 0xf5ff0000-0xf5ff0fff]
> >    +pci 0000:00:03.0: reg 30: [mem 0x00000000-0x0001ffff pref]
> 
> can you keep "io port" and "mmio" ?
> so we can use
> grep "io port" dmesg.txt or grep "mmio" dmesg.txt

I don't think that's necessary.  If you want to see only
resource stuff, these greps will work perfectly:

  # dmesg | grep "\[io "
  # dmesg | grep "\[mem "

(This is much better than what's in the current tree, where
resources are labelled with a hodge-podge of mem, mmio, MEM,
io, I/O, io port, IO, or even nothing at all, so you really
can't do the grep at all.)

> also put "io" and "mmio" "pref' in the [  ], looks strange.
> [0xf5ff0000-0xf5ff0fff] is correct range expression.

I could be convinced otherwise, but right now, I don't see a
correctness issue here -- it's just a matter of what the most
convenient format for human readers is.  And I personally like
the fact that everything inside the brackets is an attribute of
the struct resource.

If these are the alternatives:

  bridge window [io  0x0000-0x0cff]
  bridge window io  [0x0000-0x0cff]

one nice thing about the first is that the brackets give a clue
that you should grep for "bridge window", not "bridge window io",
to find the source of the message.

Bjorn
