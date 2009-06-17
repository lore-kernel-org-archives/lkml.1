Return-Path: <linux-kernel-owner+w=401wt.eu-S1759950AbZFQBDj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759950AbZFQBDj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 21:03:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751403AbZFQBDc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 21:03:32 -0400
Received: from mail-gx0-f214.google.com ([209.85.217.214]:62757 "EHLO
	mail-gx0-f214.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751206AbZFQBDb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 21:03:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=OvS2TQsL5eEO+2QNF7eIzMzfrTTT2ODPm7blS8JXFtx19H4Dn0VxcwqQYlZnQE40iv
         NDD1THFRfYMLdojNNDBYJqr7F0L98j5Dqx7obaQmBT0gMB1KrR/SizCWEJ6fi/P0yslW
         0gTxUyE1kl/PX2+CHo3lJH1z8HNP+90GIvQJQ=
MIME-Version: 1.0
In-Reply-To: <20090617093654B.fujita.tomonori@lab.ntt.co.jp>
References: <4A37DB0F.7060801@freescale.com> <200906162002.12376.arnd@arndb.de>
	 <1245197925.21602.0.camel@pasglop>
	 <20090617093654B.fujita.tomonori@lab.ntt.co.jp>
Date: Wed, 17 Jun 2009 02:56:17 +0200
Message-ID: <c384c5ea0906161756j4b701abfj2a8908b9c93ddd04@mail.gmail.com>
Subject: Re: PowerPC PCI DMA issues (prefetch/coherency?)
From: Leon Woestenberg <leon.woestenberg@gmail.com>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: benh@kernel.crashing.org, arnd@arndb.de, scottwood@freescale.com,
       chris.pringle@oxtel.com, linuxppc-dev@lists.ozlabs.org,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello all,

On Wed, Jun 17, 2009 at 2:37 AM, FUJITA
Tomonori<fujita.tomonori@lab.ntt.co.jp> wrote:
> On Wed, 17 Jun 2009 10:18:45 +1000
> Benjamin Herrenschmidt <benh@kernel.crashing.org> wrote:
>
>> On Tue, 2009-06-16 at 20:02 +0200, Arnd Bergmann wrote:
>> > On Tuesday 16 June 2009, Scott Wood wrote:
>> > > > If the
>> > > > device is the only one, you can also use dma_alloc_noncoherent() and
>> > > > flush explicitly with dma_cache_sync().
>> > >
>> > > I don't see how that would help -- aren't those also controlled by
>> > > CONFIG_NOT_COHERENT_CACHE?
>> >
>> > Ah, yes you are right. PowerPC implements dma_alloc_noncoherent as
>> > dma_alloc_coherent, so dma_cache_sync() is actually a NOP (or should be).
>>
>> But we still need to sync the result of dma_map_* when used multiple
>> times for a single mapping.
>
> We have dma_sync_{single|sg}_for_{cpu|device} API for the above
> purpose.
>
> dma_cache_sync is supposed to be used only with the buffers that
> dma_alloc_noncoherent() returns. On architecutures that maps
> dma_alloc_noncoherent to dma_alloc_coherent, dma_cache_sync() is
> supposed to be NOP.

This discussion raised some doubt with me about my use case:

I my case (note I am not the poster) I am using (what LDD3 calls)
streaming mappings:

I use pci_map_sg(), have the device perform either DMA master reads or
writes to the bus address using PCIe.
After that, I use pci_unmap_sg().

My assumption is that pci_unmap_sg() either makes the cache coherent
or invalidated and thus I do not need to take further actions.
This is on a MPC83xx or 85xx system.

Is this assumption correct?

Regards,

Leon/

-- 
Leon
