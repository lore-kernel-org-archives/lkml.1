Return-Path: <linux-kernel-owner+w=401wt.eu-S1764964AbXGRRJt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764964AbXGRRJt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2007 13:09:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760467AbXGRRJm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jul 2007 13:09:42 -0400
Received: from mis011.exch011.intermedia.net ([64.78.21.10]:35555 "EHLO
	mis011.exch011.intermedia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755508AbXGRRJl convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2007 13:09:41 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [kvm-devel] [RFC] Deferred interrupt handling.
Date: Wed, 18 Jul 2007 10:09:37 -0700
Message-ID: <64F9B87B6B770947A9F8391472E032160CC16D06@ehost011-8.exch011.intermedia.net>
In-Reply-To: <469E43D5.70802@qumranet.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [kvm-devel] [RFC] Deferred interrupt handling.
Thread-Index: AcfJWyiCg5C5xl4RQ/CXA99/RSDu1wAAuEOw
References: <005901c7c921$79c006c0$6d401440$@com>	<20070718123040.615795b7@the-village.bc.nu>	<64F9B87B6B770947A9F8391472E032160CC16C92@ehost011-8.exch011.intermedia.net> <20070718174736.0baf6d0e@the-village.bc.nu> <469E43D5.70802@qumranet.com>
From: "Dor Laor" <dor.laor@qumranet.com>
To: "Avi Kivity" <avi@qumranet.com>, "Alan Cox" <alan@lxorguk.ukuu.org.uk>
Cc: <kvm-devel@lists.sourceforge.net>, <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 18 Jul 2007 17:09:40.0232 (UTC) FILETIME=[6D5DC880:01C7C95E]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>Alan Cox wrote:
>>> What if we will force the specific device to the end of the list.
>Once
>>> IRQ_NONE was returned by the other devices, we will mask the irq,
>>> forward the irq to the guest, issue a timer for 1msec. Motivation:
>>> 1msec is long enough for the guest to ack the irq + host unmask the
>irq
>>>
>>
>> It makes no difference. The deadlock isn't fixable by timing hacks.
>> Consider the following sequence
>>
>>
>> 	Guest0	-	blocked on I/O
>>
>> 	IRQ14 from your hardware
>> 		Block IRQ14
>> 		Sent to guest (guest is blocked)
>>
>> 	IRQ14 from hard disk
>> 		Ignored (as blocked)
>>


But now the timer will pop and the hard disk will get its irq.
The guest will be released right after.

>> 	Deadlock
>>
>
>IMO the only reasonable solution is to disallow interrupt forwarding
>with shared irqs.  If someone later comes up with a bright idea, we can
>implement it.  Otherwise the problem will solve itself with hardware
>moving to msi.
>

I though of that but the problem is that we'd like to use it with
current hardware
devices that are shared.
:(
