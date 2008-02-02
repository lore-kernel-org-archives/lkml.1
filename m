Return-Path: <linux-kernel-owner+w=401wt.eu-S1764932AbYBBWZq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764932AbYBBWZq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Feb 2008 17:25:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762727AbYBBWZj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Feb 2008 17:25:39 -0500
Received: from terminus.zytor.com ([198.137.202.10]:50737 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762650AbYBBWZi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Feb 2008 17:25:38 -0500
Message-ID: <47A4EDC5.3050104@zytor.com>
Date: Sat, 02 Feb 2008 14:25:09 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Cyrill Gorcunov <gorcunov@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>, Andi Kleen <ak@suse.de>,
       LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [RFC] x86: setup code_bytes - use mask to restrict it's size
References: <20080202221211.GA6749@cvg>
In-Reply-To: <20080202221211.GA6749@cvg>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cyrill Gorcunov wrote:
> This patch strips off 8 bytes from text section. Not a really
> big advantage (especially for __init section). It seems 8192
> bytes of disassembled code is rare used anyway.
> 
> before:
> 	text    data     bss     dec     hex filename
> 	9900     176      20   10096    2770 arch/x86/kernel/traps_64.o.old
> after:
> 	text    data     bss     dec     hex filename
> 	9892     176      20   10088    2768 arch/x86/kernel/traps_64.o
> 
> Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
> ---
> 
> If there is no benefit at all - just drop the patch.
> Any comments are welcome ;)

I don't think this is the behaviour we want (wrapping around); worse, if 
people enter a larger power of two they will get zero.

So NAK on this patch, IMO.

	-hpa
