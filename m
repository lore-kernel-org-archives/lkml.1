Return-Path: <linux-kernel-owner+w=401wt.eu-S1759753AbYFXORV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759753AbYFXORV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2008 10:17:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759451AbYFXOQc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jun 2008 10:16:32 -0400
Received: from metis.extern.pengutronix.de ([83.236.181.26]:42212 "EHLO
	metis.extern.pengutronix.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758751AbYFXOQD convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2008 10:16:03 -0400
From: Juergen Beisert <jbe@pengutronix.de>
Organization: Pengutronix - Linux Solutions for Science and Industry
To: linux-rt-users@vger.kernel.org
Date: Tue, 24 Jun 2008 16:15:49 +0200
User-Agent: KMail/1.9.4
Cc: Steven Rostedt <rostedt@goodmis.org>, LKML <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
References: <1214271257.8701.17.camel@localhost.localdomain>
In-Reply-To: <1214271257.8701.17.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200806241615.49876.jbe@pengutronix.de>
X-SA-Exim-Connect-IP: 83.236.181.29
X-SA-Exim-Mail-From: jbe@pengutronix.de
Subject: Re: 2.6.25.8-rt7
X-SA-Exim-Version: 4.2.1 (built Tue, 09 Jan 2007 17:23:22 +0000)
X-SA-Exim-Scanned: Yes (on metis.extern.pengutronix.de)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
