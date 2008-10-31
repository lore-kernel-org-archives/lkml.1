Return-Path: <linux-kernel-owner+w=401wt.eu-S1752504AbYJaN5J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752504AbYJaN5J (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2008 09:57:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751365AbYJaN44
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Oct 2008 09:56:56 -0400
Received: from relay2.sgi.com ([192.48.179.30]:57294 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751368AbYJaN4z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2008 09:56:55 -0400
X-Greylist: delayed 644 seconds by postgrey-1.27 at vger.kernel.org; Fri, 31 Oct 2008 09:56:55 EDT
Date: Fri, 31 Oct 2008 08:46:06 -0500
From: Dimitri Sivanich <sivanich@sgi.com>
To: Steven Noonan <steven@uplinklabs.net>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] small optimization to update_curr_rt
Message-ID: <20081031134606.GA12193@sgi.com>
References: <20081031130341.GA12018@sgi.com> <f488382f0810310610n20a13163pb0936a3104e64a5c@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f488382f0810310610n20a13163pb0936a3104e64a5c@mail.gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 31, 2008 at 06:10:13AM -0700, Steven Noonan wrote:
> On Fri, Oct 31, 2008 at 6:03 AM, Dimitri Sivanich <sivanich@sgi.com> wrote:
> > A very minor improvement, but might it be better to check sched_rt_runtime(rt_rq)
> > before taking the rt_runtime_lock?
> 
> Is it possible that the attribute sched_rt_runtime is checking could
> change by the time it acquires the lock? If not, should be fine, I
> think.
>

Steve,

While it might be possible for it to change in that instant, I don't know if it matters.

If the runtime value should change to RUNTIME_INF in that instant, it will be caught in sched_rt_runtime_exceeded().  If it changed from RUNTIME_INF to a lower value, I doubt it would matter much, as at most one more rt_rq value wouldn't be checked.  Either way some rt_rq values would have been checked during the loop and some would not.
