Return-Path: <linux-kernel-owner+w=401wt.eu-S1755795AbYLJW0S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755795AbYLJW0S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2008 17:26:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752431AbYLJW0H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Dec 2008 17:26:07 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:43978 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751054AbYLJW0G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2008 17:26:06 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <494041F5.7000209@s5r6.in-berlin.de>
Date: Wed, 10 Dec 2008 23:25:57 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.18) Gecko/20081116 SeaMonkey/1.1.13
MIME-Version: 1.0
To: Frans Pop <elendil@planet.nl>
CC: Robert Hancock <hancockr@shaw.ca>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [patch] ohci1394: don't leave interrupts enabled during suspend/resume
References: <200812061316.38460.elendil@planet.nl> <200812101424.42755.elendil@planet.nl> <49402CBD.9020706@s5r6.in-berlin.de> <200812102246.52798.elendil@planet.nl>
In-Reply-To: <200812102246.52798.elendil@planet.nl>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Frans Pop wrote:
> On Wednesday 10 December 2008, Stefan Richter wrote:
>> Frans Pop wrote:
>>> Any suggestions how to try and trace if that's what's happening?
>> Test after booting with the kernel parameter nomsi.
> 
> With pci=nomsi I still get the same "irq 19: nobody cared".
> 
> The devices that normally get MSI now get assigned as follows:
> - pcieport-driver: IRQ 16 and 17
> - iwlagn: irq 17
> - e1000e: irq 22
> 
> ohci1394 remains the only driver at irq 19.
> 
> Except for the changes due to the nomsi option I see no significant 
> changes in dmesg for boot plus one suspend/resume cycle.

Then I have no other idea what to try.

Whether the Ricoh R5C832 FireWire controller or another device issues
the interrupt is IMO still not clear.  If it was the FireWire
controller, then it would be fundamentally broken.  ohci1394_pci_suspend
performs actually two register writes which both independently disable
interrupts on the controller, and I have a hard time to believe that the
controller gets both of these straight-forward things wrong.
-- 
Stefan Richter
-=====-==--- ==-- -=-=-
http://arcgraph.de/sr/
