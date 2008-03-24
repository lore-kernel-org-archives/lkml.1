Return-Path: <linux-kernel-owner+w=401wt.eu-S1754100AbYCXUff@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754100AbYCXUff (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2008 16:35:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752483AbYCXUf1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Mar 2008 16:35:27 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:40639 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752234AbYCXUf0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2008 16:35:26 -0400
Date: Mon, 24 Mar 2008 16:35:23 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel@vger.kernel.org, linux-rt-users@vger.kernel.org
Subject: Re: [PATCH -rt] rt-slab: fix cpu inconsistency case
In-Reply-To: <47E41EDB.7030908@ct.jp.nec.com>
Message-ID: <Pine.LNX.4.58.0803241630290.9884@gandalf.stny.rr.com>
References: <47E2A63B.4020003@ct.jp.nec.com> <Pine.LNX.4.58.0803201519160.21990@gandalf.stny.rr.com>
 <47E2C4CC.5050401@ct.jp.nec.com> <Pine.LNX.4.58.0803211635160.3220@gandalf.stny.rr.com>
 <47E41EDB.7030908@ct.jp.nec.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 21 Mar 2008, Hiroshi Shimamoto wrote:
>
> >
> > Is this a bug in mainline? The !PREEMPT_RT case should be as close to
> > mainline as possible, with no actual changes in object code. If this is
> > not the case, then we need to fix that.
>
> No, this issue is in -rt only.
>

Hi Hiroshi,

Thanks again for reporting this. I took a deeper look into this today and
came to the conclusion that we need to get rid of both
slab_irq_disable_nort and slab_irq_disable_rt, and simply use
slab_irq_disable ;-)

This is what you patch indirectly does. I'll write up another patch to fix
this.

Thanks,

-- Steve

P.S. I'm hoping to get -rt4 out today.
