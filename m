Return-Path: <linux-kernel-owner+w=401wt.eu-S1753725AbZGLJYu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753725AbZGLJYu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Jul 2009 05:24:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752089AbZGLJYl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Jul 2009 05:24:41 -0400
Received: from one.firstfloor.org ([213.235.205.2]:58664 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751058AbZGLJYl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Jul 2009 05:24:41 -0400
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Arjan van de Ven <arjan@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Siarhei Liakh <sliakh.lkml@gmail.com>, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org, James Morris <jmorris@namei.org>,
       Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@muc.de>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       linux-cris-kernel@axis.com
Subject: Re: [PATCH v5] RO/NX protection for loadable kernel modules
From: Andi Kleen <andi@firstfloor.org>
References: <817ecb6f0907081610p6d60341cudbee42685eac1347@mail.gmail.com>
	<200907111821.47769.rusty@rustcorp.com.au>
	<20090711084958.69ff9196@infradead.org>
	<200907121410.39874.rusty@rustcorp.com.au>
Date: Sun, 12 Jul 2009 11:24:37 +0200
In-Reply-To: <200907121410.39874.rusty@rustcorp.com.au> (Rusty Russell's message of "Sun, 12 Jul 2009 14:10:39 +0930")
Message-ID: <87skh29ru2.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rusty Russell <rusty@rustcorp.com.au> writes:
>
> (I like the idea of trying kmalloc and falling back, simply because it reduces 
> TLB pressure,

I implemented this for 32bit in 2.4, but I always had second thoughts
if that was really reducing TLB pressure.

x86 CPUs have separated TLBs for 2MB and 4K and they all have much
more 4K entries. So it might actually be worse to use the 2MB TLBs for
this.

> but that's probably best done after unification).

Trying kmalloc doesn't work on x86-64

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
