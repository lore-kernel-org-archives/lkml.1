Return-Path: <linux-kernel-owner+w=401wt.eu-S1756533AbZLUBxo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756533AbZLUBxo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Dec 2009 20:53:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756444AbZLUBxn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Dec 2009 20:53:43 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:51886 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756368AbZLUBxn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Dec 2009 20:53:43 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Masami Hiramatsu <mhiramat@redhat.com>
Subject: Re: [PATCH BUGFIX] [RESEND] mm: Pass mm->flags as a coredump parameter for consistency
Cc: kosaki.motohiro@jp.fujitsu.com, Andrew Morton <akpm@linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>,
       systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>,
       Roland McGrath <roland@redhat.com>,
       Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>,
       Oleg Nesterov <oleg@redhat.com>, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <20091218165006.18457.52191.stgit@dhcp-100-2-132.bos.redhat.com>
References: <20091218165006.18457.52191.stgit@dhcp-100-2-132.bos.redhat.com>
Message-Id: <20091221104717.088B.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Mon, 21 Dec 2009 10:53:39 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Pass mm->flags as a coredump parameter for consistency.
> 
>  ---
> 1787         if (mm->core_state || !get_dumpable(mm)) {  <- (1)
> 1788                 up_write(&mm->mmap_sem);
> 1789                 put_cred(cred);
> 1790                 goto fail;
> 1791         }
> 1792
> [...]
> 1798         if (get_dumpable(mm) == 2) {    /* Setuid core dump mode */ <-(2)
> 1799                 flag = O_EXCL;          /* Stop rewrite attacks */
> 1800                 cred->fsuid = 0;        /* Dump root private */
> 1801         }
>  ---
> 
> Since dumpable bits are not protected by lock, there is a
> chance to change these bits between (1) and (2).
> 
> To solve this issue, this patch copies mm->flags to
> coredump_params.mm_flags at the beginning of do_coredump()                      and uses it instead of get_dumpable() while dumping core.
> 
> This copy is also passed to binfmt->core_dump, since
> elf*_core_dump() uses dump_filter bits in mm->flags.
> 
> Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
> Cc: Roland McGrath <roland@redhat.com>
> Cc: Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Oleg Nesterov <oleg@redhat.com>
> Cc: Ingo Molnar <mingo@elte.hu>
> Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

looks good to me.
	Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>




