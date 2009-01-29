Return-Path: <linux-kernel-owner+w=401wt.eu-S1758547AbZA2CMh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758547AbZA2CMh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 21:12:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753216AbZA2CM0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 21:12:26 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55950 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751790AbZA2CMZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 21:12:25 -0500
Date: Wed, 28 Jan 2009 18:12:05 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Mike Travis <travis@sgi.com>, Ingo Molnar <mingo@redhat.com>,
       Dave Jones <davej@redhat.com>, cpufreq@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] work_on_cpu: Use our own workqueue.
Message-Id: <20090128181205.3b15fa4a.akpm@linux-foundation.org>
In-Reply-To: <200901291213.32959.rusty@rustcorp.com.au>
References: <20090116191108.135927000@polaris-admin.engr.sgi.com>
	<200901282332.29429.rusty@rustcorp.com.au>
	<20090128114440.77abc1b2.akpm@linux-foundation.org>
	<200901291213.32959.rusty@rustcorp.com.au>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 29 Jan 2009 12:13:32 +1030 Rusty Russell <rusty@rustcorp.com.au> wrote:

> On Thursday 29 January 2009 06:14:40 Andrew Morton wrote:
> > It's vulnerable to the same deadlock, I think?  Suppose we have:
> ...
> > - A calls work_on_cpu() and takes woc_mutex.
> > 
> > - Before function_which_takes_L() has started to execute, task B takes L
> >   then calls work_on_cpu() and task B blocks on woc_mutex.
> > 
> > - Now function_which_takes_L() runs, and blocks on L
> 
> Agreed, but now it's a fairly simple case.  Both sides have to take lock L, and both have to call work_on_cpu.
> 
> Workqueues are more generic and widespread, and an amazing amount of stuff gets called from them.  That's why I felt uncomfortable with removing the one known problematic caller.
> 

hm.  it's a bit of a timebomb.

y'know, the original way in which acpi-cpufreq did this is starting to
look attractive.  Migrate self to that CPU then just call the dang
function.  Slow, but no deadlocks (I think)?


