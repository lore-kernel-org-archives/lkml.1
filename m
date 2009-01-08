Return-Path: <linux-kernel-owner+w=401wt.eu-S1756945AbZAHIE6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756945AbZAHIE6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2009 03:04:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752977AbZAHIEs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Jan 2009 03:04:48 -0500
Received: from terminus.zytor.com ([198.137.202.10]:47828 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751695AbZAHIEs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2009 03:04:48 -0500
Message-ID: <4965B38C.3040204@kernel.org>
Date: Thu, 08 Jan 2009 00:04:28 -0800
From: "H. Peter Anvin" <hpa@kernel.org>
Organization: Linux Kernel Organization, Inc.
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Hugh Dickins <hugh@veritas.com>, Andi Kleen <andi@firstfloor.org>,
       Andrew Morton <akpm@linux-foundation.org>, x86@kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [3/5] Mark complex bitops.h inlines as __always_inline
References: <200901051236.281008835@firstfloor.org> <20090104233640.6A7453E6653@basil.firstfloor.org> <Pine.LNX.4.64.0901061847110.29408@blonde.anvils> <20090107131846.GF3529@elte.hu>
In-Reply-To: <20090107131846.GF3529@elte.hu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Hugh Dickins <hugh@veritas.com> wrote:
> 
>> Hugh Dickins noticed that released gcc versions building the kernel with 
>> CONFIG_OPTIMIZE_INLINING=y don't inline some of the bitops - sometimes 
>> generating very inefficient pageflag tests, and many instances of 
>> constant_test_bit().
> 
> Could you quantify that please?
> 
> We really dont want to reintroduce __always_inline just for performance / 
> code size reasons. If GCC messes up and makes a larger / more inefficient 
> kernel, GCC will be fixed. CONFIG_OPTIMIZE_INLINING is default-off, so 
> enable it only if it improves your kernel.
> 

There is one condition under which gcc simply won't know, and that is
when an inline is composed primarily of asm code.  gcc, I believe,
creates a worst-case estimate based on the number of semicolons or
newlines (something that works semi-okayish on RISC), and thus tend to
vastly overestimate the size of an asm() on x86, where statements are
highly variable length.  Hence it is probably always going to need
hints, unless the whole handling of inline assembly is revamped (which
would be good for scheduling, but I doubt it will happen.)

	-hpa
