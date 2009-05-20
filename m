Return-Path: <linux-kernel-owner+w=401wt.eu-S1756123AbZETVOi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756123AbZETVOi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 May 2009 17:14:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754214AbZETVOb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 May 2009 17:14:31 -0400
Received: from mail-out.m-online.net ([212.18.0.9]:57049 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750946AbZETVOa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 May 2009 17:14:30 -0400
From: Andreas Schwab <schwab@linux-m68k.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, Christoph Hellwig <hch@infradead.org>,
       Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>,
       Vitaly Mayatskikh <v.mayatskih@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: Q: put_user_try & co (Was: [PATCH 1/5] Split wait_noreap_copyout())
References: <1242036759-4025-1-git-send-email-v.mayatskih@gmail.com>
	<1242036759-4025-2-git-send-email-v.mayatskih@gmail.com>
	<20090511120418.GA3859@infradead.org> <20090511121708.GD13954@elte.hu>
	<20090520190312.GA32333@redhat.com>
X-Yow: Let's climb to the TOP of that MOUNTAIN and think about STRIP MINING!!
Date: Wed, 20 May 2009 23:14:25 +0200
In-Reply-To: <20090520190312.GA32333@redhat.com> (Oleg Nesterov's message of
	"Wed, 20 May 2009 21:03:12 +0200")
Message-ID: <m2my97wk7i.fsf@igel.home>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.93 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oleg Nesterov <oleg@redhat.com> writes:

> Pseudo-code:
>
> 	#define put_user_try				\
> 		do {					\
> 			__label__  __efault_label;	\
>
>
> 	#define put_user_catch(err)			\
> 			err = 0;			\
> 			if (0) {			\
> 			__efault_label:			\
> 				err = -EFAULT;		\
> 			}				\
> 		while (0)
> 		
>
> 	#define __put_user_asm_ex(...)				\
> 		asm volatile(					\
> 			"1:	mov ..."			\
> 			_ASM_EXTABLE(1b, &__efault_label)	\
> 		     	: : ...)

The address of local labels can only be used in connection with computed
gotos, otherwise you get unspecified results.

Andreas.

-- 
Andreas Schwab, schwab@linux-m68k.org
GPG Key fingerprint = 58CA 54C7 6D53 942B 1756  01D3 44D5 214B 8276 4ED5
"And now for something completely different."
