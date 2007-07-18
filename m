Return-Path: <linux-kernel-owner+w=401wt.eu-S935253AbXGRQq2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935253AbXGRQq2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2007 12:46:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762148AbXGRQqR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jul 2007 12:46:17 -0400
Received: from il.qumranet.com ([82.166.9.18]:44318 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759776AbXGRQqQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2007 12:46:16 -0400
Message-ID: <469E43D5.70802@qumranet.com>
Date: Wed, 18 Jul 2007 19:46:13 +0300
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 2.0.0.4 (X11/20070615)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Dor Laor <dor.laor@qumranet.com>, kvm-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
Subject: Re: [kvm-devel] [RFC] Deferred interrupt handling.
References: <005901c7c921$79c006c0$6d401440$@com>	<20070718123040.615795b7@the-village.bc.nu>	<64F9B87B6B770947A9F8391472E032160CC16C92@ehost011-8.exch011.intermedia.net> <20070718174736.0baf6d0e@the-village.bc.nu>
In-Reply-To: <20070718174736.0baf6d0e@the-village.bc.nu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (firebolt.argo.co.il [0.0.0.0]); Wed, 18 Jul 2007 19:46:13 +0300 (IDT)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
>> What if we will force the specific device to the end of the list. Once
>> IRQ_NONE was returned by the other devices, we will mask the irq,
>> forward the irq to the guest, issue a timer for 1msec. Motivation:
>> 1msec is long enough for the guest to ack the irq + host unmask the irq
>>     
>
> It makes no difference. The deadlock isn't fixable by timing hacks.
> Consider the following sequence
>
>
> 	Guest0	-	blocked on I/O
>
> 	IRQ14 from your hardware
> 		Block IRQ14
> 		Sent to guest (guest is blocked)
>
> 	IRQ14 from hard disk
> 		Ignored (as blocked)
>
> 	Deadlock
>   

IMO the only reasonable solution is to disallow interrupt forwarding
with shared irqs.  If someone later comes up with a bright idea, we can
implement it.  Otherwise the problem will solve itself with hardware
moving to msi.


-- 
Do not meddle in the internals of kernels, for they are subtle and quick to panic.

