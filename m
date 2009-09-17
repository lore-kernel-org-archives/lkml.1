Return-Path: <linux-kernel-owner+w=401wt.eu-S1758395AbZIQQQu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758395AbZIQQQu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Sep 2009 12:16:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758348AbZIQQQt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Sep 2009 12:16:49 -0400
Received: from g5t0007.atlanta.hp.com ([15.192.0.44]:42042 "EHLO
	g5t0007.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758249AbZIQQQt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Sep 2009 12:16:49 -0400
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: fixing "pci=use_crs"
Date: Thu, 17 Sep 2009 10:16:49 -0600
User-Agent: KMail/1.9.10
Cc: Gary Hade <garyhade@us.ibm.com>, Jesse Barnes <jbarnes@virtuousgeek.org>,
       Jaswinder Singh Rajput <jaswinder@kernel.org>,
       Yinghai Lu <yhlu.kernel@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       Len Brown <lenb@kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>, x86@kernel.org,
       linux-kernel@vger.kernel.org
References: <200909161715.24376.bjorn.helgaas@hp.com>
In-Reply-To: <200909161715.24376.bjorn.helgaas@hp.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200909171016.50087.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 16 September 2009 05:15:23 pm Bjorn Helgaas wrote:
> The user currently has to boot with "pci=use_crs" to make
> hot-add work on some machines.  I think this is a poor
> user experience, and I'd like to figure out a better solution.
> 
> We tried making "pci=use_crs" the default, which didn't work
> because it broke machines like Larry's.  I'd like to look
> at that machine in more detail and figure out what it's doing.
> 
> Larry, would you mind collecting the output of:
> 
>   # dmesg
>   # cat /proc/iomem
>   # lspci -vv
>   # cd /sys/devices/; grep . pnp*/*/{id,resources}
> 
> and attaching them here:
> 
>     http://bugzilla.kernel.org/show_bug.cgi?id=14183

Thanks a lot, Larry.

It looks like you have an HP box -- what exactly is it and
what BIOS version do you have?  Maybe I can borrow one to play
with myself so I don't have to bug you as much.

You don't happen to have Windows on it also, do you?  If you do,
I'd like to know what the device manager says about the PCI bridges.

Your dmesg from LKML
(http://thread.gmane.org/gmane.linux.kernel/856413/focus=856458)
suggests that ACPI told us about a whole bunch of resources:

  pci_bus 0000:00: resource 0 io:  [0x00-0xcf7]
  pci_bus 0000:00: resource 1 io:  [0xd00-0xffff]
  pci_bus 0000:00: resource 2 mem: [0x0a0000-0x0bffff]
  pci_bus 0000:00: resource 3 mem: [0x0c0000-0x0c3fff]
  pci_bus 0000:00: resource 4 mem: [0x0c4000-0x0c7fff]
  pci_bus 0000:00: resource 5 mem: [0x0c8000-0x0cbfff]
  pci_bus 0000:00: resource 6 mem: [0x0cc000-0x0cffff]
  pci_bus 0000:00: resource 7 mem: [0x0d4000-0x0d7fff]
  pci_bus 0000:00: resource 8 mem: [0x0d8000-0x0dbfff]
  pci_bus 0000:00: resource 9 mem: [0x0dc000-0x0dffff]
  ...

but the new dmesg (http://bugzilla.kernel.org/attachment.cgi?id=23106)
only has a few:

  pci_bus 0000:00: resource 0 io:  [0x00-0xffff]
  pci_bus 0000:00: resource 1 mem: [0x000000-0xffffffffffffffff]
  pci_bus 0000:01: resource 1 mem: [0xfc100000-0xfc1fffff]
  pci_bus 0000:01: resource 3 io:  [0x00-0xffff]
  pci_bus 0000:01: resource 4 mem: [0x000000-0xffffffffffffffff]
  pci_bus 0000:06: resource 0 io:  [0x4000-0x4fff]
  pci_bus 0000:06: resource 1 mem: [0xf8000000-0xfbffffff]
  pci_bus 0000:04: resource 1 mem: [0xfc000000-0xfc0fffff]

The extra resources in the old dmesg could be from "pci=use_crs"
being the default, but if that were the case, they should be in
the PNP resource dump.  Did you update the BIOS between those
boots?

Bjorn
