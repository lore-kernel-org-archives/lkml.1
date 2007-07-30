Return-Path: <linux-kernel-owner+w=401wt.eu-S968793AbXG3Vu0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968793AbXG3Vu0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2007 17:50:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S967979AbXG3VuL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jul 2007 17:50:11 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:40753 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967923AbXG3VuJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2007 17:50:09 -0400
Subject: Re: [PATCH RT] Fix RT balancing tasks pulling
From: Josh Triplett <josht@linux.vnet.ibm.com>
To: =?ISO-8859-1?Q?S=E9bastien_Dugu=E9?= <sebastien.dugue@bull.net>
Cc: Linux RT Users <linux-rt-users@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Jean Pierre Dion <jean-pierre.dion@bull.net>,
       Darren Hart <dvhltc@us.ibm.com>, john stultz <johnstul@us.ibm.com>
In-Reply-To: <20070724154202.224f12e8@frecb000686.frec.bull.fr>
References: <20070724154202.224f12e8@frecb000686.frec.bull.fr>
Content-Type: text/plain; charset=utf-8
Date: Mon, 30 Jul 2007 14:50:34 -0700
Message-Id: <1185832234.3334.35.camel@josh-work.beaverton.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-07-24 at 15:42 +0200, Sébastien Dugué wrote:
>   this one-liner fixes a bug in balance_rt_tasks() which sometimes manifests by
> having a lower prio task being scheduled while a higher prio task is sitting
> waiting on another runqueue.
> 
>   This is pretty hard to reproduce on low cpu count machines, for example, I
> had to have sched_football run in a loop for ~38h before it failed on a dual HT
> Xeon box.

Very impressive find, and this does seem to improve things in some
cases.

However, with 2.6.22.1-rt8, which includes this patch, I still managed
to get some failures after a few hours on an 8-way (quad dual-core) box.
Preliminary results so far:
    420 Final ball position: 0
      2 Final ball position: 1

- Josh Triplett


