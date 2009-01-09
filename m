Return-Path: <linux-kernel-owner+w=401wt.eu-S1760290AbZAIXlZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760290AbZAIXlZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2009 18:41:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932301AbZAIXjX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Jan 2009 18:39:23 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:59505 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759192AbZAIXjV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2009 18:39:21 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: [PATCH 5/8] PCI PCIe portdrv: Fix allocation of interrupts
Date: Sat, 10 Jan 2009 00:38:56 +0100
User-Agent: KMail/1.10.3 (Linux/2.6.28-rjw; KDE/4.1.3; x86_64; ; )
Cc: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
       Linux PCI <linux-pci@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
References: <200901042346.42723.rjw@sisk.pl> <200901082145.39429.rjw@sisk.pl> <200901091533.44460.jbarnes@virtuousgeek.org>
In-Reply-To: <200901091533.44460.jbarnes@virtuousgeek.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="windows-1252"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901100038.56748.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 10 January 2009, Jesse Barnes wrote:
> On Thursday, January 8, 2009 12:45 pm Rafael J. Wysocki wrote:
> > On Thursday 08 January 2009, Rafael J. Wysocki wrote:
> > > On Thursday 08 January 2009, Kenji Kaneshige wrote:
> > > > Rafael J. Wysocki wrote:
> > > > > On Thursday 08 January 2009, Kenji Kaneshige wrote:
> > > > >> Rafael J. Wysocki wrote:
> > > > >>> From: Rafael J. Wysocki <rjw@sisk.pl>
> > > > >>>
> > > > >>> If MSI-X interrupt mode is used by the PCI Express port driver, too
> > > > >>> many vectors are allocated and it is not ensured that the right
> > > > >>> vectors will be used for various services.  Namely, the PCI Express
> > > > >>> specification states that both PCI Express native PME and PCI
> > > > >>> Express hotplug will always use the same MSI or MSI-X message for
> > > > >>> signalling interrupts, which implies that the same vector will be
> > > > >>> used by both of them.  Also, the VC service does not use interrupts
> > > > >>> at all. Moreover, is not clear which of the vectors allocated by
> > > > >>> pci_enable_msix() will be used for PME and hotplug and which of
> > > > >>> them will be used for AER if all of these services are configured.
> > > > >>>
> > > > >>> For these reasons, rework the allocation of interrupts for PCI
> > > > >>> Express ports so that at most two vectors are allocated and ensure
> > > > >>> that the right vector will be used for the right purpose.
> >
> > Appended is a cleaned-up version of the patch that also contains comments
> > with references to the appropriate sections of the PCI Express spec.
> 
> We'll need testing here in any case; I'll have to re-read the specs carefully 
> to see if we can really rely on the vector numbers you have here (at first 
> glance Kenji-san's approach seems more robust).

It has a catch too.  Namely, is there any warranty that we'll get the same
vectors when the second pci_enable_msix() is called and that they will be in
the same order?

Rafael
