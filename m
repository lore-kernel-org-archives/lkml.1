Return-Path: <linux-kernel-owner+w=401wt.eu-S2993265AbXDTP4A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993265AbXDTP4A (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2007 11:56:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2993271AbXDTP4A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Apr 2007 11:56:00 -0400
Received: from mx1.redhat.com ([66.187.233.31]:41184 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992973AbXDTPzz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2007 11:55:55 -0400
Date: Fri, 20 Apr 2007 11:55:37 -0400
From: Dave Jones <davej@redhat.com>
To: "Preston A. Elder" <prez@goth.net>
Cc: linux-kernel@vger.kernel.org
Subject: Re: AGPGart / AMD K7
Message-ID: <20070420155537.GA20118@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	"Preston A. Elder" <prez@goth.net>, linux-kernel@vger.kernel.org
References: <46286775.5000507@goth.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46286775.5000507@goth.net>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 20, 2007 at 03:10:45AM -0400, Preston A. Elder wrote:
 
 > I have a Tyan Thunder K7x Pro (S2469) and the amd-k7-agp module does not
 > seem to be probing my AGP device.  I have even tried putting debugging
 > code into the amd-k7-agp module, and sure enough I can see it being
 > loaded, but the probe function is never called.  This is with kernel 2.6.19.

This is the second report of this I've heard, and I really have no good
explanation for it.

 > As you can see, the first device is indeed showing up as AGP capable and
 > such, its just never probed (at least the probe function in amd-k7-agp
 > is never called once the module is loaded).
 > 
 > To simplefy things, here is a pcitweak -l of the top two devices above:
 > PCI: 00:00:0: chip 1022,700c card 0000,0000 rev 20 class 06,00,00 hdr 00
 > PCI: 00:01:0: chip 1022,700d card 0000,0000 rev 00 class 06,04,00 hdr 01
 > 
 > In the amd-k7-agp code, this is in the device list:
 >     {
 >     .class      = (PCI_CLASS_BRIDGE_HOST << 8),
 >     .class_mask = ~0,
 >     .vendor     = PCI_VENDOR_ID_AMD,
 >     .device     = PCI_DEVICE_ID_AMD_FE_GATE_700C,
 >     .subvendor  = PCI_ANY_ID,
 >     .subdevice  = PCI_ANY_ID,
 >     },
 > 
 > Which matches the first device.  So I'm completely unsure as to why this
 > device is never probed or how to fix it.

try adding some instrumentation to __pci_register_driver and the functions
it calls.

oh, one thought.. do you have CONFIG_PCI_MULTITHREAD_PROBE set?
I'm wondering if the probing is racing with another driver which is claiming
the same PCI ID. (Edac, or watchdog for example)

	Dave

-- 
http://www.codemonkey.org.uk
