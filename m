Return-Path: <linux-kernel-owner+w=401wt.eu-S1757840AbYLFQMr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757840AbYLFQMr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Dec 2008 11:12:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755114AbYLFQMj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Dec 2008 11:12:39 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:54736 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754916AbYLFQMi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Dec 2008 11:12:38 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <493AA46A.30004@s5r6.in-berlin.de>
Date: Sat, 06 Dec 2008 17:12:26 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.18) Gecko/20081116 SeaMonkey/1.1.13
MIME-Version: 1.0
To: Frans Pop <elendil@planet.nl>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux1394-devel@lists.sourceforge.net,
       Stefan Richter <stefanr@s5r6.in-berlin.de>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [patch] ohci1394: don't leave interrupts enabled during suspend/resume
References: <200812061316.38460.elendil@planet.nl> <200812061536.47894.elendil@planet.nl>
In-Reply-To: <200812061536.47894.elendil@planet.nl>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Frans Pop wrote:
> On my HP 2510p I get the following in dmesg during near the end of most
> resumes from suspend to RAM:
> 
> irq 19: nobody cared (try booting with the "irqpoll" option)
> Pid: 0, comm: swapper Not tainted 2.6.28-rc7 #67
> Call Trace:
>  <IRQ>  [<ffffffffa00ee9e1>] ? ohci_irq_handler+0x60/0x7e9 [ohci1394]
...
> There also seems to be an interrupt storm during suspend/resume when this
> happens:
>  19:      99968         33   IO-APIC-fasteoi   ohci1394
> 
> This patch gets rid of both issues and makes the resume as a whole
> significantly faster.

Looks good, thanks.  Committed to linux1394-2.6.git.

...
> I don't actually use firewire, so I cannot test anything other than
> checking dmesg and seeing that there are no changes. With the patch
> I do see a very slow increase of the interrupt count, so the device
> seems active.

Yes, there should be an interrupt every 64 seconds even if no IO is
going through the FireWire controller.

> Please review the patch carefully, especially the error handling.
> The patch is essentially only copy-and-paste work, with checks against
> other drivers and the ohci1394_pci_probe function.

Error handling in ohci1394's suspend method looked dubious already
before your patch...
-- 
Stefan Richter
-=====-==--- ==-- --==-
http://arcgraph.de/sr/
