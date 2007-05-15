Return-Path: <linux-kernel-owner+w=401wt.eu-S1759507AbXEODNb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759507AbXEODNb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2007 23:13:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752336AbXEODNY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 May 2007 23:13:24 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:59612 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752145AbXEODNX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2007 23:13:23 -0400
Date: Mon, 14 May 2007 20:12:32 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Benjamin LaHaise <bcrl@kvack.org>
Cc: Andi Kleen <ak@suse.de>, Christoph Lameter <clameter@sgi.com>,
       linux-kernel@vger.kernel.org, Chuck Ebbert <76306.1226@compuserve.com>
Subject: Re: oprofile broken in 2.6.21 SMP (was Re: Remove constructor from
 buffer_head)
Message-Id: <20070514201232.ad4768f9.akpm@linux-foundation.org>
In-Reply-To: <20070513203816.GI30571@kvack.org>
References: <Pine.LNX.4.64.0705032007540.16627@schroedinger.engr.sgi.com>
	<20070504134212.c18d2d65.akpm@linux-foundation.org>
	<20070504143347.9a1d6a34.akpm@linux-foundation.org>
	<200705050122.05275.ak@suse.de>
	<20070504164529.f64a2985.akpm@linux-foundation.org>
	<20070505093119.GC26000@wotan.suse.de>
	<20070513203816.GI30571@kvack.org>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 13 May 2007 16:38:16 -0400 Benjamin LaHaise <bcrl@kvack.org> wrote:

> On Sat, May 05, 2007 at 11:31:20AM +0200, Andi Kleen wrote:
> > Hmm, after a opcontrol --reset i see the same issue now. Don't know what's 
> > wrong, but it must be something different from the .20 perfctr allocation
> > problem.
> > 
> > It looks like the daemon doesn't get any data from the kernel
> 
> I finally had time to track this down.  The breakage is caused by "[PATCH] 
> x86-64: Let oprofile reserve MSR on all CPUs".  Oprofile is already calling 
> the reserve functions on each CPU in the system when it sets up the MSRs.  
> This results in oprofile getting a reservation failure on CPUs above 0.  The 
> following makes oprofile adapt to the API change for now -- oprofile 
> still needs to be modified to perform the reservations earlier during its 
> initialization, but that's a little bit more involved than the immediate 
> bug fix.  This only affects systems with more than 1 CPU.  This patch has 
> been through limited testing (Athlon 64 X2 and Core 2, but not on the P4) on 
> x86 and x86-64 (Core 2 only).

Unfortunately we've left this a bit too late - your patch is patching code which
isn't there any more in mainline and we also need a 2.6.21.x fix.

So perhaps we could merge your "immediate bugfix" into -stable and implement the
"more involved" fix for 2.6.22.

Andi, any preferences?
