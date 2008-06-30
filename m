Return-Path: <linux-kernel-owner+w=401wt.eu-S1757975AbYF3Mhh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757975AbYF3Mhh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2008 08:37:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754071AbYF3Mh2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jun 2008 08:37:28 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:36657 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753146AbYF3Mh1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2008 08:37:27 -0400
Date: Mon, 30 Jun 2008 08:37:25 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Sven-Thorsten Dietrich <sven@thebigcorporation.com>
cc: Noah Watkins <noahwatkins@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
       RT <linux-rt-users@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       paulmck <paulmck@linux.vnet.ibm.com>
Subject: Re: [BUG RT] 2.6.25.8-rt7 on 8-way
In-Reply-To: <1214778205.13292.6.camel@dd.thebigcorporation.com>
Message-ID: <Pine.LNX.4.58.0806300835050.5403@gandalf.stny.rr.com>
References: <7618ba960806291432l20b7b6b5lea4b60bafa68c3bf@mail.gmail.com>
 <1214778205.13292.6.camel@dd.thebigcorporation.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sun, 29 Jun 2008, Sven-Thorsten Dietrich wrote:

>
> On Sun, 2008-06-29 at 16:32 -0500, Noah Watkins wrote:
> > My kernel is very, very noisy with the following bug:
> >
> > - Full dmesg below
> > - Please CC me
> >
>
> I found this as well (adding Paul).
>
> If you disable CONFIG_PREEMPT_RCU_BOOST, does it go away?
>

Turning off CONFIG_RCU_TRACE will also make it go away. The bug is that
the tracing of the RCU boost code uses smp_processor_id while the RCU
boost code is not in an atomic section.

Paul has a fix for this already, and will be out in the next releases.

-- Steve
