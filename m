Return-Path: <linux-kernel-owner+w=401wt.eu-S2993284AbXDTQyK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993284AbXDTQyK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2007 12:54:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2993285AbXDTQyK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Apr 2007 12:54:10 -0400
Received: from sanctuary.goth.net ([64.27.17.130]:46336 "EHLO mail.goth.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2993284AbXDTQyI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2007 12:54:08 -0400
Message-ID: <4628F00B.3010304@goth.net>
Date: Fri, 20 Apr 2007 12:53:31 -0400
From: "Preston A. Elder" <prez@goth.net>
User-Agent: Thunderbird 2.0.0.0 (Windows/20070326)
MIME-Version: 1.0
To: Dave Jones <davej@redhat.com>, "Preston A. Elder" <prez@goth.net>,
       linux-kernel@vger.kernel.org
Subject: Re: AGPGart / AMD K7
References: <46286775.5000507@goth.net> <20070420155537.GA20118@redhat.com>
In-Reply-To: <20070420155537.GA20118@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Dave Jones wrote:
> try adding some instrumentation to __pci_register_driver and the functions
> it calls.
>
> oh, one thought.. do you have CONFIG_PCI_MULTITHREAD_PROBE set?
> I'm wondering if the probing is racing with another driver which is claiming
> the same PCI ID. (Edac, or watchdog for example)
>   
Dave,

Multithread is not set.

Here is the output of my instrumentation:

Linux agpgart interface v0.101 (c) Dave Jones
agpgart: DEBUG 0
agpgart: DEBUG 1
__pci_register_driver: In function
__pci_register_driver: driver = agpgart-amdk7, multithread = 0
__pci_register_driver: Before Spinlock
__pci_register_driver: Before List Init
__pci_register_driver: Before Driver Register
__pci_register_driver: Error = 0
__pci_register_driver: Returning 0

The DEBUG 0 and 1 are coming from agp_amdk7_init()
There is a DEBUG 2 at the top of agp_amdk7_probe(), even before
pci_find_capability, but the function never gets called.

I assume an error of 0 means no conflict.  Any further steps to take for
this?  I would really like my AGP working :S
Especially since lspci obviously detects it, even tells me it supports
1x, 2x and 4x.

PreZ :S
