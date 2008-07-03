Return-Path: <linux-kernel-owner+w=401wt.eu-S935999AbYGCHNn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935999AbYGCHNn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2008 03:13:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754896AbYGCG6j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jul 2008 02:58:39 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34037 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755154AbYGCGHG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2008 02:07:06 -0400
Date: Wed, 2 Jul 2008 23:06:36 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
Cc: tzanussi@gmail.com, penberg@cs.helsinki.fi, torvalds@linux-foundation.org,
       compudj@krystal.dyndns.org, vegard.nossum@gmail.com,
       linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Subject: Re: [PATCH 3/3] relay: Add buffer-only channels; useful for early
 logging.
Message-Id: <20080702230636.66e484bb.akpm@linux-foundation.org>
In-Reply-To: <20080623153104.50549291@linux360.ro>
References: <20080623153104.50549291@linux360.ro>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 23 Jun 2008 15:31:04 +0300 Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro> wrote:

> Allows one to create and use a channel with no associated files. Files
> can be initialized later. This is useful in scenarios such as logging
> in early code, before VFS is up. Therefore, such channels can be
> created and used as soon as kmem_cache_init() completed.
> 
> This is needed by kmemtrace to do tracing in early kernel code.

This breaks on sparc64.

> +			err = smp_call_function_single(i,
> +						       __relay_set_buf_dentry,
> +						       &disp, 0, 1);

Because that ain't implemented.

There's a call in net/iucv/iucv.c, but that's s390-only.

There's a call in virt/kvm/kvm_main.c.

There's a call in kernel/time/tick-broadcast.c, so I assume that the
intersection between CONFIG_GENERIC_CLOCKEVENTS_BROADCAST and
non-smp_call_function_single() architectures is presently empty.


I guess all SMP-capable architectures should now implement this,
please.  It is presently defined on all architectures for CONFIG_SMP=n
and it is declared in include/linux/smp.h.

