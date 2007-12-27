Return-Path: <linux-kernel-owner+w=401wt.eu-S1752516AbXL0Lwu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752516AbXL0Lwu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Dec 2007 06:52:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751423AbXL0Lwl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Dec 2007 06:52:41 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:54589 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751361AbXL0Lwk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Dec 2007 06:52:40 -0500
Message-ID: <47739203.3060809@garzik.org>
Date: Thu, 27 Dec 2007 06:52:35 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Arjan van de Ven <arjan@infradead.org>
CC: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>, gregkh@suse.de,
       inux-pci@atrey.karlin.mff.cuni.cz,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Martin Mares <mj@ucw.cz>, Matthew Wilcox <matthew@wil.cx>
Subject: Re: [Patch v2] Make PCI extended config space (MMCONFIG) a driver
 opt-in
References: <20071225032605.29147200@laptopd505.fenrus.org>
In-Reply-To: <20071225032605.29147200@laptopd505.fenrus.org>
Content-Type: text/plain; charset=US-ASCII; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.3 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arjan van de Ven wrote:
> This patch also adds a sysfs property for each device into which root can
> write a '1' to enable extended configuration space. The kernel will print
> a notice into dmesg when this happens (including the name of the app) so that
> if the system crashes as a result of this action, the user can know what
> action/tool caused it.


Comments:

1) [minor] With a bit in struct pci_dev, there is no need for separate 
raw_pci_ops.  That will simplify your patch, with no functionality change.

"golden" arches (no pun intended) may implement raw_pci_ops that 
_always_ work with extended config space, and simply ignore that bit, if 
that is how their underlying non-mmconfig-nor-type1 hardware is implemented.


2) [non-minor] hmmmm.

	[jgarzik@core ~]$ lspci -n | wc -l
	23

So I would have to perform 23 sysfs twiddles, before I could obtain a 
full and unabridged 'lspci -vvvxxx'?

For the userspace interface, the most-often-used knob for diagnostic 
purposes will be the easiest one.  And that's

	echo 1 > enable-ext-cfg-space-for-all-buses-ACPI-says-to
	lspci -vvvxxx


3) [minor] architectures must be able to override 
pci_enable_ext_config().  see "golden arches".




