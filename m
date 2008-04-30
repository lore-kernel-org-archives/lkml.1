Return-Path: <linux-kernel-owner+w=401wt.eu-S1765396AbYD3Xhf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765396AbYD3Xhf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 19:37:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755497AbYD3Xh1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 19:37:27 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54625 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752364AbYD3Xh1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 19:37:27 -0400
Date: Wed, 30 Apr 2008 16:36:38 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: francois.valenduc@tvcablenet.be
Cc: bugme-daemon@bugzilla.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [Bugme-new] [Bug 10580] New: uvesafb is broken
Message-Id: <20080430163638.34855120.akpm@linux-foundation.org>
In-Reply-To: <bug-10580-10286@http.bugzilla.kernel.org/>
References: <bug-10580-10286@http.bugzilla.kernel.org/>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(switched to email.  Please respond via emailed reply-to-all, not via the
bugzilla web interface).

On Wed, 30 Apr 2008 16:25:13 -0700 (PDT)
bugme-daemon@bugzilla.kernel.org wrote:

> http://bugzilla.kernel.org/show_bug.cgi?id=10580
> 
>            Summary: uvesafb is broken
>            Product: Drivers
>            Version: 2.5
>      KernelVersion: 2.6.25-git
>           Platform: All
>         OS/Version: Linux
>               Tree: Mainline
>             Status: NEW
>           Severity: normal
>           Priority: P1
>          Component: Console/Framebuffers
>         AssignedTo: jsimmons@infradead.org
>         ReportedBy: francois.valenduc@tvcablenet.be
> 
> 
> Latest working kernel version: 2.6.25-git7
> Earliest failing kernel version: 2.6.25-git8
> Distribution: Gentoo
> Hardware Environment: Packard Bell MB86, Intel Core 2 Duo
> Software Environment:
> Problem Description:
> 
> uvesafb doesn't work anymore with the current git version. v86d failed with the
> following error:
> 
> Program v86d tried to access /dev/mem between a0000->110000.
> v86d[255]: segfault at 7f1025c22000 ip 400da6 sp 7fff2dc3e1d0 error 6 in
> v86d[400000+17000]
> uvesafb: Getting VBE info block failed (eax=0x4f00, err=-3)
> uvesafb: vbe_init() failed with -22
> uvesafb: probe of uvesafb.0 failed with error -22
> 
> After having tried git-bisect, it seems that the first bad commit which might
> cause the problem is the following:
> 
> commit e2beb3eae627211b67e456c53f946cede2ac10d7
> Author: Venki Pallipadi <venkatesh.pallipadi@intel.com>
> Date:   Thu Mar 6 23:01:47 2008 -0800
> 
>     devmem: add range_is_allowed() check to mmap of /dev/mem
>
> I have tried to revert it on the current git (git16) but it's not possible to
> do so.
> 
> Steps to reproduce:

Thanks for the report - it really helps.

Was you setting of CONFIG_NONPROMISC_DEVMEM the same in both -git7 and in
-git8?

