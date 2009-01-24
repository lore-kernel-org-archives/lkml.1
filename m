Return-Path: <linux-kernel-owner+w=401wt.eu-S1757448AbZAXUHV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757448AbZAXUHV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Jan 2009 15:07:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755004AbZAXUHG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Jan 2009 15:07:06 -0500
Received: from mail.suse.de ([195.135.220.2]:50367 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753363AbZAXUHF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Jan 2009 15:07:05 -0500
From: Andreas Schwab <schwab@suse.de>
To: =?iso-8859-1?Q?T=F6r=F6k?= Edwin <edwintorok@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       LLVM Developers Mailing List <llvmdev@cs.uiuc.edu>
Subject: Re: inline asm semantics: output constraint width smaller than input
References: <497A0500.3080706@gmail.com> <20090123181721.GA32545@elte.hu>
	<497A0C0A.7080207@gmail.com> <497B408C.20802@gmail.com>
X-Yow: Yow!  I just went below the poverty line!
Date: Sat, 24 Jan 2009 21:07:02 +0100
In-Reply-To: <497B408C.20802@gmail.com> (=?iso-8859-1?Q?=22T=F6r=F6k?=
 Edwin"'s message of "Sat, 24
	Jan 2009 18:23:40 +0200")
Message-ID: <jebptw4gex.fsf@sykes.suse.de>
User-Agent: Gnus/5.110009 (No Gnus v0.9) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Török Edwin <edwintorok@gmail.com> writes:

> @@ -239,11 +239,13 @@ extern void __put_user_8(void);
>   */
>  #define put_user(x, ptr)                    \
>  ({                                \
> -    int __ret_pu;                        \
> +    __typeof__(*(ptr)) __ret_pu;                \
>      __typeof__(*(ptr)) __pu_val;                \
>      __chk_user_ptr(ptr);                    \
>      might_fault();                        \
>      __pu_val = x;                        \
> +       /* return value is 0 or -EFAULT, both fit in 1 byte, and \
> +    * are sign-extendable to int */                \

That does not work when *ptr is unsigned (char or short).

Andreas.

-- 
Andreas Schwab, SuSE Labs, schwab@suse.de
SuSE Linux Products GmbH, Maxfeldstraße 5, 90409 Nürnberg, Germany
PGP key fingerprint = 58CA 54C7 6D53 942B 1756  01D3 44D5 214B 8276 4ED5
"And now for something completely different."
