Return-Path: <linux-kernel-owner+w=401wt.eu-S1754635AbZA1N25@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754635AbZA1N25 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 08:28:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752491AbZA1N2f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 08:28:35 -0500
Received: from rv-out-0506.google.com ([209.85.198.228]:1152 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752194AbZA1N2e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 08:28:34 -0500
MIME-Version: 1.0
In-Reply-To: <497FBB30.3020804@zytor.com>
References: <497A0500.3080706@gmail.com> <497B408C.20802@gmail.com>
	 <20090124172758.GA31699@elte.hu> <200901272042.57272.baldrick@free.fr>
	 <497F7BBE.4070500@zytor.com>
	 <f73f7ab80901271745o4e426baew8a1f67dbacbe1aef@mail.gmail.com>
	 <497FBB30.3020804@zytor.com>
Date: Wed, 28 Jan 2009 08:28:33 -0500
Message-ID: <f73f7ab80901280528m6a4f123axbaff9ec284bebe32@mail.gmail.com>
Subject: Re: [LLVMdev] inline asm semantics: output constraint width smaller 
	than input
From: Kyle Moffett <kyle@moffetthome.net>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Duncan Sands <baldrick@free.fr>, llvmdev@cs.uiuc.edu,
       Ingo Molnar <mingo@elte.hu>,
       =?UTF-8?B?VMO2csO2ayBFZHdpbg==?= <edwintorok@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 27, 2009 at 8:56 PM, H. Peter Anvin <hpa@zytor.com> wrote:
> Kyle Moffett wrote:
>> Actually, PPC64 boxes basically don't care... the usable GPRs are all
>> either 32-bit (for PPC32) or 64-bit (for PPC64), the <=32-bit
>> instructions are identical across both, they just
>> truncate/sign-extend/etc based on the lower 32-bits of the register.
>> Also, you would only do a right-shift if you were going all the way
>> out to memory as 64-bit and all the way back in as 32-bit... within a
>> single register it's kept coherent.
>
> Think about a 64-bit integer on ppc32.  It will by necessity kept in two
> registers.  On gcc I believe it will always be a consecutive pair of
> registers (AFAIK that's a hard-coded assumption in gcc, with the result that
> gcc has a nonstandard internal register numbering for x86 since the commonly
> used dx:ax pair is actually registers 2:0 in the hardware numbering.)

Even in the 64-bit-integer on 32-bit-CPU case, you still end up with
the lower 32-bits in a standard integer GPR, and it's trivial to just
ignore the "upper" register.  You also would not need to do any kind
of bit-shift, so long as your inline assembly initializes both GPRs
and puts the halves of the result where they belong.

Cheers,
Kyle Moffett
