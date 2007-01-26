Return-Path: <linux-kernel-owner+w=401wt.eu-S1030698AbXAZBpn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030698AbXAZBpn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jan 2007 20:45:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030699AbXAZBpn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jan 2007 20:45:43 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:41644 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030698AbXAZBpm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jan 2007 20:45:42 -0500
Message-ID: <45B95D3A.10108@pobox.com>
Date: Thu, 25 Jan 2007 20:45:30 -0500
From: Jeff Garzik <jgarzik@pobox.com>
User-Agent: Thunderbird 1.5.0.9 (X11/20061219)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: David Woodhouse <dwmw2@infradead.org>, Alan <alan@lxorguk.ukuu.org.uk>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] libata-sff: Don't call bmdma_stop on non DMA capable
 controllers
References: <20070125150905.652f9ce2@localhost.localdomain>  <1169741658.3593.98.camel@shinybook.infradead.org>  <20070125172739.0c990a9a@localhost.localdomain>  <Pine.LNX.4.64.0701250940220.25027@woody.linux-foundation.org> <1169770985.3593.146.camel@shinybook.infradead.org> <Pine.LNX.4.64.0701251703570.25027@woody.linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0701251703570.25027@woody.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.7 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> 
> On Fri, 26 Jan 2007, David Woodhouse wrote:
>> You're thinking of MMIO, while the case we were discussing was PIO. My
>> laptop is perfectly happy to assign PIO resources from zero.
> 
> I was indeed thinking MMIO, but I really think it should extend to PIO 
> also. It certainly is (again) true on PC's, where the low IO space is 
> special and reserved for motherboard/system devices.

Via the even-less-of-an-excuse-than-you-thought department:

Many (most?) non-x86 handle PIO via special mappings and additional 
serialization instructions, but otherwise treat PIO register space in a 
very similar manner to MMIO.

Thus, it's /easier/ on non-x86 to ensure that PIO addresses never land 
at zero, because you must remap /anyway/.  It's only on x86 that PIO 
register spaces are accessed by vastly different CPU instructions.  Most 
other arches convert PIO accesses into massage+mmio R/W+massage.

On sparc64, for example, after I pointed this out to DaveM, he was able 
to implement the new iomap interface without the 'if (pio-mem-area)' 
branch present on x86.

	Jeff



