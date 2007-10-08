Return-Path: <linux-kernel-owner+w=401wt.eu-S1755235AbXJHLnU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755235AbXJHLnU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2007 07:43:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753550AbXJHLnH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Oct 2007 07:43:07 -0400
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:42546 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753764AbXJHLnG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2007 07:43:06 -0400
X-Sasl-enc: 5ngabzqIpoW1tzn15yv0rpbt0LcVlfBsKAVhVCtdnZio 1191843783
Mime-Version: 1.0 (Apple Message framework v752.2)
In-Reply-To: <4709DFD5.5050900@redhat.com>
References: <fa.9BwFZjxkV7dKD7EmsWMTtKId3Qc@ifi.uio.no>	 <fa.m+2QwZVzW3oTWJBsJ4fdAiUZWkM@ifi.uio.no>  <4707D876.8080306@shaw.ca> <1191705303.7536.6.camel@oasis.donpoo.home> <4709DFD5.5050900@redhat.com>
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <5FE0ADA0-553C-4372-9F85-D1C21C4D3A3D@bluecamel.eml.cc>
Content-Transfer-Encoding: 7bit
From: Scott <linux-kernel@bluecamel.eml.cc>
Subject: Re: cx88 pci_abort messages
Date: Mon, 8 Oct 2007 07:43:09 -0400
To: Gerd Hoffmann <kraxel@redhat.com>, linux-kernel@vger.kernel.org
X-Mailer: Apple Mail (2.752.2)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Oct 8, 2007, at 3:44 AM, Gerd Hoffmann wrote:

> Scott wrote:
>> On Sat, 2007-10-06 at 12:48 -0600, Robert Hancock wrote:
>>>>> Oct  2 21:59:32 htpc cx88[0]: irq mpeg  [0x80000] pci_abort*
>>>>> Oct  2 21:59:32 htpc cx88[0]/2-mpeg: general errors: 0x0008000
>
>> I assumed it was an interrupt issue based on the 'irq mepg' error,  
>> not a
>> DMA issue.
>
> It's a DMA issue.  The chip raised an irq to signal the error  
> condition
> to the driver, thats why it is printed by the irq handler.  Happened
> while streamimg mpeg data.
>
> Havn't looked at the code for years now, but IIRC the 0x800000 is the
> raw error code from some status register, pci_abort is the error  
> bit in
> clear text, meaning some PCI DMA transfer was aborted.  No idea why
> though ...

I went through and did the basics. Disabled SMP (it's a core 2 duo  
cpu), tried with noapic, nolapic settings, tried with pci=irqroute,  
and tried with acpi=off. Poking through the module code I noticd in  
cx88-mpeg.c the irq_debug option. I think this is the debug switch I  
want so I'll try to gather more info this week. At the very least it  
looks like it will help me walk through the code to get a better idea  
of what's going on.

--
Scott

