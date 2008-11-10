Return-Path: <linux-kernel-owner+w=401wt.eu-S1754195AbYKJIVi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754195AbYKJIVi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2008 03:21:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753497AbYKJIVa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Nov 2008 03:21:30 -0500
Received: from one.firstfloor.org ([213.235.205.2]:52396 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753353AbYKJIVa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2008 03:21:30 -0500
To: Harvey Harrison <harvey.harrison@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC-PATCH] x86: really use __builtin_memcmp on x86_32
From: Andi Kleen <andi@firstfloor.org>
References: <1226297544.5478.26.camel@brick>
Date: Mon, 10 Nov 2008 09:38:58 +0100
In-Reply-To: <1226297544.5478.26.camel@brick> (Harvey Harrison's message of "Sun, 09 Nov 2008 22:12:23 -0800")
Message-ID: <87prl4otzx.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Harvey Harrison <harvey.harrison@gmail.com> writes:

> Impact: prevent generic code from overriding __builtin_memcmp
>
> lib/string.c was using a generic implementation of memcmp
> because __HAVE_ARCH_MEMCMP was not defined and it was then doing
> #undef memcmp and defining a generic version.

gcc sometimes decides to not inline memcmp, so an out of line
version is always needed even when __builtin_memcmp is used.

While in theory x86 could supply an optimized version,
memcmp is relatively rarely used (and in many cases inlined),
so adding an assembler version for x86 is likely not worth
it.

-Andi

-- 
ak@linux.intel.com
