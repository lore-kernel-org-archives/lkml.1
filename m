Return-Path: <linux-kernel-owner+w=401wt.eu-S1762670AbZATSwK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762670AbZATSwK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2009 13:52:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753593AbZATSvy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Jan 2009 13:51:54 -0500
Received: from smtp-out.google.com ([216.239.33.17]:17482 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753277AbZATSvw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2009 13:51:52 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:
	x-gmailtapped-by:x-gmailtapped;
	b=GwjDBypyhUU0nTKwRB0Kx+IuJGkzjkwXTw44VORJryC6IOt6x2/IDjGIMxtTSpwya
	wF0sHmFVlVkP1vPkoqZuw==
MIME-Version: 1.0
In-Reply-To: <497614F5.6000301@rtr.ca>
References: <4975F5C1.8090107@rtr.ca>
	 <da824cf30901200944x545431b2va0233abc14e81f9b@mail.gmail.com>
	 <497614F5.6000301@rtr.ca>
Date: Tue, 20 Jan 2009 10:51:47 -0800
Message-ID: <da824cf30901201051v66ae13c4i3476097ee31db281@mail.gmail.com>
Subject: Re: libata, devm_*, and MSI ?
From: Grant Grundler <grundler@google.com>
To: Mark Lord <liml@rtr.ca>
Cc: "IDE/ATA development list" <linux-ide@vger.kernel.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Tejun Heo <htejun@gmail.com>, Jeff Garzik <jgarzik@pobox.com>,
       linux-pci@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-GMailtapped-By: 172.24.198.88
X-GMailtapped: grundler
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 20, 2009 at 10:16 AM, Mark Lord <liml@rtr.ca> wrote:
...
>> I don't think that's necessary if free_irq() or disable_irq() are called.
>> However, I'm not seeing those get called either.
...
> The linux/Documentation/PCI/MSI-HOWTO.txt information is rather explicit
> about it, and the pci core code does seem to expect it.

It looks like pci_disable_msi() requires free_irq() to be called first in order
to guarantee the vectors are no longer in use. But I didn't see any code to
enforce that. Which code was "expecting free_irq()" to be called?

I've learned that anything in Documentation/ is explicit - and sometimes stale
and/or just missing (like you are rediscovering). Two years ago I took a whack
at Documentation/PCI/pci.txt and it's probably time to revisit that again and
add references to pci_intx().


> Those calls to pci_intx() are definitely redundant,
> as the pci core already does that for us on the relevant paths.

True. Want to submit a patch to remove the redundant code?

>
>>> Perhaps somebody from the PCI side of things might enlighten us all.
>>
>>    http://lists.linuxcoding.com/kernel/2005-q3/msg11296.html
>>
>> Shows when pci_intx() was added. linux-pci was NOT cc'd on that email.
>> And no one asked for Documentation/ update. C'est la vie.
>
> ..
>
> I still think the documentation matches the code in the pci core, though.

Yeah, I think you are right.

grant

>
> Patch for sata_mv coming shortly.
>
> Cheers
>
