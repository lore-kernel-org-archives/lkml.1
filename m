Return-Path: <linux-kernel-owner+w=401wt.eu-S1761229AbYFXOcG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761229AbYFXOcG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2008 10:32:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755727AbYFXObx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jun 2008 10:31:53 -0400
Received: from sinclair.provo.novell.com ([137.65.248.137]:42048 "EHLO
	sinclair.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753730AbYFXObw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2008 10:31:52 -0400
Message-Id: <4860CD140200005A0003944F@sinclair.provo.novell.com>
X-Mailer: Novell GroupWise Internet Agent 7.0.3 
Date: Tue, 24 Jun 2008 08:31:48 -0600
From: "Gregory Haskins" <GHaskins@novell.com>
To: <jbe@pengutronix.de>, <linux-rt-users@vger.kernel.org>
Cc: <mingo@elte.hu>, <rostedt@goodmis.org>, <tglx@linutronix.de>,
       <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.25.8-rt7
References: <4860CD0B0200005A0003944C@sinclair.provo.novell.com>
 <4860CD140200005A0003944F@sinclair.provo.novell.com>
In-Reply-To: <4860CD140200005A0003944F@sinclair.provo.novell.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(Sorry for toppost)

I believe this is my fault.  You must be building for uniprocessor?  Ingo has a fix for this issue in sched-devel that should be pulled into -rt.

Sorry for the inconvenience.  I will pull the patch myself and submit it when I get home (if someone doesn't beat me to it)

-greg 
-----Original Message-----
From: Juergen Beisert <jbe@pengutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>
To:  <linux-rt-users@vger.kernel.org>

Sent: 6/24/2008 8:15:49 AM
Subject: Re: 2.6.25.8-rt7

On Tuesday 24 June 2008 03:34, Steven Rostedt wrote:
> We are pleased to announce the 2.6.25.8-rt7 tree, which can be
> downloaded from the location:
>
>   http://rt.et.redhat.com/download/
>
> Information on the RT patch can be found at:
>
>   http://rt.wiki.kernel.org/index.php/Main_Page
>
> Changes since 2.6.25.4-rt6
>
>   - ported to 2.6.25.8
>
>   - rwlock pi_lock fixes on waking up multiple readers (Steven Rostedt)
>
>   - revert adaptive locks from RCU (Thomas Gleixner)
>      [ for some reason, using RCU causes some latency spikes, this
>        may be a sign of something going wrong in RCU itself ]
>
>   - rwlock mutex owner fix for waking up reader with readers held
>                                                   (Steven Rostedt)
>
>   - rwlock remove waiter from pi_list on above fix (Steven Rostedt and
>                                                     Thomas Gleixner)
>
>   - rwlock replace macro with inline (Thomas Gleixner)
>
>   - rwlock pending namespace updates (Thomas Gleixner)
>
>   - futex fix fault (Thomas Gleixner)
>
> to build a 2.6.25.8-rt7 tree, the following patches should be applied:
>
>   http://www.kernel.org/pub/linux/kernel/v2.6/linux-2.6.25.tar.bz2
>   http://kernel.org/pub/linux/kernel/v2.6/patch-2.6.25.8.bz2
>   http://rt.et.redhat.com/download/patch-2.6.25.8-rt7.bz2

This occurs when I try to build a PowerPC (MPC5200) kernel:

[...]
In file included from kernel/sched.c:1318:
kernel/sched.c: In function 'sched_init':
kernel/sched.c:7702: error: implicit declaration of function 'global_rt_runtime'
[...]

And when I'm using the patch from Uli Brueggemann to fix it, I get:

[...]
In file included from kernel/sched.c:1325:
kernel/sched_rt.c: In function 'inc_rt_tasks':
kernel/sched_rt.c:290: error: 'struct rq' has no member named 'online'
[...]

Any hints?

Juergen Beisert

-- 
Dipl.-Ing. Juergen Beisert | http://www.pengutronix.de
 Pengutronix - Linux Solutions for Science and Industry
    Handelsregister: Amtsgericht Hildesheim, HRA 2686
         Vertretung Sued/Muenchen, Germany
   Phone: +49-8766-939 228 |  Fax: +49-5121-206917-9
--
To unsubscribe from this list: send the line "unsubscribe linux-rt-users" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

