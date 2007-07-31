Return-Path: <linux-kernel-owner+w=401wt.eu-S1759109AbXGaLv1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759109AbXGaLv1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 07:51:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752540AbXGaLvL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 07:51:11 -0400
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:46621 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751805AbXGaLvJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 07:51:09 -0400
Date: Tue, 31 Jul 2007 13:48:24 +0200
From: =?UTF-8?B?U8OpYmFzdGllbiBEdWd1w6k=?= <sebastien.dugue@bull.net>
To: Josh Triplett <josht@linux.vnet.ibm.com>
Cc: Linux RT Users <linux-rt-users@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Jean Pierre Dion <jean-pierre.dion@bull.net>,
       Darren Hart <dvhltc@us.ibm.com>, john stultz <johnstul@us.ibm.com>
Subject: Re: [PATCH RT] Fix RT balancing tasks pulling
Message-ID: <20070731134824.6ec78447@frecb000686.frec.bull.fr>
In-Reply-To: <1185832234.3334.35.camel@josh-work.beaverton.ibm.com>
References: <20070724154202.224f12e8@frecb000686.frec.bull.fr>
	<1185832234.3334.35.camel@josh-work.beaverton.ibm.com>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.13; i486-pc-linux-gnu)
Mime-Version: 1.0
X-MIMETrack: Itemize by SMTP Server on ECN002/FR/BULL(Release 5.0.12  |February 13, 2003) at
 31/07/2007 13:55:56,
	Serialize by Router on ECN002/FR/BULL(Release 5.0.12  |February 13, 2003) at
 31/07/2007 13:55:57,
	Serialize complete at 31/07/2007 13:55:57
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


  Hi Josh,

On Mon, 30 Jul 2007 14:50:34 -0700 Josh Triplett <josht@linux.vnet.ibm.com> wrote:

> On Tue, 2007-07-24 at 15:42 +0200, Sébastien Dugué wrote:
> >   this one-liner fixes a bug in balance_rt_tasks() which sometimes manifests by
> > having a lower prio task being scheduled while a higher prio task is sitting
> > waiting on another runqueue.
> > 
> >   This is pretty hard to reproduce on low cpu count machines, for example, I
> > had to have sched_football run in a loop for ~38h before it failed on a dual HT
> > Xeon box.
> 
> Very impressive find, and this does seem to improve things in some
> cases.
> 
> However, with 2.6.22.1-rt8, which includes this patch, I still managed
> to get some failures after a few hours on an 8-way (quad dual-core) box.
> Preliminary results so far:
>     420 Final ball position: 0
>       2 Final ball position: 1
> 

  Darn, I thought it was it :(

  I had a ~60h run on my box with the very same kernel without a single
failure.

  Do you have any other user RT load running when those failures pop up?

  Anyway, back to scheduler code dissection now.

  Sébastien.
