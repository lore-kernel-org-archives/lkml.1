Return-Path: <linux-kernel-owner+w=401wt.eu-S1754112AbZFEMSw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754112AbZFEMSw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 08:18:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751708AbZFEMSo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 08:18:44 -0400
Received: from casper.infradead.org ([85.118.1.10]:38911 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751519AbZFEMSo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 08:18:44 -0400
Subject: Re: [PATCH] x86: Code atomic[64]_read and atomic[64]_set in C not
 CPP
From: Peter Zijlstra <peterz@infradead.org>
To: Paul Mackerras <paulus@samba.org>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
In-Reply-To: <18984.63207.824631.459239@cargo.ozlabs.ibm.com>
References: <18984.63207.824631.459239@cargo.ozlabs.ibm.com>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Fri, 05 Jun 2009 14:18:40 +0200
Message-Id: <1244204320.13761.4302.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-06-05 at 20:43 +1000, Paul Mackerras wrote:
> Occasionally we get bugs where atomic_read or atomic_set are used on
> atomic64_t variables or vice versa.  These bugs don't generate
> warnings on x86 because atomic_read and atomic_set are coded as macros
> rather than C functions, so we don't get any type-checking on their
> arguments; similarly for atomic64_read and atomic64_set in 64-bit
> kernels.
> 
> This converts them to C functions so that the arguments are
> type-checked and bugs like this will get caught more easily.
> It also converts atomic_cmpxchg and atomic_xchg, and atomic64_cmpxchg
> and atomic64_xchg on 64-bit, so we get type-checking on their
> arguments too.
> 
> Compiling a typical 64-bit x86 config, this generates no new warnings,
> and the vmlinux text is 86 bytes smaller.
> 
> Signed-off-by: Paul Mackerras <paulus@samba.org>

Nice!

Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
