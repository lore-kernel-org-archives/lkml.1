Return-Path: <linux-kernel-owner+w=401wt.eu-S1759703AbYDRVcE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759703AbYDRVcE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2008 17:32:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751052AbYDRVby
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Apr 2008 17:31:54 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57065 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750977AbYDRVby (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2008 17:31:54 -0400
Date: Fri, 18 Apr 2008 14:31:10 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: x86: spinlock ops are always-inlined
Message-Id: <20080418143110.c8e596c8.akpm@linux-foundation.org>
In-Reply-To: <200804181847.m3IIlLPr032254@hera.kernel.org>
References: <200804181847.m3IIlLPr032254@hera.kernel.org>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 18 Apr 2008 18:47:21 GMT
Linux Kernel Mailing List <linux-kernel@vger.kernel.org> wrote:

> Gitweb:     http://git.kernel.org/git/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=7fda20f146d5d217684ffbc37c6b6c5f82c2dffd
> Commit:     7fda20f146d5d217684ffbc37c6b6c5f82c2dffd
> Parent:     d93c870bad38e8daaaf9f7e900a13431f24becbb
> Author:     Ingo Molnar <mingo@elte.hu>
> AuthorDate: Fri Feb 29 10:29:38 2008 +0100
> Committer:  Ingo Molnar <mingo@elte.hu>
> CommitDate: Thu Apr 17 17:41:29 2008 +0200
> 
>     x86: spinlock ops are always-inlined
>     
>     Signed-off-by: Ingo Molnar <mingo@elte.hu>
> ---
>  include/asm-x86/spinlock.h |   12 ++++++------
>  1 files changed, 6 insertions(+), 6 deletions(-)
> 
> diff --git a/include/asm-x86/spinlock.h b/include/asm-x86/spinlock.h
> index 47dfe26..bc6376f 100644
> --- a/include/asm-x86/spinlock.h
> +++ b/include/asm-x86/spinlock.h
> @@ -78,7 +78,7 @@ static inline int __raw_spin_is_contended(raw_spinlock_t *lock)
>  	return (((tmp >> 8) & 0xff) - (tmp & 0xff)) > 1;
>  }
>  
> -static inline void __raw_spin_lock(raw_spinlock_t *lock)
> +static __always_inline void __raw_spin_lock(raw_spinlock_t *lock)

What was the reason for making this change?
