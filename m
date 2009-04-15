Return-Path: <linux-kernel-owner+w=401wt.eu-S1754632AbZDOEoX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754632AbZDOEoX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Apr 2009 00:44:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752201AbZDOEoO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Apr 2009 00:44:14 -0400
Received: from ozlabs.org ([203.10.76.45]:51866 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752328AbZDOEoN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Apr 2009 00:44:13 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Hugh Dickins <hugh@veritas.com>
Subject: Re: [PATCH] x86 microcode: revert some work_on_cpu
Date: Wed, 15 Apr 2009 14:14:07 +0930
User-Agent: KMail/1.11.2 (Linux/2.6.28-11-generic; KDE/4.2.2; i686; ; )
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>,
       Peter Oruba <peter.oruba@amd.com>,
       Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org
References: <Pine.LNX.4.64.0904141919350.3124@blonde.anvils>
In-Reply-To: <Pine.LNX.4.64.0904141919350.3124@blonde.anvils>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200904151414.09119.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 15 Apr 2009 03:55:42 am Hugh Dickins wrote:
> Revert part of af5c820a3169e81af869c113e18ec7588836cd50
> x86: cpumask: use work_on_cpu in arch/x86/kernel/microcode_core.c
> 
> That change is causing only one Intel CPU's microcode to be updated e.g.
> microcode: CPU3 updated from revision 0x9 to 0x17, date = 2005-04-22 
> where before it announced that also for CPU0 and CPU1 and CPU2.
> 
> We cannot use work_on_cpu() in the CONFIG_MICROCODE_OLD_INTERFACE code,
> because Intel's request_microcode_user() involves a copy_from_user() from
> /sbin/microcode_ctl, which therefore needs to be on that CPU at the time.

Erk.  Ack the reversion, but this needs to be fixed properly.

We can't just mug a process's affinity.  I'll look at this code again and
see what I can do.

> May be not the only problem with that commit: I've seen lockdep
> warnings from s2ram when suspending; but I think there have been other
> work_on_cpu() lockdep issues, and you may already be on to them?

Yep.

Thanks,
Rusty.
