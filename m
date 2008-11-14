Return-Path: <linux-kernel-owner+w=401wt.eu-S1755911AbYKNAXX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755911AbYKNAXX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2008 19:23:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752544AbYKNAXH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Nov 2008 19:23:07 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55350 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754619AbYKNAXE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2008 19:23:04 -0500
Date: Thu, 13 Nov 2008 16:21:28 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Masami Hiramatsu <mhiramat@redhat.com>
Cc: ananth@in.ibm.com, jkenisto@us.ibm.com, davem@davemloft.net,
       linux-kernel@vger.kernel.org, systemtap@sources.redhat.com,
       rusty@rustcorp.com.au
Subject: Re: [PATCH 2/7] kprobes: Add kprobe_insn_mutex and cleanup
 arch_remove_kprobe()
Message-Id: <20081113162128.28e508ca.akpm@linux-foundation.org>
In-Reply-To: <4919F175.2050009@redhat.com>
References: <4919F175.2050009@redhat.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 11 Nov 2008 15:56:21 -0500
Masami Hiramatsu <mhiramat@redhat.com> wrote:

> Add kprobe_insn_mutex for protecting kprobe_insn_pages hlist, and remove
> kprobe_mutex from architecture dependent code.
> 
> This allows us to call arch_remove_kprobe() (and free_insn_slot) while holding
> kprobe_mutex.
> 
> Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
> ---
>  arch/arm/kernel/kprobes.c     |    2 --
>  arch/ia64/kernel/kprobes.c    |    8 +++++---
>  arch/powerpc/kernel/kprobes.c |    7 ++++---
>  arch/s390/kernel/kprobes.c    |    7 ++++---
>  arch/x86/kernel/kprobes.c     |    7 ++++---
>  include/linux/kprobes.h       |    1 -
>  kernel/kprobes.c              |   25 +++++++++++++++++++++----

For some reasons sparc64 never had this mutex.  You've checked that
sparc64 will be OK after this change?

