Return-Path: <linux-kernel-owner+w=401wt.eu-S1753647AbYJ3Dz6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753647AbYJ3Dz6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2008 23:55:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751048AbYJ3Dzt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Oct 2008 23:55:49 -0400
Received: from terminus.zytor.com ([198.137.202.10]:42278 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750764AbYJ3Dzt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2008 23:55:49 -0400
Message-ID: <49093012.7010301@zytor.com>
Date: Wed, 29 Oct 2008 20:54:58 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Jike Song <albcamus@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>, tglx@linutronix.de, mingo@redhat.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: fix inline assembly constraints
References: <1225297937-2917-1-git-send-email-albcamus@gmail.com>	 <20081029163400.GA14866@elte.hu> <df9815e70810291931i4c00966u8f4493386e376b28@mail.gmail.com>
In-Reply-To: <df9815e70810291931i4c00966u8f4493386e376b28@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jike Song wrote:
> 
> Besides, by looking at the inline assembly in kernel,  I found lots of
> codes like this:
> 
>         static inline void atomic_add(int i, atomic_t *v)
>         {
> 	        asm volatile(LOCK_PREFIX "addl %1,%0"
> 		             : "=m" (v->counter)
> 		             : "ir" (i), "m" (v->counter));
>         }
> 
> 
> Yes, it works. But a little ugly..  Should this be cleaned-up with the
> following?
> 
>         : "+m" (v->counter)
>         : "ir" (i)
> 
> If you agrees, I'll send out the patch; otherwise I won't wasting your time ;-)
> 

Please don't change them just to change them, if there is no actual
error.  You never know when you're going to trigger a new bug in some
weird version of gcc.

	-hpa
