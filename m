Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754134Ab0BBPyn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Feb 2010 10:54:43 -0500
Received: from www.tglx.de ([62.245.132.106]:41793 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753591Ab0BBPyk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Feb 2010 10:54:40 -0500
Message-ID: <4B684AAE.9020609@linutronix.de>
Date: Tue, 02 Feb 2010 16:54:22 +0100
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
User-Agent: Mozilla-Thunderbird 2.0.0.22 (X11/20090707)
MIME-Version: 1.0
To: Ming Lei <tom.leiming@gmail.com>
CC: Catalin Marinas <catalin.marinas@arm.com>, linux-usb@vger.kernel.org,
       linux-kernel@vger.kernel.org, Greg KH <greg@kroah.com>,
       Matthew Dharm <mdharm-kernel@one-eyed-alien.net>
Subject: Re: [PATCH] isp1760: Flush the D-cache for the pipe-in transfer 
 buffers
References: <20100202111135.18636.62688.stgit@pc1117.cambridge.arm.com> <d82e647a1002020741n4a048395o6ebf7ffaf8457819@mail.gmail.com>
In-Reply-To: <d82e647a1002020741n4a048395o6ebf7ffaf8457819@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ming Lei wrote:
> 2010/2/2 Catalin Marinas <catalin.marinas@arm.com>:
> 
>> +       if (usb_pipein(urb->pipe) && usb_pipetype(urb->pipe) == PIPE_BULK) {
>> +               void *ptr;
>> +               for (ptr = urb->transfer_buffer;
>> +                    ptr < urb->transfer_buffer + urb->transfer_buffer_length;
>> +                    ptr += PAGE_SIZE)
>> +                       flush_dcache_page(virt_to_page(ptr));
> 
> If the page is mapped into highmem, seems virt_to_page doesn't work well.

This does not matter because this can not happen :). If the buffer is
highmem then a bounce buffer is used. See commit 96983d2d8 aka "USB:
storage: set bounce limit for non-DMA-capable host controllers"


Sebastian
