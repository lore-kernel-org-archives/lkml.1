Return-Path: <linux-kernel-owner+w=401wt.eu-S934274AbYAaSyq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934274AbYAaSyq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2008 13:54:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757021AbYAaSyf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jan 2008 13:54:35 -0500
Received: from sca-es-mail-1.Sun.COM ([192.18.43.132]:42796 "EHLO
	sca-es-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759409AbYAaSye (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2008 13:54:34 -0500
Date: Thu, 31 Jan 2008 11:12:05 -0800
From: Yinghai Lu <Yinghai.Lu@Sun.COM>
Subject: Re: PATCH] x86_64: fix comments in vmlinux_64.lds
In-reply-to: <20080131123503.GG12571@elte.hu>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org
Message-id: <200801311112.05409.yinghai.lu@sun.com>
Organization: SUN
MIME-version: 1.0
Content-type: text/plain; charset=iso-8859-1
Content-transfer-encoding: 7BIT
Content-disposition: inline
References: <200801302348.37990.yinghai.lu@sun.com>
 <20080131123503.GG12571@elte.hu>
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 31 January 2008 04:35:03 am Ingo Molnar wrote:
> 
> * Yinghai Lu <Yinghai.Lu@Sun.COM> wrote:
> 
> >  ENTRY(startup_64)
> >  SECTIONS
> >  {
> > -	/* Be careful parts of head_64.S assume startup_64 is at
> > +	/* Be careful parts of head_64.S assume startup_32 is at
> >  	 * address 0.
> >  	 */
> >  	. = 0;
> 
> but this linker script rule is about startup_64, not about startup_32.
> 
> startup_32 does exist on 64-bit too (and is 32-bit code), but it's 
> linked to a different address that is not 0:
> 
>  ffffffff806c23c0 r startup_32
> 
> startup_64 is at offset 0:
> 
>  ffffffff80200000 T startup_64
> 
> So your patch looks wrong to me.

there are several startup_32 in 64 bit
1. one is for bzImage, it is arch/x86/boot/compressed/head_64.S, and it said startup_64 will at 0x200. that what i mean
2. one is vmlinux in linux-2.6/ , it is in arch/x86/kernel/trampoline_64.S  it is for AP trampoline and wake up. that is what you mean

actually there was another one in arch/x86_64/kernel/head_64.S, and it was removed when Eric made linux-2.6/vmlinux to be 64bit elf. 

So that patch is needed.

YH

