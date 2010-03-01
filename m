Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752125Ab0CAVMp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Mar 2010 16:12:45 -0500
Received: from mail-iw0-f196.google.com ([209.85.223.196]:65146 "EHLO
	mail-iw0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751118Ab0CAVMn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Mar 2010 16:12:43 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=vWKKqH0wvdBUN2XZDtvO6APC9SkBLZRZ4sAOjzCcA1l6Pr2HjKPn0Wr61rKOQ9pYVB
         N7JXprC6Cu87dUDIo5iF/117AV5GjrdJV8Z1k3UJ7Crc6UVhgq4IrbZPa4sv3NZyTe63
         cpFpAPd+qagMZ6NMBTE36Rm9p8Jcs9QNlMJvE=
MIME-Version: 1.0
In-Reply-To: <20100301163437.GE7881@phenom.dumpdata.com>
References: <20100227.040502.182574085.davem@davemloft.net>
	 <51f3faa71002271015i7c9ec45j18381b1269bfd799@mail.gmail.com>
	 <20100228033706G.fujita.tomonori@lab.ntt.co.jp>
	 <20100228.001628.48507956.davem@davemloft.net>
	 <20100301163437.GE7881@phenom.dumpdata.com>
Date: Mon, 1 Mar 2010 15:12:41 -0600
Message-ID: <51f3faa71003011312n3e7f8151x1a5e4b8bb57bb7c0@mail.gmail.com>
Subject: Re: Was: Re: [RFC PATCH] fix problems with NETIF_F_HIGHDMA in 
	networking, Now: SWIOTLB dynamic allocation
From: Robert Hancock <hancockrwd@gmail.com>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: David Miller <davem@davemloft.net>, fujita.tomonori@lab.ntt.co.jp,
       bzolnier@gmail.com, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, linux-usb@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 1, 2010 at 10:34 AM, Konrad Rzeszutek Wilk
<konrad.wilk@oracle.com> wrote:
> On Sun, Feb 28, 2010 at 12:16:28AM -0800, David Miller wrote:
>> From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
>> Date: Sun, 28 Feb 2010 03:38:19 +0900
>>
>> > When I proposed such approach (always use swiotlb) before, IIRC,
>> > the objections were:
>> >
>> > - better to make allocation respect dma_mask. (I don't think that this
>> >   approach is possible since we don't know which device handles data
>> >   later when we allocate memory).
>>
>> And such objects might end up being processed by multiple devices with
>> different DMA restrictions.
>>
>> > - swiotlb is not good for small systems since it allocates too much
>> >   memory (we can fix this though).
>>
>> Indeed.
>
> What would be a good mechanism for this? Enumerating all of the PCI
> devices to find out which ones are 32-bit and then allocate some chunk
> of memory based on the amount of them? say, 1MB per card?
>
> Or maybe a simpler one - figure out how many pages we have an allocate
> based on some sliding rule (say, 8MB for under 512MB, 16MB between 512MB
> and 2GB, and 32MB for 2GB to 4GB, and after that the full 64MB?)

Why do we need to allocate SWIOTLB if your highest memory address is
under 4GB? You can just disable it in that case, like x86_64 does.
