Return-Path: <linux-kernel-owner+w=401wt.eu-S1763460AbYCCVlX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763460AbYCCVlX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 16:41:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755681AbYCCVlN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 16:41:13 -0500
Received: from wa-out-1112.google.com ([209.85.146.180]:36186 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754296AbYCCVlM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 16:41:12 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=s4U/7TYwhFdb8B5eqSgo6lmAVbiuD2btEP7+8Mm1fPH5vqTwtzp8WIjrEv4kwWpWsnX8+s8DpDdAxbKhYzJwn/G58fccEUl3pXqd+ajaYDB3Repue7NvQdA/xLUJyDcrnlQeLD4G8Gyj+Yb1kHttFg7mHk07dhGAS2CoF9ivPBM=
Subject: Re: sparc vs. gcc 4.3
From: Harvey Harrison <harvey.harrison@gmail.com>
To: David Miller <davem@davemloft.net>
Cc: bunk@kernel.org, wli@holomorphy.com, sparclinux@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <20080303.130348.25289482.davem@davemloft.net>
References: <20080303192651.GL26072@cs181133002.pp.htv.fi>
	 <20080303.130348.25289482.davem@davemloft.net>
Content-Type: text/plain
Date: Mon, 03 Mar 2008 13:41:11 -0800
Message-Id: <1204580471.22933.17.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-03-03 at 13:03 -0800, David Miller wrote:
> From: Adrian Bunk <bunk@kernel.org>
> Date: Mon, 3 Mar 2008 21:26:51 +0200
> 
> >   LD      arch/sparc/boot/image
> > arch/sparc/kernel/built-in.o:(__ex_table+0x394): undefined reference to `kernel_unaligned_trap_fault'
> ...
> > arch/sparc/kernel/built-in.o:(__ex_table+0x46c): undefined reference to `user_unaligned_trap_fault'
> 
> > Does anyone have a clue what's going wrong here?
> 
> We hit the same problem a while back on sparc64 too.
> 
> GCC can't see how the inline asm is reachable so eliminates it
> entirely.  We hide the label inside the inline asm string and call it
> from exception handlers.
> 
> The way we fixed this on sparc64 was quite invasive (patch below for
> reference), so I'll try to come up with something simpler.

Could you hide the asm inside an actual function and annotate the
function with __used?

Similar to how the kprobes has a function called kretprobe_trampoline_holder
for their trampoline asm?

arch/x86/kernel/kprobes.c line 584

Cheers,

Harvey


