Return-Path: <linux-kernel-owner+w=401wt.eu-S1756458AbZA0Qw0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756458AbZA0Qw0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2009 11:52:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755430AbZA0QwQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Jan 2009 11:52:16 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47198 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754452AbZA0QwP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2009 11:52:15 -0500
Date: Tue, 27 Jan 2009 08:51:26 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Rusty Russell <rusty@rustcorp.com.au>, Mike Travis <travis@sgi.com>,
       Ingo Molnar <mingo@redhat.com>, Dave Jones <davej@redhat.com>,
       cpufreq@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] work_on_cpu: Use our own workqueue.
Message-Id: <20090127085126.730dd77a.akpm@linux-foundation.org>
In-Reply-To: <20090127152830.GA22373@elte.hu>
References: <20090116191108.135927000@polaris-admin.engr.sgi.com>
	<200901261711.43943.rusty@rustcorp.com.au>
	<20090125230130.bcdab2e5.akpm@linux-foundation.org>
	<200901271735.12034.rusty@rustcorp.com.au>
	<20090126232519.44f2943c.akpm@linux-foundation.org>
	<20090127152830.GA22373@elte.hu>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 27 Jan 2009 16:28:30 +0100 Ingo Molnar <mingo@elte.hu> wrote:

> 
> * Andrew Morton <akpm@linux-foundation.org> wrote:
> 
> > > But it's a general comment about fixing a general issue.  The 
> > > currently known case is not directly relevent; that it can happen and 
> > > it's restricting the use of this otherwise-general API is.
> > 
> > I think we should switch acpi-cpufreq to smp_call_function(), revert 
> > this stuff and ban the calling of work_on_cpu() under locks.
> 
> I agree that do_drv_read()/write() should be converted to 
> smp_function_call() (what it does is atomic: msr or PIO cycles).
> 
> Then work_on_cpu() can be removed for good, to not lure people into using 
> it. You seem to agree that work_on_cpu() is unfixable so it's far better 
> to offer nothing than to offer such a deceivingly named but fundamentally 
> limited facility.
> 

Well, I don't think it's unfixable.  But a full fix would, I think,
require a kernel thread for each callback invokation.  As dicussed
earlier, this could be optimised to only create the new kernel thread
if the keventd thread is presently off doing something else.

Is work_on_cpu() valuable enough to justify doing all that?  Dunno.
It appears to have six callers in three drivers at present, which is
quite a large number.

Or perhaps there's a smarter way of fixing it all.
