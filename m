Return-Path: <linux-kernel-owner+w=401wt.eu-S1751917AbZHSIBD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751917AbZHSIBD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Aug 2009 04:01:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751159AbZHSIBC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Aug 2009 04:01:02 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:37334 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751152AbZHSIBC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Aug 2009 04:01:02 -0400
Subject: Re: [PATCH] x86: make use of inc/dec conditional
From: Peter Zijlstra <peterz@infradead.org>
To: Jan Beulich <JBeulich@novell.com>
Cc: mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com,
       linux-kernel@vger.kernel.org
In-Reply-To: <4A8BCA850200007800010836@vpn.id2.novell.com>
References: <4A8BCA850200007800010836@vpn.id2.novell.com>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Wed, 19 Aug 2009 10:01:00 +0200
Message-Id: <1250668860.7583.327.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-08-19 at 08:48 +0100, Jan Beulich wrote:
> According to gcc's instruction selection, inc/dec can be used without
> penalty on most CPU models, but should be avoided on others. Hence we
> should have a config option controlling the use of inc/dec, and
> respective abstraction macros to avoid making the resulting code too
> ugly. There are a few instances of inc/dec that must be retained in
> assembly code, due to that code's dependency on the instruction not
> changing the carry flag.
> 
> Signed-off-by: Jan Beulich <jbeulich@novell.com>
> 
> ---
>  arch/x86/Kconfig.cpu                |    4 ++++
>  arch/x86/include/asm/asm.h          |   27 +++++++++++++++++++++++++++
>  arch/x86/include/asm/atomic_32.h    |    8 ++++----
>  arch/x86/include/asm/atomic_64.h    |   16 ++++++++--------
>  arch/x86/include/asm/checksum_32.h  |    2 +-
>  arch/x86/include/asm/spinlock.h     |    6 +++---
>  arch/x86/lib/checksum_32.S          |   11 ++++++-----
>  arch/x86/lib/clear_page_64.S        |    3 ++-
>  arch/x86/lib/copy_page_64.S         |    5 +++--
>  arch/x86/lib/copy_user_64.S         |   17 +++++++++--------
>  arch/x86/lib/copy_user_nocache_64.S |   17 +++++++++--------
>  arch/x86/lib/memcpy_64.S            |   11 ++++++-----
>  arch/x86/lib/memset_64.S            |    7 ++++---
>  arch/x86/lib/rwlock_64.S            |    5 +++--
>  arch/x86/lib/semaphore_32.S         |    7 ++++---
>  arch/x86/lib/string_32.c            |   23 ++++++++++++-----------
>  arch/x86/lib/strstr_32.c            |    5 +++--
>  17 files changed, 108 insertions(+), 66 deletions(-)

What's the performance gain? This seems like a rather large and ugly
patch if the result is borderline.
