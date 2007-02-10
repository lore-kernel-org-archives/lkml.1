Return-Path: <linux-kernel-owner+w=401wt.eu-S1751783AbXBJTQm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751783AbXBJTQm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Feb 2007 14:16:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751797AbXBJTQm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Feb 2007 14:16:42 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:48449 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751783AbXBJTQl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Feb 2007 14:16:41 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <45CE19F3.2070603@s5r6.in-berlin.de>
Date: Sat, 10 Feb 2007 20:16:03 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.9) Gecko/20070121 SeaMonkey/1.0.7
MIME-Version: 1.0
To: Andi Kleen <ak@suse.de>
CC: Stefan Richter <stefanr@s5r6.in-berlin.de>, Bernhard Kaindl <bk@suse.de>,
       discuss@x86-64.org, linux1394-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
Subject: Re: remote debugging via FireWire
References: <200702101242.48467.ak@suse.de> <200702101502.59431.ak@suse.de>	<45CDE14C.4040203@s5r6.in-berlin.de> <200702101641.36239.ak@suse.de>
In-Reply-To: <200702101641.36239.ak@suse.de>
X-Enigmail-Version: 0.94.1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

[ohci1394_early]

Some remarks to the September 2006 version at
http://www.suse.de/~bk/firewire/ :

  - Seems its .remove won't work properly if more than one OHCI-1394
    controller is installed.  And it's .probe isn't reentrant, but that
    might be less of a problem.
  - Its functionality will be lost if there is a FireWire bus reset,
    e.g. when something is plugged in or out.  To keep physical DMA
    alive, an interrupt handler had to be installed which writes ~0
    to OHCI1394_PhyReqFilter{Hi,Lo}Set.  Can interrupt handlers be
    registered in an early setup stage?
  - There might be some register accesses in the setup which could be
    omitted; I'd have to look this up.
  - Could be optimized to not use ohci1394.h::struct ti_ohci.
  - PCI_CLASS_FIREWIRE_OHCI can be replaced by
    include/linux/pci_ids.h::PCI_CLASS_SERIAL_FIREWIRE_OHCI which
    was newly added in 2.6.20-git#.
  - I suppose .probe should check for PCI_CLASS_SERIAL_FIREWIRE_OHCI
    instead of PCI_CLASS_SERIAL_FIREWIRE.
  - How about dropping support for configuring this as module, to
    simplify the code?  Unless this would interfere with ohci1394; and
    it probably would if there was an interrupt handler...
  - "depends on X86_64" is missing in Kconfig.
  - Maybe put it into arch/x86_64/drivers/ instead of drivers/ieee1394?
  - Plus what I mentioned earlier in the thread.

I could send code to address some of this at next weekend or later.
-- 
Stefan Richter
-=====-=-=== --=- -=-=-
http://arcgraph.de/sr/
