Return-Path: <linux-kernel-owner+w=401wt.eu-S1758656AbXKGOJm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758656AbXKGOJm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2007 09:09:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757321AbXKGOJd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Nov 2007 09:09:33 -0500
Received: from rtr.ca ([76.10.145.34]:3879 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754169AbXKGOJc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2007 09:09:32 -0500
Message-ID: <4731C71A.4000406@rtr.ca>
Date: Wed, 07 Nov 2007 09:09:30 -0500
From: Mark Lord <lkml@rtr.ca>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Paul Mundt <lethal@linux-sh.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Jeff Garzik <jeff@garzik.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org, linuxsh-dev@lists.sourceforge.net
Subject: Re: [PATCH 1/2] libata: Support PIO polling-only hosts.
References: <20071107081052.GA25913@linux-sh.org> <20071107130940.16b5ea86@the-village.bc.nu> <20071107132702.GA27488@linux-sh.org>
In-Reply-To: <20071107132702.GA27488@linux-sh.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Mundt wrote:
> On Wed, Nov 07, 2007 at 01:09:40PM +0000, Alan Cox wrote:
>> On Wed, 7 Nov 2007 17:10:52 +0900
>> Paul Mundt <lethal@linux-sh.org> wrote:
>>> By default ata_host_activate() expects a valid IRQ in order to
>>> successfully register the host. This patch enables a special case
>>> for registering polling-only hosts that either don't have IRQs
>>> or have buggy IRQ generation (either in terms of handling or
>>> sensing), which otherwise work fine.
>>>
>>> Hosts that want to use polling mode can simply set ATA_FLAG_PIO_POLLING
>>> and pass in a NULL IRQ handler or invalid (< 0) IRQ.
>> NAK
>>
>> Zero is "no IRQ", please use that for polling not "< 0"
>>
> However, platform_get_irq() will happily return IRQ#0, and it's a valid
> vector on plenty of machines. NO_IRQ is also < 0 on at least FR-V, ARM,
> blackin, PA-RISC, some PowerPC, and even IDE.

Too bad.  The Penultimate Penguin wants zero to continue to mean "no IRQ".

Dig into the archives for multiple threads on this exact topic.
The end result is that "0" means "no IRQ".  If your physical IRQ actually
is the number 0, then reencode it to some other value for this purpose.

Yes, a bit of pain, but that's how many parts of the kernel expect it,
and in the end it's no more overall hassle than doing it differently might
have been.

Cheers
