Return-Path: <linux-kernel-owner+w=401wt.eu-S1755533AbYB0Qp2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755533AbYB0Qp2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2008 11:45:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753150AbYB0QpR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Feb 2008 11:45:17 -0500
Received: from terminus.zytor.com ([198.137.202.10]:59143 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753796AbYB0QpQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2008 11:45:16 -0500
Message-ID: <47C59378.6020608@zytor.com>
Date: Wed, 27 Feb 2008 08:44:40 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Andi Kleen <ak@suse.de>
CC: Ingo Molnar <mingo@elte.hu>, Alexander van Heukelum <heukelum@fastmail.fm>,
       Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>,
       Alexander van Heukelum <heukelum@mailshack.com>
Subject: Re: [PATCH] reserve_early end-of-conventional-memory to 1MB II -
 some numbers to put it into perspective
References: <20080224174605.GA21661@mailshack.com> <47C22568.1010405@zytor.com> <1203958478.20033.1239002461@webmail.messagingengine.com> <20080225170134.GA15839@elte.hu> <20080225180750.GA31054@mailshack.com> <47C3053D.5060504@zytor.com> <1203968796.24935.1239027765@webmail.messagingengine.com> <20080226093046.GK9857@elte.hu> <47C575E4.7050206@suse.de>
In-Reply-To: <47C575E4.7050206@suse.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
> 
> Just to give some perspective of this:
> 
> On my laptop here
> 
>  BIOS-e820: 000000000009dc00 - 00000000000a0000 (reserved)
>  BIOS-e820: 00000000000d2000 - 0000000000100000 (reserved)
> 
> This means it reserves only ~193KB in the 640k-1MB area
> 
> With this patch it will reserve 384KB instead. This means 191KB
> are lost. While that doesn't sound too much it worth as much as
> 382 patches that reduce kernel code size by 512bytes or
> worth 3820 patches that reduce kernel code by 100 bytes in terms
> of memory consumption.
> 
> Now such kernel code size patches are always popular, but why undo that
> work by throwing away perfectly good memory elsewhere?
> 
> Or also the laptop kernel does
> 
> Freeing unused kernel memory: 340k freed
> 
> This means the 193KB now lost are worth 56% of the complete
> memory that is freed by __initdata/__init. Just maintaining
> these annotations is a lot of work, but why do all that if we
> then throw away than half as much memory as they save so easily?
> 

It doesn't waste any memory at all.

It arguably wastes some *address space*, but that's an entirely 
different thing.

Unless you have chipset-specific drivers to enable memory in the 
640-1024K memory area, there is nothing there.

	-hpa
