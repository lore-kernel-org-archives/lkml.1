Return-Path: <linux-kernel-owner+w=401wt.eu-S932480AbZICW60@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932480AbZICW60 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Sep 2009 18:58:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932448AbZICW6Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Sep 2009 18:58:25 -0400
Received: from terminus.zytor.com ([198.137.202.10]:34699 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932429AbZICW6Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Sep 2009 18:58:24 -0400
Message-ID: <4AA049F2.5000403@zytor.com>
Date: Thu, 03 Sep 2009 15:57:54 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Thunderbird/3.0b3
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Borislav Petkov <petkovbb@googlemail.com>, mingo@redhat.com,
       linux-kernel@vger.kernel.org, kjwinchester@gmail.com,
       tglx@linutronix.de, borislav.petkov@amd.com,
       linux-tip-commits@vger.kernel.org
Subject: Re: [PATCH 1/3] x86, msr: add rd/wrmsr interfaces with preset registers
References: <20090831073429.GA26596@liondog.tnic>	<1251705011-18636-1-git-send-email-petkovbb@gmail.com> <20090903155539.ecd64bcd.akpm@linux-foundation.org>
In-Reply-To: <20090903155539.ecd64bcd.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/03/2009 03:55 PM, Andrew Morton wrote:
> On Mon, 31 Aug 2009 09:50:09 +0200
> Borislav Petkov <petkovbb@googlemail.com> wrote:
> 
>> +.macro op_safe_regs op:req
> 
> Using
> 
> GNU assembler 2.16.1
> 
> I get
> 
> arch/x86/lib/msr-reg.S: Assembler messages:
> arch/x86/lib/msr-reg.S:53: Error: Bad macro parameter list
> arch/x86/lib/msr-reg.S:100: Error: invalid character '_' in mnemonic
> arch/x86/lib/msr-reg.S:101: Error: invalid character '_' in mnemonic
> 
> this:
> 
> diff -puN arch/x86/lib/msr-reg.S~a arch/x86/lib/msr-reg.S
> --- a/arch/x86/lib/msr-reg.S~a
> +++ a/arch/x86/lib/msr-reg.S
> @@ -50,7 +50,7 @@ ENDPROC(native_\op\()_safe_regs)
>  
>  #else /* X86_32 */
>  
> -.macro op_safe_regs op:req
> +.macro op_safe_regs op
>  ENTRY(native_\op\()_safe_regs)
>         CFI_STARTPROC
>         pushl_cfi %ebx
> 
> 
> fixed it.

Yup, already fixed in -tip.

	-hpa
