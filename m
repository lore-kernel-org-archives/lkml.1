Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752862Ab0BUFx3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Feb 2010 00:53:29 -0500
Received: from terminus.zytor.com ([198.137.202.10]:46309 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751514Ab0BUFx2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Feb 2010 00:53:28 -0500
Message-ID: <4B80CA55.3040402@zytor.com>
Date: Sat, 20 Feb 2010 21:53:25 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc12 Thunderbird/3.0.1
MIME-Version: 1.0
To: Graeme Russ <graeme.russ@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: x86 embedded - Problem getting past 'move compressed kernel before
 decompression'
References: <4B80946D.1030503@gmail.com> <4B80C892.9000303@zytor.com>
In-Reply-To: <4B80C892.9000303@zytor.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/20/2010 09:45 PM, H. Peter Anvin wrote:
> 
> Instead, do something like:
> 
> 	asm volatile(
>  		"movl	%0, %%ds\n" \
>  		"movl	%0, %%es\n" \
>  		"movl	%0, %%fs\n" \
>  		"movl	%0, %%gs\n" \
> 		"movl	%0, %%ss\n" \
> 		"xorl	%ebp, %ebp\n" \
> 		"xorl	%ebx, %ebx\n" \
>  		"movl   $0x100000, %%eax\n" \
>  		"ljmpl	$0x10,$0x100000"
> 	 : : "S" (&boot_params), "D" (0), "c" (0x18));
> 
> 	-hpa
> 

Make that:

 	asm volatile(
  		"movl	%2, %%ds\n" \
  		"movl	%2, %%es\n" \
  		"movl	%2, %%fs\n" \
  		"movl	%2, %%gs\n" \
 		"movl	%2, %%ss\n" \
 		"xorl	%ebp, %ebp\n" \
 		"xorl	%ebx, %ebx\n" \
  		"ljmpl	$0x10,$0x100000"
 	 : : "S" (&boot_params), "D" (0), "r" (0x18));

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

