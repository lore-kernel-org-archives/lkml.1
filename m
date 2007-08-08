Return-Path: <linux-kernel-owner+w=401wt.eu-S1760584AbXHHJDg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760584AbXHHJDg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2007 05:03:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755410AbXHHJD3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Aug 2007 05:03:29 -0400
Received: from dgate1.fujitsu-siemens.com ([217.115.66.35]:27607 "EHLO
	dgate1.fujitsu-siemens.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755359AbXHHJD2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2007 05:03:28 -0400
DomainKey-Signature: s=s768; d=fujitsu-siemens.com; c=nofws; q=dns; b=jcp9UGTHDwfz9Df8Nd6rlTTpZMPqnNJ0O/9kRVSwbPhOJmRuqdKatPDKVCwN8rjV6PQrrocy06Ul+jypiEfelBk/d9tW0uU2pq3dx3n/RUlISwRGGfEPs+T//gs1TsYI;
X-SBRSScore: None
X-IronPort-AV: E=Sophos;i="4.19,234,1183327200"; 
   d="scan'208";a="88017620"
Message-ID: <46B986D5.2010407@fujitsu-siemens.com>
Date: Wed, 08 Aug 2007 11:03:17 +0200
From: Martin Wilck <martin.wilck@fujitsu-siemens.com>
Organization: Fujitsu Siemens Computers
User-Agent: Thunderbird 1.5.0.8 (X11/20061025)
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: "vgoyal@in.ibm.com" <vgoyal@in.ibm.com>, Haren Myneni <hbabu@us.ibm.com>,
       "kexec@lists.infradead.org" <kexec@lists.infradead.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: PATCH/RFC: [kdump] fix APIC shutdown sequence
References: <46B73955.2080007@fujitsu-siemens.com>	<20070807142928.GA18839@in.ibm.com>	<46B8AECA.7050908@fujitsu-siemens.com> <m1ir7qg7kd.fsf@ebiederm.dsl.xmission.com>
In-Reply-To: <m1ir7qg7kd.fsf@ebiederm.dsl.xmission.com>
X-Enigmail-Version: 0.94.2.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Eric,

> How bad is it if you just run with irqpoll in the kdump kernel?
> If running with irqpoll is usable that is probably preferable
> to putting in a hardware work around we can survive without.

Yes, I tried that. No effect.

> Have you done any looking at moving where the kernel initalizes
> io_apics?  One of the todo items on the path is to leave
> io_apic mode enabled and just startup the kernel in io_apic
> mode.

I have tried to recover from the "IRR set" situation in several ways by
changing setup_IO_APIC_irq(). But I haven't found a way to recover from
this situation once disable_IO_APIC() had been called.
I concluded thatthe sequence of events
"send INT message - never receive EOI - disable IO-APIC pin"
messes up the IO-APIC (at least this specific one in the
PCIEx-PCI bridge of the ICH7).

The current state of affairs is that the only thing that "worked" was to
re-enable irqs.

> When doing that a version of your work around (if needed)
> would certainly be reasonable.

> My general concern is that the trickier we get in the code
> running in the crashed kernel the less reliable the entire
> process will be.

That's certainly correct. I am grateful for all hints that simplify my patch.

Thanks,
Martin

-- 
Martin Wilck
PRIMERGY System Software Engineer
FSC IP ESP DE6

Fujitsu Siemens Computers GmbH
Heinz-Nixdorf-Ring 1
33106 Paderborn
Germany

Tel:			++49 5251 8 15113
Fax:			++49 5251 8 20409
Email:			mailto:martin.wilck@fujitsu-siemens.com
Internet:		http://www.fujitsu-siemens.com
Company Details:	http://www.fujitsu-siemens.com/imprint.html
