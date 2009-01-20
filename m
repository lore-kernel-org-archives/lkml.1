Return-Path: <linux-kernel-owner+w=401wt.eu-S1761641AbZATUkY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761641AbZATUkY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2009 15:40:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753359AbZATUkK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Jan 2009 15:40:10 -0500
Received: from mail-bw0-f21.google.com ([209.85.218.21]:52172 "EHLO
	mail-bw0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752767AbZATUkJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2009 15:40:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type:content-transfer-encoding;
        b=w2ZF7P2tBAK3MGb4tmbLjoBNRfz75/x0g4TPbNyZdxSzKQG1mBCp5o0M7UjZ8CH04g
         3qAquY1On7Hpniqa4j1fj68teilZzPIFJknIsI1hMHZ9G5W+z1kJ5Pry2TtS4SJZeNIw
         y8ejL6wC7dwZd75Un8S/RDH1A0W/9v36rcAqE=
MIME-Version: 1.0
In-Reply-To: <20090120004830.GA12965@linux-sh.org>
References: <8b67d60901181626l43a8728fh6f2a2ab146b45d90@mail.gmail.com>
	 <8b67d60901191433u51d062bgffa523c7da811cb8@mail.gmail.com>
	 <20090120004830.GA12965@linux-sh.org>
Date: Tue, 20 Jan 2009 20:40:06 +0000
Message-ID: <8b67d60901201240u37341a72oa33159a28f4db674@mail.gmail.com>
Subject: Re: Bug: Latest (rc2 and beyond) kernel fails on Dreamcast
From: Adrian McMenamin <lkmladrian@gmail.com>
To: Paul Mundt <lethal@linux-sh.org>, Adrian McMenamin <lkmladrian@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>,
       linux-sh <linux-sh@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/1/20 Paul Mundt <lethal@linux-sh.org>:
> On Mon, Jan 19, 2009 at 10:33:57PM +0000, Adrian McMenamin wrote:
>> 2009/1/19 Adrian McMenamin <lkmladrian@gmail.com>:
>> > I haven't had time to look at this, but the most up to date kernel
>> > (and the one of around a week ago also) fails to boot, seemingly
>> > seeking an IP address for the 8139too based NIC.
>>
>> > [    4.664236] Sending DHCP requests .<3>eth0: PCI Bus error 2200.
>> > [    4.669582] eth0: PCI Bus error 2200.
>>
>> And the bisection reveals the following:
>>
>> adrian@bossclass:~/linux-2.6$ git bisect bad
>> 58c6d3dfe436eb8cfb451981d8fdc9044eaf42da is first bad commit
>> commit 58c6d3dfe436eb8cfb451981d8fdc9044eaf42da
>> Author: Johannes Weiner <hannes@cmpxchg.org>
>> Date:   Tue Jan 6 14:43:10 2009 -0800
>>
>>     dma-coherent: catch oversized requests to dma_alloc_from_coherent()
>>



>
> The dreamcast uses a 32kB coherent area for PCI DMA, which all of the
> 8139too allocations should fit under just fine. What does
> dma_alloc_from_coherent() say the requested size is, vs the per-device
> memory size for each allocation?
>

Hmmm...

>From printks I stuck in the code

[    3.641267] Size is 0x1800, mem->size is 0x8
[    3.644996] Size is 0x2810, mem->size is 0x8

The sizes are correct - the first is the TX buffer, the second RX, but
I have no idea why mem->size is set so low, I assume that is a bug
somewhere else in the Dreamcast code. Any clues gratefully received.
