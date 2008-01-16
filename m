Return-Path: <linux-kernel-owner+w=401wt.eu-S1751785AbYAPKKn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751785AbYAPKKn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2008 05:10:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751974AbYAPKKf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jan 2008 05:10:35 -0500
Received: from phoenix.clifford.at ([88.198.7.52]:39755 "EHLO
	phoenix.clifford.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751767AbYAPKKe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2008 05:10:34 -0500
Date: Wed, 16 Jan 2008 11:04:14 +0100
From: Clifford Wolf <clifford@clifford.at>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] rlim in proc/<pid>/status (2nd rev.)
Message-ID: <20080116100414.GA27576@clifford.at>
References: <20080115203659.GA5404@vino.hallyn.com> <20080116070346.GA24106@clifford.at> <20080116163045.11C8.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080116163045.11C8.KOSAKI.MOTOHIRO@jp.fujitsu.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wed, Jan 16, 2008 at 04:33:12PM +0900, KOSAKI Motohiro wrote:
> Hi Clifford,
> 
> > +static inline char *task_rlim(struct task_struct *p, char *buffer)
> > +{
> > +	unsigned long flags;
> > +	struct rlimit rlim[RLIM_NLIMITS];
> > +	int i;
> > +	
> > +	rcu_read_lock();
> > +	if (lock_task_sighand(p, &flags)) {
> > +		for (i=0; i<RLIM_NLIMITS; i++)
> > +			rlim[i] = p->signal->rlim[i];
> > +		unlock_task_sighand(p, &flags);
> > +	}
> 
> lock_task_sighand is possible return NULL?
> if so, rlim is uninitialized when NULL.

hmm.. can p->sighand be NULL here? If so, there also is a problem in the
task_sig() function in the same file.

In fact that code is copy&paste from task_sig(). In fact I'm not even sure
if I actually need to lock anything to access p->signal->rlim.. I've
searched the kernel code a bit and it looks like most acesses to the rlimits
are done unlocked, which is no problem imo given the typical change-pattern
of this values..

anyone a clue on this issues?

yours,
 - clifford

-- 
2B OR (NOT 2B) That is the question. The answer is FF.
