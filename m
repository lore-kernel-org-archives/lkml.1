Return-Path: <linux-kernel-owner+w=401wt.eu-S1422708AbXCBBlN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422708AbXCBBlN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2007 20:41:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422709AbXCBBlN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Mar 2007 20:41:13 -0500
Received: from mail26.syd.optusnet.com.au ([211.29.133.167]:38081 "EHLO
	mail26.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1422708AbXCBBlM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2007 20:41:12 -0500
From: Con Kolivas <kernel@kolivas.org>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] sched: remove SMT nice
Date: Fri, 2 Mar 2007 12:25:09 +1100
User-Agent: KMail/1.9.5
Cc: Ingo Molnar <mingo@elte.hu>, tglx@linutronix.de,
       Mike Galbraith <efault@gmx.de>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       Adrian Bunk <bunk@stusta.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
References: <Pine.LNX.4.64.0702202043280.4043@woody.linux-foundation.org> <200703020933.37590.kernel@kolivas.org> <20070301173002.456f9534.akpm@linux-foundation.org>
In-Reply-To: <20070301173002.456f9534.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703021225.10083.kernel@kolivas.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 02 March 2007 12:30, Andrew Morton wrote:
> On Fri, 2 Mar 2007 09:33:37 +1100
>
> Con Kolivas <kernel@kolivas.org> wrote:
> > Remove the SMT-nice feature which idles sibling cpus on SMT cpus to
> > facilitiate nice working properly where cpu power is shared. The idling
> > of cpus in the presence of runnable tasks is considered too fragile, easy
> > to break with outside code, and the complexity of managing this system if
> > an architecture comes along with many logical cores sharing cpu power
> > will be unworkable.
> >
> > Remove the associated per_cpu_gain variable in sched_domains used only by
> > this code.
>
> Seems like a somewhat serious step.  Is this urgent enough for 2.6.21?
> If so, why?  The mysql thing?

No, Nish showed improvement in fact with SCHED_SMT enabled so this is 
unrelated. 

The reason is that with dynticks enabled, this code breaks without yet further 
tweaks so dynticks brought on the rapid demise of this code. So either we 
tweak this code or kill it off entirely. It was Ingo's preference to kill it 
off. Either way this needs to happen for 2.6.21 since dynticks has gone in.

-- 
-ck
