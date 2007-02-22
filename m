Return-Path: <linux-kernel-owner+w=401wt.eu-S1751594AbXBVNa4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751594AbXBVNa4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Feb 2007 08:30:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751600AbXBVNaz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Feb 2007 08:30:55 -0500
Received: from mis011-1.exch011.intermedia.net ([64.78.21.128]:2414 "EHLO
	mis011-1.exch011.intermedia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751592AbXBVNaz convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Feb 2007 08:30:55 -0500
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [kvm-devel] [PATCH 10/13] KVM: Wire up hypercall handlers toa	central arch-independent location
Date: Thu, 22 Feb 2007 05:31:18 -0800
Message-ID: <64F9B87B6B770947A9F8391472E032160A91BB3D@ehost011-8.exch011.intermedia.net>
In-Reply-To: <1172149924.3531.260.camel@laptopd505.fenrus.org>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [kvm-devel] [PATCH 10/13] KVM: Wire up hypercall handlers toa	central arch-independent location
Thread-Index: AcdWgxHn4ax+X+KHRBSRcZ/Hv3yObgAAmrug
References: <45D979D3.2020907@qumranet.com> <20070219103052.4D23725016B@il.qumranet.com><20070221103733.GI3945@ucw.cz> <45DD6CF0.3010509@qumranet.com> <64F9B87B6B770947A9F8391472E032160A91BAF3@ehost011-8.exch011.intermedia.net> <1172140490.3531.236.camel@laptopd505.fenrus.org> <45DD7330.1030001@qumranet.com> <1172142081.3531.243.camel@laptopd505.fenrus.org> <45DD94D3.4030102@qumranet.com> <1172149924.3531.260.camel@laptopd505.fenrus.org>
From: "Dor Laor" <dor.laor@qumranet.com>
To: "Arjan van de Ven" <arjan@infradead.org>, "Avi Kivity" <avik@qumranet.com>
Cc: "Pavel Machek" <pavel@ucw.cz>, <kvm-devel@lists.sourceforge.net>,
       <akpm@osdl.org>, <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 22 Feb 2007 13:30:54.0110 (UTC) FILETIME=[AD4703E0:01C75685]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>
>
>> Somthing else that came up in a conversation with Dor: the need for a
>> clean way to raise a guest interrupt.  The guest may be sleeping in
>> userspace, scheduled out, or running on another cpu (and requiring an
>> ipi to get it out of guest mode).
>
>yeah it'd be nice if I could just call a function for it rather than
>poking into kvm internals ;)
>
>> Right now I'm thinking about using the signal machinery since it
appears
>> to do exactly the right thing.
>
>signals are *expensive* though.
>
>If you design an interrupt interface, it'd rock if you could make it
>such that it is "raise <this> interrupt within <x> miliseconds from
>now", rather than making it mostly synchronous. That way irq mitigation
>becomes part of the interface rather than having to duplicate it all
>over the virtual drivers...

Why do you need to raise an interrupt within a timeout?
I thought on just asking for a synchronous, as-fast-as-you-can-get
interrupt. If you need an interrupt that should pop within some
milliseconds you can set a timer.

>
>
>
>--
>if you want to mail me at work (you don't), use arjan (at)
linux.intel.com
>Test the interaction between Linux and your BIOS via
>http://www.linuxfirmwarekit.org

