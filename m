Return-Path: <linux-kernel-owner+w=401wt.eu-S1755949AbZDOTrt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755949AbZDOTrt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Apr 2009 15:47:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754578AbZDOTrj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Apr 2009 15:47:39 -0400
Received: from hera.kernel.org ([140.211.167.34]:52570 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753690AbZDOTri (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Apr 2009 15:47:38 -0400
Message-ID: <49E6397D.1020201@kernel.org>
Date: Wed, 15 Apr 2009 12:46:05 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Joerg Roedel <joerg.roedel@amd.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       stable@kernel.org
Subject: Re: [PATCH] x86: used used_vectors in init_IRQ
References: <49E62DFD.6010904@kernel.org> <20090415192550.GA27004@elte.hu> <49E636F2.7030902@kernel.org> <20090415193827.GB32675@elte.hu>
In-Reply-To: <20090415193827.GB32675@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Yinghai Lu <yinghai@kernel.org> wrote:
> 
>> Ingo Molnar wrote:
>>
>>> Note, i removed the -stable tag because i dont think .29 nor 
>>> .30-rc2 is affected. Your patch to irqinit*.c (and the later 
>>> unification by Pekka) is something still pending in the 
>>> perfcounters and x86 trees, queued for .31.
>> not sure .29, but it seems we need this for 2.6.30
>>

you are right...

in trap_init with linus tree

still have
#ifdef CONFIG_X86_64
        set_bit(IA32_SYSCALL_VECTOR, used_vectors);
#else
        set_bit(SYSCALL_VECTOR, used_vectors);
#endif


so one patch (merge irqinit_32/64) in tip for .31 expose that bug.

aka we don't back port ...

YH
