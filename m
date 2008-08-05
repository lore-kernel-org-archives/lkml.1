Return-Path: <linux-kernel-owner+w=401wt.eu-S1763307AbYHEAnX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763307AbYHEAnX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 20:43:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756124AbYHEAnN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 20:43:13 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:54077 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754149AbYHEAnM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 20:43:12 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Robin Holt <holt@sgi.com>
Cc: Stephen Champion <schamp@sgi.com>, linux-kernel@vger.kernel.org,
       Pavel Emelyanov <xemul@openvz.org>, Oleg Nesterov <oleg@tv-sign.ru>,
       Sukadev Bhattiprolu <sukadev@us.ibm.com>,
       Paul Menage <menage@google.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
References: <20080731193204.GG9663@sgi.com>
	<m1iqul25rk.fsf@frodo.ebiederm.org> <20080731200835.GK9663@sgi.com>
	<m1bq0d1zhz.fsf@frodo.ebiederm.org> <20080801120455.GP9663@sgi.com>
	<m1proszj3r.fsf@frodo.ebiederm.org> <20080801191336.GK10501@sgi.com>
	<m14p64zetj.fsf@frodo.ebiederm.org> <4896FFFE.7080400@sgi.com>
	<m17iawy0tl.fsf@frodo.ebiederm.org> <20080804235838.GJ7290@sgi.com>
Date: Mon, 04 Aug 2008 17:38:56 -0700
In-Reply-To: <20080804235838.GJ7290@sgi.com> (Robin Holt's message of "Mon, 4
	Aug 2008 18:58:38 -0500")
Message-ID: <m163qgpa73.fsf@frodo.ebiederm.org>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-SA-Exim-Connect-IP: 24.130.11.59
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa01 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Robin Holt <holt@sgi.com>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	*  0.0 BAYES_50 BODY: Bayesian spam probability is 40 to 60%
	*      [score: 0.4821]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa01 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 XM_SPF_Neutral SPF-Neutral
Subject: Re: [Patch] Scale pidhash_shift/pidhash_size up based on num_possible_cpus().
X-SA-Exim-Version: 4.2 (built Thu, 03 Mar 2005 10:44:12 +0100)
X-SA-Exim-Scanned: Yes (on mgr1.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Robin Holt <holt@sgi.com> writes:

> But if we simply scale based upon num_possible_cpus(), we get a relatively
> representative scaling function.  Usually, customers buy machines with 1,
> 2, or 4GB per cpu.  I would expect a waste of 256k, 512k, or even 1m to
> be acceptable at this size of machine.

For your customers, and your kernel thread workload, you get a
reasonable representation.  For other different people and different
workloads you don't.  I happen to know of a completely different
class of workload that can do better.

> For 2.6.27, would you accept an upper cap based on the memory size
> algorithm you have now and adjusted for num_possible_cpus()?  Essentially
> the first patch I posted.

I want to throw a screaming hissy fit.

The merge window has closed.  This is not a bug.  This is not a
regression.  I don't see a single compelling reason to consider this
for 2.6.27.  I asked for clarification so I could be certain you were
solving the right problem.

Why didn't these patches show up 3 months ago when the last merge
window closed?  Why not even earlier?

I totally agree that what we are doing could be done better, however
at this point we should be looking at 2.6.28.  In which case looking
at the general long term non-hack solution is the right way to go.  Can
we scale to different workloads?

For everyone with less then 4K cpus the current behavior is fine, and
with 4k cpus it results in a modest slowdown.  This sounds useable.

You have hit an extremely sore spot with me.  Anytime someone makes an
argument that I hear as RHEL is going to ship 2.6.27 so we _need_ this
patch in 2.6.27 I want to stop listening.  I just don't care.  Unfortunately
I have heard that argument almost once a day for the last week, and I am
tired of it.

Why hasn't someone complained that waitpid is still slow?

Why haven't we seen patches to reduce the number of kernel threads since
last time you had problems with the pid infrastructure?

A very frustrated code reviewer.

So yes.  If you are not interested in 2.6.28 and in the general problem,
I'm not interested in this problem.

Eric
