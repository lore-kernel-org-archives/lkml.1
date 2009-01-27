Return-Path: <linux-kernel-owner+w=401wt.eu-S1753653AbZA0HGG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753653AbZA0HGG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2009 02:06:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751987AbZA0HFz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Jan 2009 02:05:55 -0500
Received: from ozlabs.org ([203.10.76.45]:38905 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751968AbZA0HFx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2009 02:05:53 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 2/3] work_on_cpu: Use our own workqueue.
Date: Tue, 27 Jan 2009 17:35:11 +1030
User-Agent: KMail/1.10.3 (Linux/2.6.27-9-generic; KDE/4.1.3; i686; ; )
Cc: Mike Travis <travis@sgi.com>, Ingo Molnar <mingo@redhat.com>,
       Dave Jones <davej@redhat.com>, cpufreq@vger.kernel.org,
       linux-kernel@vger.kernel.org
References: <20090116191108.135927000@polaris-admin.engr.sgi.com> <200901261711.43943.rusty@rustcorp.com.au> <20090125230130.bcdab2e5.akpm@linux-foundation.org>
In-Reply-To: <20090125230130.bcdab2e5.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901271735.12034.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 26 January 2009 17:31:30 Andrew Morton wrote:
> On Mon, 26 Jan 2009 17:11:43 +1030 Rusty Russell <rusty@rustcorp.com.au> wrote:
> 
> > On Saturday 24 January 2009 18:45:37 Andrew Morton wrote:
> > > Pity the poor reader who comes along trying to work out why this exists.
> 
> (chirp, chirp)

I disagree.  It's simple; we create a workqueue and we use it.  There's no
confusion here.

> > None of these options are appealing...
> 
> Can we try harder please?  10 screenfuls of kernel threads in the ps
> output is just irritating.
> 
> How about banning the use of work_on_cpu() from schedule_work()
> handlers and then fixing that driver somehow?

Again, that's how we got here in the first place.  I didn't realize the
twisty path by which the acpi cpufreq code could be called.  And there
may well be others.  So I want work_on_cpu to be completely generic.

Using the existing infrastructure seemed like the right thing.

But since you asked nicely, I'll come up with something cleverer.  It'll
take some serious testing though.

> What _is_ the bug anyway?

There is no "bug".  See the commit message.

> The only description we were given was
> 
>   Impact: remove potential clashes with generic kevent workqueue
> 
>   Annoyingly, some places we want to use work_on_cpu are already in
>   workqueues.  As per Ingo's suggestion, we create a different
>   workqueue for work_on_cpu.
> 
> which didn't bother telling anyone squat.

Well, it could have referred to the currently-known case:
arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c should be using work_on_cpu,
but we reverted the change because of this problem.

But it's a general comment about fixing a general issue.  The currently
known case is not directly relevent; that it can happen and it's restricting
the use of this otherwise-general API is.

> When was this bug added?  Was it added into that driver or was it due
> to infrastructural changes?

I'm not hiding a bug from you.  Really.

A little confused at all this vitriol,
Rusty.
