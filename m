Return-Path: <linux-kernel-owner+w=401wt.eu-S1757415Ab0ANRcq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757415Ab0ANRcq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jan 2010 12:32:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755725Ab0ANRcp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jan 2010 12:32:45 -0500
Received: from mail3.caviumnetworks.com ([12.108.191.235]:15449 "EHLO
	mail3.caviumnetworks.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757378Ab0ANRco (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jan 2010 12:32:44 -0500
Message-ID: <4B4F548B.7090405@caviumnetworks.com>
Date: Thu, 14 Jan 2010 09:29:47 -0800
From: David Daney <ddaney@caviumnetworks.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Jason Wessel <jason.wessel@windriver.com>
CC: linux-kernel@vger.kernel.org, kgdb-bugreport@lists.sourceforge.net,
       mingo@elte.hu, Ralf Baechle <ralf@linux-mips.org>
Subject: Re: [PATCH 22/40] mips,kgdb: kdb low level trap catch and stack trace
References: <1263481176-1897-1-git-send-email-jason.wessel@windriver.com> <1263481176-1897-23-git-send-email-jason.wessel@windriver.com>
In-Reply-To: <1263481176-1897-23-git-send-email-jason.wessel@windriver.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 14 Jan 2010 17:29:47.0596 (UTC) FILETIME=[2B5528C0:01CA953F]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jason Wessel wrote:
> The only way the debugger can handle a trap in inside rcu_lock,
> notify_die, or atomic_notifier_call_chain without a recursive fault is
> to have a low level "first opportunity handler" do_trap_or_bp() handler.
> 
> Generally this will be something the vast majority of folks will not
> need, but for those who need it, it is added as a kernel .config
> option called KGDB_LOW_LEVEL_TRAP.
> 
> Also added was a die notification for oops such that kdb can catch an
> oops for analysis.
> 
> There appeared to be no obvious way to pass the struct pt_regs from
> the original exception back to the stack back tracer, so a special
> case was added to show_stack() for when kdb is active because you
> generally desire to generally look at the back trace of the original
> exception.
> 
> CC: Ralf Baechle <ralf@linux-mips.org>
> Signed-off-by: Jason Wessel <jason.wessel@windriver.com>
> ---
>  arch/mips/include/asm/kgdb.h |    2 ++
>  arch/mips/kernel/kgdb.c      |   22 +++++++++++++++++++++-
>  arch/mips/kernel/traps.c     |   14 ++++++++++++++
>  lib/Kconfig.kgdb             |    2 +-
[...]
> +#include "../../../kernel/debug/kdb/kdb_private.h"
>  

There must be a better way of referring to this include file.  Perhaps 
it should be moved to a more central place that is already in the 
include path so we can refer to it with #include <.../file.h>

David Daney
