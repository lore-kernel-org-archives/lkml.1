Return-Path: <linux-kernel-owner+w=401wt.eu-S1758268AbZAOVlT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758268AbZAOVlT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 16:41:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752617AbZAOVk7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 16:40:59 -0500
Received: from ovro.ovro.caltech.edu ([192.100.16.2]:34931 "EHLO
	ovro.ovro.caltech.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752265AbZAOVk6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 16:40:58 -0500
Date: Thu, 15 Jan 2009 13:40:56 -0800
From: Ira Snyder <iws@ovro.caltech.edu>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linuxppc-dev@ozlabs.org, netdev@vger.kernel.org,
       Rusty Russell <rusty@rustcorp.com.au>, linux-kernel@vger.kernel.org,
       shemminger@vyatta.com, David Miller <davem@davemloft.net>,
       Jan-Bernd Themann <themann@de.ibm.com>
Subject: Re: [PATCH RFC v5] net: add PCINet driver
Message-ID: <20090115214056.GC9091@ovro.caltech.edu>
Mail-Followup-To: Arnd Bergmann <arnd@arndb.de>, linuxppc-dev@ozlabs.org,
	netdev@vger.kernel.org, Rusty Russell <rusty@rustcorp.com.au>,
	linux-kernel@vger.kernel.org, shemminger@vyatta.com,
	David Miller <davem@davemloft.net>,
	Jan-Bernd Themann <themann@de.ibm.com>
References: <20090107195052.GA24981@ovro.caltech.edu> <200901151853.52202.arnd@arndb.de> <20090115192129.GB9091@ovro.caltech.edu> <200901152222.55006.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200901152222.55006.arnd@arndb.de>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.0 (ovro.ovro.caltech.edu); Thu, 15 Jan 2009 13:40:58 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 15, 2009 at 10:22:53PM +0100, Arnd Bergmann wrote:
> On Thursday 15 January 2009, Ira Snyder wrote:
> > I have another question for you Arnd.
> > 
> > What did you use as the host and guest drivers when you ran virtio over
> > PCI? Did you use two unmodified instances of virtio_net (one on host,
> > one on guest) for networking, or did you write new virtio drivers for
> > those? How about for virtio_console (if you ran it at all).
> 
> Jan-Bernd may be able to tell you details about this, and send you the
> driver code that his interns implemented for it.
> This was only doing virtio_net between two machines using MMIO transfers,
> i.e. the DMA engine was unused, but there was a mailbox interrupt (if you
> have one of these, you won't need MSI, btw -- just write a DMA to it).
> 

Thanks. Jan-Bernd, I'm looking forward to any input you have.

I'd be happy enough to use mmio at this point. My early attempts with
this driver only used mmio as well. The DMA was bolted on later.

I do have mailboxes (two inbound, two outbound) which can generate
interrupts, as well as doorbell registers (one inbound, one outbound).
The doorbell register's bits are "write 1 to clear", and can only be
cleared by the opposite side.

All of them can cause interrupts over PCI. I used the doorbell registers
to communicate which action needed to be taken in my driver. One
doorbell for "receive packet(s)", another for "packet transmission(s)
complete", etc. I used the mailboxes to transfer characters for the
virtual serial port.

Ira
