Return-Path: <linux-kernel-owner+w=401wt.eu-S1752409AbZGTRRK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752409AbZGTRRK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jul 2009 13:17:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750856AbZGTRRJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Jul 2009 13:17:09 -0400
Received: from outbound-mail-307.bluehost.com ([67.222.53.253]:39819 "HELO
	outbound-mail-307.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750807AbZGTRRI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jul 2009 13:17:08 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=gxFWA99v/trZKGCjrn468cnzJ8rfZGWrjmdyRUSzrUXocAbI6TXwTLjLe6Ovxkj2cDOYPqk6Wsze3NxbEz9LVoIRveTAO6AfNy4LHCaMZ8bYJQplqZzSWGdXMq1p0stZ;
Date: Mon, 20 Jul 2009 10:17:02 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: "Hans J. Koch" <hjk@linutronix.de>
Cc: "Michael S. Tsirkin" <mst@redhat.com>, anthony@codemonkey.ws,
       avi@redhat.com, kvm@vger.kernel.org, chrisw@redhat.com,
       hjk@linutronix.de, gregkh@suse.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCHv4] uio: add generic driver for PCI 2.3 devices
Message-ID: <20090720101702.68fee1ab@jbarnes-g45>
In-Reply-To: <20090715213909.GA3637@local>
References: <20090715201340.GA12279@redhat.com>
	<20090715213909.GA3637@local>
X-Mailer: Claws Mail 3.6.1 (GTK+ 2.16.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.28.251 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 15 Jul 2009 23:39:11 +0200
"Hans J. Koch" <hjk@linutronix.de> wrote:

> On Wed, Jul 15, 2009 at 11:13:40PM +0300, Michael S. Tsirkin wrote:
> > This adds a generic uio driver that can bind to any PCI device.
> > First user will be virtualization where a qemu userspace process
> > needs to give guest OS access to the device.
> > 
> > Interrupts are handled using the Interrupt Disable bit in the PCI
> > command register and Interrupt Status bit in the PCI status
> > register.  All devices compliant to PCI 2.3 (circa 2002) and all
> > compliant PCI Express devices should support these bits.  Driver
> > detects this support, and won't bind to devices which do not
> > support the Interrupt Disable Bit in the command register.
> > 
> > It's expected that more features of interest to virtualization will
> > be added to this driver in the future. Possibilities are: mmap for
> > device resources, MSI/MSI-X, eventfd (to interface with kvm), iommu.
> 
> Well, I'm not enough of a PCI expert to tell whether your 2.3-test
> works or not (can it have side effects, e.g. trigger an interrupt
> when you toggle that bit?). I've added Jesse Barnes to Cc: since you
> modify a PCI core header file. If there are no objections from the
> PCI people, I guess we can take this.

pci_reg.h portion looks fine to me, and only supporting devices with
the interrupt disable bit certainly simplifies things.  There were some
other questions on the thread though (like Greg's similar driver); not
sure if you've answered those yet.

-- 
Jesse Barnes, Intel Open Source Technology Center
