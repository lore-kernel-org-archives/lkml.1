Return-Path: <linux-kernel-owner+w=401wt.eu-S1761417AbZANK6Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761417AbZANK6Y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2009 05:58:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754815AbZANK6N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Jan 2009 05:58:13 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:56835 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753165AbZANK6L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2009 05:58:11 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
Subject: Re: [PATCH 5/8] PCI PCIe portdrv: Fix allocation of interrupts
Date: Wed, 14 Jan 2009 11:57:32 +0100
User-Agent: KMail/1.10.3 (Linux/2.6.29-rc1-rjw; KDE/4.1.3; x86_64; ; )
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>,
       Linux PCI <linux-pci@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
References: <200901042346.42723.rjw@sisk.pl> <496D815E.8010107@jp.fujitsu.com> <200901141135.31165.rjw@sisk.pl>
In-Reply-To: <200901141135.31165.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-2022-jp"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901141157.32720.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 14 January 2009, Rafael J. Wysocki wrote:
> On Wednesday 14 January 2009, Kenji Kaneshige wrote:
[...]
> > I'm sorry but I don't understand what the problem is.
> > Do you mean pci_disable_msix() doesn't work on some platforms?
> 
> No, I don't.  It was just confusion on my side, sorry.
> 
> Please have a look at the new version of the patch I sent yesterday
> (http://marc.info/?l=linux-pci&m=123185510828181&w=4).

BTW, in your patch the first dummy pci_enable_msix() allocates just one
vector, which means that the contents of both
msix_entries[idx_hppme].entry and msix_entries[idx_aer].entry will be the same,
if my reading of the spec (PCI 3.0 in this case) is correct.

However, if the second pci_enable_msix() allocates two vectors, the contents of the
message number fields in the PCIE_CAPABILITIES_REG and PCI_ERR_ROOT_STATUS
registers may change as a result.

Thanks,
Rafael
