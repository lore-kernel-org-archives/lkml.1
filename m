Return-Path: <linux-kernel-owner+w=401wt.eu-S1765558AbYEVBoR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765558AbYEVBoR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2008 21:44:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753812AbYEVBoH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 May 2008 21:44:07 -0400
Received: from yw-out-2324.google.com ([74.125.46.29]:53168 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753150AbYEVBoE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2008 21:44:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=tY+y4OiTjM8Mxv5/3KYUQW6jOgA5kS83Peb2qC5ON8ArZltLGexMgDzWyrWoS23jsJlrr/tEGhu8m1ZVmEj7Tgarg7Hrrtqe5m59ZVd3cMJkbya5x1WNVeRbhaZjyTg5w+d52ISAnMVTSGG3ki2q3KfHuSzT32pGyYW+Fq5bpfo=
Message-ID: <86802c440805211843m51a9b56bjd28a01d008541e9a@mail.gmail.com>
Date: Wed, 21 May 2008 18:43:59 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Jeremy Fitzhardinge" <jeremy@goop.org>
Subject: Re: Suspected regression in "x86: extend e820 ealy_res support 32bit"
Cc: "Ingo Molnar" <mingo@elte.hu>,
       "kernel list" <linux-kernel@vger.kernel.org>,
       "Thomas Gleixner" <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
In-Reply-To: <4834AF0C.2000601@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <483467CD.90401@goop.org>
	 <86802c440805211335q27334ba1g32a43fb1c0498b9b@mail.gmail.com>
	 <48349B9D.1000501@goop.org>
	 <86802c440805211540m4ff68aeh827a1f823305742b@mail.gmail.com>
	 <4834AF0C.2000601@goop.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 21, 2008 at 4:23 PM, Jeremy Fitzhardinge <jeremy@goop.org> wrote:
> Yinghai Lu wrote:
>>
>> noticed that bootmap_size is shifted already...
>>
>> please use attached patch to see if bootmap is right...
>>
>
> Unfortunately its a bit difficult because printk() output isn't appearing at
> early boot (not sure why).  I'll try to extract something useful tomorrow.
>
> Perhaps this is helpful:
>
> This the e820 map of a regular boot:
>
> BIOS-provided physical RAM map:
> Xen: 0000000000000000 - 000000000009f000 (usable)
> Xen: 0000000000100000 - 0000000010000000 (usable)
> debug: ignoring loglevel setting.
> limit_regions start: 0000000000000000 - 000000000009f000 (usable)
> limit_regions start: 0000000000100000 - 0000000010000000 (usable)
> limit_regions endfunc: 0000000000000000 - 000000000009f000 (usable)
> limit_regions endfunc: 0000000000100000 - 0000000010000000 (usable)
> user-defined physical RAM map:
> user: 0000000000000000 - 000000000009f000 (usable)
> user: 0000000000100000 - 0000000010000000 (usable)
> 0MB HIGHMEM available.
> 256MB LOWMEM available.
> [...]
> Entering add_active_range(0, 0, 65536) 0 entries of 256 used
> Zone PFN ranges:
>  DMA             0 ->     4096
>  Normal       4096 ->    65536
>  HighMem     65536 ->    65536
> Movable zone start PFN for each node
> early_node_map[1] active PFN ranges
>   0:        0 ->    65536
> On node 0 totalpages: 65536
>  DMA zone: 56 pages used for memmap
>  DMA zone: 0 pages reserved
>  DMA zone: 4040 pages, LIFO batch:0
>  Normal zone: 840 pages used for memmap
>  Normal zone: 60600 pages, LIFO batch:15
>  HighMem zone: 0 pages used for memmap
>  Movable zone: 0 pages used for memmap
>
>

please check patch

http://lkml.org/lkml/2008/5/21/570

[PATCH] x86: extend e820 ealy_res support 32bit - fix

also please try to boot with
console=uart8250,io,0x3f8,115200n8
to get more early printout...

YH
