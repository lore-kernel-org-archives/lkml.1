Return-Path: <linux-kernel-owner+w=401wt.eu-S1755832AbYIPRTe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755832AbYIPRTe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2008 13:19:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755207AbYIPRTX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Sep 2008 13:19:23 -0400
Received: from outbound-dub.frontbridge.com ([213.199.154.16]:12557 "EHLO
	IE1EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755174AbYIPRTW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2008 13:19:22 -0400
X-BigFish: VPS-43(zz1432R98dR936eQ62a3L1805M936fQzz10d3izzz32i6bh43j62h)
X-Spam-TCS-SCL: 1:0
X-WSS-ID: 0K7ATFO-02-Y3W-01
Date: Tue, 16 Sep 2008 19:18:14 +0200
From: Robert Richter <robert.richter@amd.com>
To: Alexey Dobriyan <adobriyan@gmail.com>
CC: Yinghai Lu <yhlu.kernel@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/5] pci: using pci_printk
Message-ID: <20080916171814.GB23138@erda.amd.com>
References: <1221555174-30060-1-git-send-email-yhlu.kernel@gmail.com> <1221555174-30060-3-git-send-email-yhlu.kernel@gmail.com> <20080916102052.GD21012@x200.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20080916102052.GD21012@x200.localdomain>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-OriginalArrivalTime: 16 Sep 2008 17:18:15.0442 (UTC) FILETIME=[346E1720:01C91820]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 16.09.08 14:20:52, Alexey Dobriyan wrote:
> On Tue, Sep 16, 2008 at 01:52:52AM -0700, Yinghai Lu wrote:
> > --- linux-2.6.orig/drivers/pci/probe.c
> > +++ linux-2.6/drivers/pci/probe.c
> > @@ -304,7 +304,7 @@ static int __pci_read_base(struct pci_de
> 
> > -			printk(KERN_DEBUG "PCI: %s reg %x 64bit mmio: [%llx, %llx]\n",
> > +			pci_printk(KERN_LOG_DEBUG, KERN_DEBUG "PCI: %s reg %x 64bit mmio: [%llx, %llx]\n",
> 				   ^^^^^^^^^^^^^^^^^^^^^^^^^^
> 
> Brilliant, simply brilliant!

Wouldn't it be much simpler to have an i/f as for dev_dbg() and also
run the log level check only for debug messages? And, the dev_dbg()
macro seems to have code that can be binary pached (?) to enable it if
the compile option is not set.

-Robert

#define dev_dbg(dev, format, arg...)            \
        ({ if (0) dev_printk(KERN_DEBUG, dev, format, ##arg); 0; })


-- 
Advanced Micro Devices, Inc.
Operating System Research Center
email: robert.richter@amd.com

