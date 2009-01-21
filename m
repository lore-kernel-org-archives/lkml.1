Return-Path: <linux-kernel-owner+w=401wt.eu-S1763491AbZAUPza@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763491AbZAUPza (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2009 10:55:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754725AbZAUPzL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Jan 2009 10:55:11 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:52768 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751715AbZAUPzK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2009 10:55:10 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Subject: Re: [PATCH 2/2] PCI PCIe portdrv: Fix allocation of interrupts (rev. 6)
Date: Wed, 21 Jan 2009 16:53:29 +0100
User-Agent: KMail/1.10.3 (Linux/2.6.29-rc2-tst; KDE/4.1.3; x86_64; ; )
Cc: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Linux PCI <linux-pci@vger.kernel.org>,
       Matthew Wilcox <willy@linux.intel.com>
References: <200901131457.58164.rjw@sisk.pl> <200901210133.57537.rjw@sisk.pl> <497677B9.9080501@jp.fujitsu.com>
In-Reply-To: <497677B9.9080501@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-2022-jp"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901211653.30353.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 21 January 2009, Hidetoshi Seto wrote:
> Reviewed-by: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
> 
> Nice work, Rafael!

Thanks for the review!

Best,
Rafael


> Rafael J. Wysocki wrote:
> > From: Rafael J. Wysocki <rjw@sisk.pl>
> > 
> > If MSI-X interrupt mode is used by the PCI Express port driver, too
> > many vectors are allocated and it is not ensured that the right
> > vectors will be used for the right services.  Namely, the PCI Express
> > specification states that both PCI Express native PME and PCI Express
> > hotplug will always use the same MSI or MSI-X message for signalling
> > interrupts, which implies that the same vector will be used by both
> > of them.  Also, the VC service does not use interrupts at all.
> > Moreover, is not clear which of the vectors allocated by
> > pci_enable_msix() in the current code will be used for PME and
> > hotplug and which of them will be used for AER if all of these
> > services are configured.
> > 
> > For these reasons, rework the allocation of interrupts for PCI
> > Express ports so that if MSI-X are enabled, the right vectors will be
> > used for the right purposes.
> > 
> > Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
> > ---
