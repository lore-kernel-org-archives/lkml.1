Return-Path: <linux-kernel-owner+w=401wt.eu-S1752883AbZA1R36@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752883AbZA1R36 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 12:29:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751283AbZA1R3u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 12:29:50 -0500
Received: from terminus.zytor.com ([198.137.202.10]:40630 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751212AbZA1R3t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 12:29:49 -0500
Message-ID: <498095F2.4060502@zytor.com>
Date: Wed, 28 Jan 2009 09:29:22 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Kyle Moffett <kyle@moffetthome.net>
CC: Duncan Sands <baldrick@free.fr>, llvmdev@cs.uiuc.edu,
       Ingo Molnar <mingo@elte.hu>,
       =?UTF-8?B?VMO2csO2ayBFZHdpbg==?= <edwintorok@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [LLVMdev] inline asm semantics: output constraint width smaller
 	than input
References: <497A0500.3080706@gmail.com> <497B408C.20802@gmail.com>	 <20090124172758.GA31699@elte.hu> <200901272042.57272.baldrick@free.fr>	 <497F7BBE.4070500@zytor.com>	 <f73f7ab80901271745o4e426baew8a1f67dbacbe1aef@mail.gmail.com>	 <497FBB30.3020804@zytor.com> <f73f7ab80901280528m6a4f123axbaff9ec284bebe32@mail.gmail.com>
In-Reply-To: <f73f7ab80901280528m6a4f123axbaff9ec284bebe32@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kyle Moffett wrote:
> 
> Even in the 64-bit-integer on 32-bit-CPU case, you still end up with
> the lower 32-bits in a standard integer GPR, and it's trivial to just
> ignore the "upper" register.  You also would not need to do any kind
> of bit-shift, so long as your inline assembly initializes both GPRs
> and puts the halves of the result where they belong.
> 

In this case, we're talking about what happens when the assembly takes a
64-bit input operand in the same register as a 32-bit output operand
(with a "0" constraint.)  Is the output operand the same register number
as the high register or the low register?  On an LE machine the answer
is trivial and obvious -- the low register; on a BE machine both
interpretations are possible (I actually suspect gcc will assign the
high register, just based on how gcc internals work in this case.)

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

