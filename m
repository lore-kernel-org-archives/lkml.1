Return-Path: <linux-kernel-owner+w=401wt.eu-S1754134AbYL0LD6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754134AbYL0LD6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Dec 2008 06:03:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751538AbYL0LDu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Dec 2008 06:03:50 -0500
Received: from gw.goop.org ([64.81.55.164]:55856 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751500AbYL0LDt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Dec 2008 06:03:49 -0500
Message-ID: <49560B87.8090407@goop.org>
Date: Sat, 27 Dec 2008 22:03:35 +1100
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.18 (X11/20081119)
MIME-Version: 1.0
To: Brian Gerst <brgerst@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] x86-64: Unify x86_*_percpu() functions.
References: <1230052506-5041-1-git-send-email-brgerst@gmail.com> <1230052506-5041-2-git-send-email-brgerst@gmail.com>
In-Reply-To: <1230052506-5041-2-git-send-email-brgerst@gmail.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Brian Gerst wrote:
> Merge the 32-bit and 64-bit versions of these functions.  Unlike 32-bit,
> the segment base is the current cpu's PDA instead of the offset from the
> original per-cpu area.  This is because GCC hardcodes the stackprotector
> canary at %gs:40.  Since the assembler is incapable of relocating against
> multiple symbols, the code ends up looking like:
>
> 	movq $per_cpu__var, reg
> 	subq $per_cpu__pda, reg
> 	movq %gs:(reg), reg
>
> This is still atomic since the offset is a constant (just calculated at
> runtime) and not dependant on the cpu number.
>   

Yeah, it's a real pity we can't convince the linker to do this simple 
computation as a single %gs:ADDR addressing mode.  On the other hand, if 
the compiler can reuse the computation of %reg 2-3 times, then the 
generated code could well end up being denser.

    J
