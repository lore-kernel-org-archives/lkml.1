Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753115Ab0CIHp5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Mar 2010 02:45:57 -0500
Received: from mail-px0-f188.google.com ([209.85.216.188]:63741 "EHLO
	mail-px0-f188.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752108Ab0CIHpz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Mar 2010 02:45:55 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=CFnqDw4GGp+zZNuZFYMHu6fNksk9/MWZLPF0dNr+tLclehf+0C7EyYeoDC1TaGYJuC
         Q6PYQm/ct2DdEjAcPvRAPE6wuo6TNy60DxzTAwiGW7Ak4rXjZ1PgFoPWpuqhsdCQB7Ea
         IHR2oTva2U0hHm5u0d+pa50BzsS1ggKk7LGd8=
MIME-Version: 1.0
In-Reply-To: <20100306193127.GA13262@n2100.arm.linux.org.uk>
References: <201003042211.28569.thomas@koeller.dyndns.org>
	 <20100304213634.GH13417@n2100.arm.linux.org.uk>
	 <201003061407.12698.thomas@koeller.dyndns.org>
	 <20100306193127.GA13262@n2100.arm.linux.org.uk>
Date: Tue, 9 Mar 2010 15:45:54 +0800
Message-ID: <10d816431003082345j5438d8cdi8ad72c4fa296b684@mail.gmail.com>
Subject: Re: DMA using data buffer vmapped in kernel space
From: Lin Mac <mkl0301@gmail.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Thomas Koeller <thomas@koeller.dyndns.org>,
       linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/3/7 Russell King - ARM Linux <linux@arm.linux.org.uk>:
> On Sat, Mar 06, 2010 at 02:07:12PM +0100, Thomas Koeller wrote:
>> Am Donnerstag, 4. März 2010 22:36:34 schrieb Russell King - ARM Linux:
>> > Cache maintainence is done using virtual addresses for L1, and
>> > physical addresses for L2.  There's the need for virtual addresses
>> > to be translatable to physical addresses, which is only true for
>> > the kernel direct mapped region (pages between PAGE_OFFSET and
>> > high_memory).
>>
>> Isn't the mapping created by vmap() sufficient for the virt/phys
>> translation? In which way is this case different from a buffer
>> passed in from user space, where the constituent pages are not
>> in the directly mapped kernel region either?
>
> No different.
>
> The requirement is that dma_map_single() is passed a virtual address
> in the kernel direct-mapped memory region, which is translatable using
> virt_to_phys() and friends.
I had encounter a similiar problem and I simply allocated a new
buffer, copy the data, then DMA. It seems slow and stupid.

I'm wondering wether could I translate the vmap virt to phys(don't
know how to yet), then use phys_to_virt to get the virt in
direct-mapped memory region?

Is there other possible ways?

> Anything which requires a page table lookup to obtain the physical
> address is just not acceptable - that requires taking locks and other
> messy things, plus is grossly inefficient.

Best Regards,
Mac Lin
