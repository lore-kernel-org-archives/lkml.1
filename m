Return-Path: <linux-kernel-owner+w=401wt.eu-S1757014AbZEMIin@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757014AbZEMIin (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 May 2009 04:38:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754887AbZEMIib
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 May 2009 04:38:31 -0400
Received: from one.firstfloor.org ([213.235.205.2]:36976 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755708AbZEMIia (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 May 2009 04:38:30 -0400
To: Sheng Yang <sheng@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, linux-mm <linux-mm@kvack.org>,
       Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] x86: Extend test_and_set_bit() test_and_clean_bit() to 64 bits in X86_64
From: Andi Kleen <andi@firstfloor.org>
References: <1242202647-32446-1-git-send-email-sheng@linux.intel.com>
Date: Wed, 13 May 2009 10:38:29 +0200
In-Reply-To: <1242202647-32446-1-git-send-email-sheng@linux.intel.com> (Sheng Yang's message of "Wed, 13 May 2009 16:17:27 +0800")
Message-ID: <87zldhl7ne.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sheng Yang <sheng@linux.intel.com> writes:

> -static inline int test_and_set_bit(int nr, volatile unsigned long *addr)
> +static inline int test_and_set_bit(long int nr, volatile unsigned long *addr)
>  {
>  	int oldbit;
>  
> -	asm volatile(LOCK_PREFIX "bts %2,%1\n\t"
> +	asm volatile(LOCK_PREFIX REX_X86 "bts %2,%1\n\t"

Use btsq on 64bit, then you don't need the explicit rex prefix.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
