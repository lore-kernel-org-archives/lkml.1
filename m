Return-Path: <linux-kernel-owner+w=401wt.eu-S1752363Ab0AQNAw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752363Ab0AQNAw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jan 2010 08:00:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751970Ab0AQNAv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jan 2010 08:00:51 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:59699 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751946Ab0AQNAu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jan 2010 08:00:50 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=YJsACwsvtrpmOMh8BT2E4bLv1ThqkGx1sfo6kOEL2Z99bfT3qL9YhtyQ7BUa5x+w0q
         wB+yykaDGyzIyzFo5DZsrQG2kPXkesyV1su2n9UCzjIdrNfy7CeGJ37pmBvwcMUQs7L6
         RiOvmiJc7Gm2W68wL7APAmOu0+CJjh8FHjaLg=
Date: Sun, 17 Jan 2010 14:00:46 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: John Kacur <jkacur@redhat.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, Thomas Gleixner <tglx@linutronix.de>,
       lkml <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Clark Williams <williams@redhat.com>
Subject: Re: [PATCH 14/26] trace: Convert various locks to raw_spinlock
Message-ID: <20100117130044.GE5035@nowhere>
References: <1263245216-14754-11-git-send-email-jkacur@redhat.com> <1263245216-14754-12-git-send-email-jkacur@redhat.com> <1263245216-14754-13-git-send-email-jkacur@redhat.com> <1263245216-14754-14-git-send-email-jkacur@redhat.com> <1263245216-14754-15-git-send-email-jkacur@redhat.com> <20100112033931.GF5243@nowhere> <20100113152824.GA15301@goodmis.org> <alpine.LFD.2.00.1001131632350.5665@localhost.localdomain> <1263397315.28171.3827.camel@gandalf.stny.rr.com> <alpine.LFD.2.00.1001131907560.5665@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1001131907560.5665@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 13, 2010 at 07:09:22PM +0100, John Kacur wrote:
> 
> 
> On Wed, 13 Jan 2010, Steven Rostedt wrote:
> 
> > On Wed, 2010-01-13 at 16:36 +0100, John Kacur wrote:
> > > 
> > > On Wed, 13 Jan 2010, Steven Rostedt wrote:
> > 
> > > > 
> > > Thanks for the review Steve and Frederic - I'll spin a new patch that 
> > > doesn't convert tracing_start_lock.
> > > 
> > > However, let's give it some good testing in preempt-rt, because we may 
> > > have forgotten over time, why we converted these locks.
> > 
> > Well, I think we just never unconverted them :-)  I think we took the
> > paranoid approach and converted all locks in the trace directory to raw.
> > In fact, I think I even had a script to do it.
> > 
> > -- Steve
> 
> Okay, here is the new version of the patch.
> Frederic and Steve, can I have Acked-bys before I push to git?
> 
> Thanks
> 
> From ee03cc607493e58f34bf93afa2b8a23da5510927 Mon Sep 17 00:00:00 2001
> From: John Kacur <jkacur@redhat.com>
> Date: Sun, 10 Jan 2010 03:09:48 +0100
> Subject: [PATCH] trace: Convert reader_lock and max_trace_lock to raw_spinlocks
> 
> Convert reader_lock and max_trace_lock to raw_spinlock.
> These locks cannot sleep in preempt-rt because they are called with
> interrupts disabled. This should have zero-impact on mainline.
> 
> See also: 87654a70523a8c5baadcbbc07d80cbae8f912837
> 
> Signed-off-by: John Kacur <jkacur@redhat.com>



Acked-by: Frederic Weisbecker <fweisbec@gmail.com>

