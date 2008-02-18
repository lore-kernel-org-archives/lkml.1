Return-Path: <linux-kernel-owner+w=401wt.eu-S1758775AbYBREaH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758775AbYBREaH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2008 23:30:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758409AbYBRE3v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Feb 2008 23:29:51 -0500
Received: from gate.crashing.org ([63.228.1.57]:36174 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758633AbYBRE3e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2008 23:29:34 -0500
Subject: Re: [RFC/PATCH] iomap: Add specific address space __iomap for
	iomap pointers
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <greg@kroah.com>, Al Viro <viro@ftp.linux.org.uk>,
       jgarzik@pobox.com, David Miller <davem@davemloft.net>,
       David Howells <dhowells@redhat.com>, miles@gnu.org
In-Reply-To: <20080218033600.A9761DDE35@ozlabs.org>
References: <20080218033600.A9761DDE35@ozlabs.org>
Content-Type: text/plain
Date: Mon, 18 Feb 2008 15:28:24 +1100
Message-Id: <1203308904.6740.19.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 2008-02-18 at 14:35 +1100, Benjamin Herrenschmidt wrote:
> The current iomap stuff (pci_iomap, ioport_map, pcim_iomap, ...) is
> confusing as it returns pointers in the _miomem address space.
> 
> However, even if that would work on some architectures, the result
> of those functions is -not- to be used as an __iomem, with accessors
> such as readl/writel, but only with the new brand of specific accessors
> (ioread32/iowrite32/...).

Willy and Al raised a good point off-list, is that in all effective
implementations of this, the MMIO case -does- use compatible virtual
addresses with ioremap, in fact even powerpc does.

Thus if we consider iomap as a kind of superset of the ioremap space
with a "hole" in it for PIO, it's fine to use the same address space
marker and it's fine to interchange the accessors when one -knows-
for sure it's dealing with memory and not IO.

Thus drop my patch,

Ben.


