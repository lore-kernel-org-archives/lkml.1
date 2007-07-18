Return-Path: <linux-kernel-owner+w=401wt.eu-S935026AbXGRQ5o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935026AbXGRQ5o (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2007 12:57:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762287AbXGRQ5d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jul 2007 12:57:33 -0400
Received: from il.qumranet.com ([82.166.9.18]:57541 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933977AbXGRQ5b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2007 12:57:31 -0400
Message-ID: <469E4679.205@qumranet.com>
Date: Wed, 18 Jul 2007 19:57:29 +0300
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 2.0.0.4 (X11/20070615)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Dor Laor <dor.laor@qumranet.com>, kvm-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
Subject: Re: [kvm-devel] [RFC] Deferred interrupt handling.
References: <005901c7c921$79c006c0$6d401440$@com>	<20070718123040.615795b7@the-village.bc.nu>	<64F9B87B6B770947A9F8391472E032160CC16C92@ehost011-8.exch011.intermedia.net>	<20070718174736.0baf6d0e@the-village.bc.nu>	<469E43D5.70802@qumranet.com> <20070718175708.6968923e@the-village.bc.nu>
In-Reply-To: <20070718175708.6968923e@the-village.bc.nu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (firebolt.argo.co.il [0.0.0.0]); Wed, 18 Jul 2007 19:57:29 +0300 (IDT)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
>> IMO the only reasonable solution is to disallow interrupt forwarding
>> with shared irqs.  If someone later comes up with a bright idea, we can
>>     
>
> Which means you are back to ISA bus devices. Even checking if an IRQ is
> currently unshared isn't simple as with hotplug this may change.
>
>   

Hotplug is user-controllable, so if the user refrains from adding pci
devices after assigning a device to the guest, it should work.  I think
that USB interrupts are assigned to the controller, not the device, so
USB hotplug can be ruled out.

I admit this is fairly weak.

>> implement it.  Otherwise the problem will solve itself with hardware
>> moving to msi.
>>     
>
> Only if MSI ever works properly on the bridges and hardware 8(
>   

Oh, I've no doubt it will be made to work -- there's money to be saved
in those irq lines.  And msi makes sense technically as well.

-- 
Do not meddle in the internals of kernels, for they are subtle and quick to panic.

