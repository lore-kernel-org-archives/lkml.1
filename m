Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755357Ab0BUJL4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Feb 2010 04:11:56 -0500
Received: from snt0-omc2-s23.snt0.hotmail.com ([65.55.90.98]:25323 "EHLO
	snt0-omc2-s23.snt0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755029Ab0BUJLs convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Feb 2010 04:11:48 -0500
Message-ID: <SNT125-W31E79E8A4EFC5D0853207C3440@phx.gbl>
X-Originating-IP: [96.253.143.208]
From: Yuhong Bao <yuhongbao_386@hotmail.com>
To: <hpa@zytor.com>, <graeme.russ@gmail.com>
CC: <linux-kernel@vger.kernel.org>
Subject: RE: x86 embedded - Problem getting past 'move compressed kernel
 before decompression'
Date: Sun, 21 Feb 2010 01:11:47 -0800
Importance: Normal
In-Reply-To: <4B80CA55.3040402@zytor.com>
References: <4B80946D.1030503@gmail.com>
 <4B80C892.9000303@zytor.com>,<4B80CA55.3040402@zytor.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
X-OriginalArrivalTime: 21 Feb 2010 09:11:47.0103 (UTC) FILETIME=[E4DE42F0:01CAB2D5]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> Make that:
>
> asm volatile(
> "movl %2, %%ds\n" \
> "movl %2, %%es\n" \
> "movl %2, %%fs\n" \
> "movl %2, %%gs\n" \
> "movl %2, %%ss\n" \
> "xorl %ebp, %ebp\n" \
> "xorl %ebx, %ebx\n" \
> "ljmpl $0x10,$0x100000"
> : : "S" (&boot_params), "D" (0), "r" (0x18));
Or if you don't want a far jmp, something like this for non-PIC:

asm volatile(

"movl %4, %%ds\n" \

"movl %4, %%es\n" \

"movl %4, %%fs\n" \

"movl %4, %%gs\n" \

"movl %4, %%ss\n" \

"xorl %ebp, %ebp\n" \

"jmpl *%3"

: : "S" (&boot_params), "D" (0), "b" (0), "r" (0x100000), "r" (0x18));

This for PIC:


asm volatile(


"movl %3, %%ds\n" \


"movl %3, %%es\n" \


"movl %3, %%fs\n" \


"movl %3, %%gs\n" \


"movl %3, %%ss\n" \


"xorl %ebp, %ebp\n" \
"xorl %ebx, %ebx\n" \


"jmpl *%2"


: : "S" (&boot_params), "D" (0), "r" (0x100000), "r" (0x18));


Yuhong Bao 		 	   		  
_________________________________________________________________
Your E-mail and More On-the-Go. Get Windows Live Hotmail Free.
http://clk.atdmt.com/GBL/go/201469229/direct/01/