Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756167Ab0BHBph (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Feb 2010 20:45:37 -0500
Received: from ozlabs.org ([203.10.76.45]:39348 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755366Ab0BHBpf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Feb 2010 20:45:35 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH v8] RO/NX protection for loadable kernel modules
Date: Mon, 8 Feb 2010 12:15:31 +1030
User-Agent: KMail/1.12.2 (Linux/2.6.31-19-generic; KDE/4.3.2; i686; ; )
Cc: Siarhei Liakh <sliakh.lkml@gmail.com>, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org, linux-next@vger.kernel.org,
       Arjan van de Ven <arjan@infradead.org>,
       James Morris <jmorris@namei.org>,
       Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@muc.de>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Ingo Molnar <mingo@elte.hu>, Stephen Rothwell <sfr@canb.auug.org.au>,
       Dave Jones <davej@redhat.com>
References: <817ecb6f1001311522q52bf4eebmb748c486dcd5ad35@mail.gmail.com> <873a1jdyrg.fsf@basil.nowhere.org>
In-Reply-To: <873a1jdyrg.fsf@basil.nowhere.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201002081215.31527.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 3 Feb 2010 09:35:39 am Andi Kleen wrote:
> Siarhei Liakh <sliakh.lkml@gmail.com> writes:
> 
> > This patch is a logical extension of the protection provided by
> > CONFIG_DEBUG_RODATA to LKMs. The protection is provided by splitting
> > module_core and module_init into three logical parts each and setting
> > appropriate page access permissions for each individual section:
> 
> My current kernel has 52 modules loaded, most of them very small. 
> Assuming the additional alignment of the data section cost two more
> pages on average (I think that's a good assumption), that's roughly
> 424KB of additional memory, plus associated runtime costs in increased
> TLB usage.
> 
> What would I get for that if I applied the patch and enabled the option? 

Strict RO/NX protection.  But without the option enabled, the patch gives
best-effort protection, which is nice (for no additional space).

Cheers,
Rusty.
