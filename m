Return-Path: <linux-kernel-owner+w=401wt.eu-S1751875AbZA1T1d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751875AbZA1T1d (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 14:27:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751433AbZA1T1Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 14:27:24 -0500
Received: from rn-out-0910.google.com ([64.233.170.187]:7723 "EHLO
	rn-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751348AbZA1T1X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 14:27:23 -0500
MIME-Version: 1.0
In-Reply-To: <498095F2.4060502@zytor.com>
References: <497A0500.3080706@gmail.com> <497B408C.20802@gmail.com>
	 <20090124172758.GA31699@elte.hu> <200901272042.57272.baldrick@free.fr>
	 <497F7BBE.4070500@zytor.com>
	 <f73f7ab80901271745o4e426baew8a1f67dbacbe1aef@mail.gmail.com>
	 <497FBB30.3020804@zytor.com>
	 <f73f7ab80901280528m6a4f123axbaff9ec284bebe32@mail.gmail.com>
	 <498095F2.4060502@zytor.com>
Date: Wed, 28 Jan 2009 14:27:22 -0500
Message-ID: <f73f7ab80901281127t191c9c97nba99d859224e14bd@mail.gmail.com>
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

On Wed, Jan 28, 2009 at 12:29 PM, H. Peter Anvin <hpa@zytor.com> wrote:
> Kyle Moffett wrote:
>> Even in the 64-bit-integer on 32-bit-CPU case, you still end up with
>> the lower 32-bits in a standard integer GPR, and it's trivial to just
>> ignore the "upper" register.  You also would not need to do any kind
>> of bit-shift, so long as your inline assembly initializes both GPRs
>> and puts the halves of the result where they belong.
>
> In this case, we're talking about what happens when the assembly takes a
> 64-bit input operand in the same register as a 32-bit output operand
> (with a "0" constraint.)  Is the output operand the same register number
> as the high register or the low register?  On an LE machine the answer
> is trivial and obvious -- the low register; on a BE machine both
> interpretations are possible (I actually suspect gcc will assign the
> high register, just based on how gcc internals work in this case.)

On a BE 32-bit machine, the "output register" technically ought to be
"64-bit" anyways, since it's constrained to be the same as the 64-bit
"input register".  That means that you ought to make sure to set
*both* output registers appropriately, one of them being 0 and the
other being the 32-bit number.  I think that's the only answer that
actually makes any sense from a holistic code-generation sense.  So it
seems we are in violent agreement :-D.

Cheers,
Kyle Moffett
