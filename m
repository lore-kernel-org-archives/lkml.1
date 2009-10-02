Return-Path: <linux-kernel-owner+w=401wt.eu-S1755641AbZJBTTT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755641AbZJBTTT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Oct 2009 15:19:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752904AbZJBTTS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Oct 2009 15:19:18 -0400
Received: from one.firstfloor.org ([213.235.205.2]:53424 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752669AbZJBTTS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Oct 2009 15:19:18 -0400
To: Arjan van de Ven <arjan@infradead.org>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, tglx@tglx.de, hpa@zytor.com,
       torvalds@linux-foundation.org
Subject: Re: [PATCH] x86: Use __builtin_memset and __builtin_memcpy for memset/memcpy
From: Andi Kleen <andi@firstfloor.org>
References: <20090928113433.5e9b8ea7@infradead.org>
Date: Fri, 02 Oct 2009 21:19:18 +0200
In-Reply-To: <20090928113433.5e9b8ea7@infradead.org> (Arjan van de Ven's message of "Mon, 28 Sep 2009 11:34:33 +0200")
Message-ID: <87bpkpbo3t.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arjan van de Ven <arjan@infradead.org> writes:

> From ebb81aab0c3df19771ebc0eec1261ae314ddc0af Mon Sep 17 00:00:00 2001
> From: Arjan van de Ven <arjan@linux.intel.com>
> Date: Mon, 28 Sep 2009 11:21:32 +0200
> Subject: [PATCH] x86: Use __builtin_memset and __builtin_memcpy for memset/memcpy
>
> GCC provides reasonable memset/memcpy functions itself, with __builtin_memset
> and __builtin_memcpy. For the "unknown" cases, it'll fall back to our
> current existing functions, but for fixed size versions it'll inline
> something smart. Quite often that will be the same as we have now,
> but sometimes it can do something smarter (for example, if the code
> then sets the first member of a struct, it can do a shorter memset).
>
> In addition, and this is more important, gcc knows which registers and
> such are not clobbered (while for our asm version it pretty much
> acts like a compiler barrier), so for various cases it can avoid reloading
> values.
>
> The effect on codesize is shown below on my typical laptop .config:
>
>    text	   data	    bss	    dec	    hex	filename
> 5605675	2041100	6525148	14171923	 d83f13	vmlinux.before
> 5595849	2041668	6525148	14162665	 d81ae9	vmlinux.after

I tried this some time ago, but it it generates bad code on some 
gcc 3 versions.

You really need to test such kind of changes on a wide variety
of compilers, not assuming everyone uses the same version as you.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
