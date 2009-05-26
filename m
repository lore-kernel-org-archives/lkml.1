Return-Path: <linux-kernel-owner+w=401wt.eu-S1756782AbZEZRNd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756782AbZEZRNd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 13:13:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755195AbZEZRN0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 13:13:26 -0400
Received: from terminus.zytor.com ([198.137.202.10]:45851 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755107AbZEZRN0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 13:13:26 -0400
Message-ID: <4A1C2320.1030704@zytor.com>
Date: Tue, 26 May 2009 10:13:04 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: lkml@morethan.org
CC: Harald Welte <HaraldWelte@viatech.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [BUG FIX] Make x86_32 uni-processor Atomic ops, Atomic
References: <200905221139.26941.lkml@morethan.org> <200905251803.51478.lkml@morethan.org> <4A1B3241.3080509@zytor.com> <200905260737.32860.lkml@morethan.org>
In-Reply-To: <200905260737.32860.lkml@morethan.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michael S. Zick wrote:
> 
> Disassembly of section .text:
> 
> 00000000 <diff_umask>:
>    0:   8b 44 24 0c             mov    0xc(%esp),%eax
>    4:   8b 4c 24 04             mov    0x4(%esp),%ecx
>    8:   8b 10                   mov    (%eax),%edx
>    a:   8d 04 11                lea    (%ecx,%edx,1),%eax
>    d:   8b 54 24 08             mov    0x8(%esp),%edx
>   11:   2b 02                   sub    (%edx),%eax
>   13:   21 c8                   and    %ecx,%eax
>   15:   c3                      ret
> 
> = = = =
> 
> Checking the byte string 0x8d, 0x04, 0x11 against the Intel
> documentation shows that the disassembly output of objdump
> is incorrect - that bit string does not have an offset field.
> That is the byte encoding for the gcc assembly input.
> 
> What's a person to do when the tool-chain lies?
> 

The ,1 isn't an offset field... it's a scale factor.

	-hpa

