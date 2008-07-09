Return-Path: <linux-kernel-owner+w=401wt.eu-S1756043AbYGIWew@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756043AbYGIWew (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2008 18:34:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751585AbYGIWeo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jul 2008 18:34:44 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:32845 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750881AbYGIWen (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2008 18:34:43 -0400
Date: Wed, 9 Jul 2008 15:28:31 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Ollie Wild <aaw@google.com>
Cc: bugme-daemon@bugzilla.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Roland McGrath <roland@redhat.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Hugh Dickins <hugh@veritas.com>, pageexec@freemail.hu,
       linux-kernel@vger.kernel.org
Subject: Re: [Bug 11063] New: lack of GNU_STACK header doesn't result in rwx
 stack on i386
Message-Id: <20080709152831.99237c00.akpm@linux-foundation.org>
In-Reply-To: <bug-11063-27@http.bugzilla.kernel.org/>
References: <bug-11063-27@http.bugzilla.kernel.org/>
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.12.1; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


(switched to email.  Please respond via emailed reply-to-all, not via the
bugzilla web interface).

On Wed,  9 Jul 2008 12:13:05 -0700 (PDT) bugme-daemon@bugzilla.kernel.org wrote:

> http://bugzilla.kernel.org/show_bug.cgi?id=11063
> 
>            Summary: lack of GNU_STACK header doesn't result in rwx stack on
>                     i386
>            Product: Memory Management
>            Version: 2.5
>           Platform: All
>         OS/Version: Linux
>               Tree: Mainline
>             Status: NEW
>           Severity: normal
>           Priority: P1
>          Component: Other
>         AssignedTo: akpm@osdl.org
>         ReportedBy: pageexec@freemail.hu
> 
> 
> Latest working kernel version: unknown, probably before the introduction of
> unlimited argv
> Earliest failing kernel version: unknown, probably after the introduction of
> unlimited argv, 2.6.26-rc9 definitely fails
> Distribution:
> Hardware Environment:
> Software Environment:
> Problem Description:
> ELF/i386 traditionally has an executable stack which in the PT_GNU_STACK world
> is provided two ways: if the ELF has a RWE PT_GNU_STACK program header or if it
> lacks that program header. due to this regression, the latter case results in a
> non-executable stack with corresponding breakage of (old) userland binaries
> that use nested function trampolines.
> 
> this bug was probably introduced when the unlimited argv feature was merged: in
> that system the stack vma (and its vm_flags) is initialized too early, before
> the incoming process' ELF header is consulted, which on i386 means that the
> personality used for determining the executable status of the stack is that of
> the old process, not the incoming one. later, in setup_arg_pages, only the
> explicit setting (disable/enable) of stack executability is honoured,
> EXSTACK_DEFAULT isn't consulted (i guess the assumption was that the initial
> ->vm_flags setting got it right).
> 
> Steps to reproduce: run any ELF that lacks a PT_GNU_STACK program header and
> check its stack vma, it'll be rw-, instead of rwx.
> 

