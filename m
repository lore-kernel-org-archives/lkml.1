Return-Path: <linux-kernel-owner+w=401wt.eu-S1757297AbYCKNYc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757297AbYCKNYc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2008 09:24:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752849AbYCKNYY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Mar 2008 09:24:24 -0400
Received: from one.firstfloor.org ([213.235.205.2]:34753 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752206AbYCKNYY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2008 09:24:24 -0400
Date: Tue, 11 Mar 2008 14:26:16 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Zdenek Kabelac <zdenek.kabelac@gmail.com>
Cc: Andi Kleen <andi@firstfloor.org>, Ingo Molnar <mingo@elte.hu>,
       tglx@linutronix.de, linux-kernel@vger.kernel.org, jkosina@suse.cz
Subject: Re: [PATCH REPOST] Run IST traps from user mode preemptive on process stack
Message-ID: <20080311132616.GH18917@one.firstfloor.org>
References: <20080311012432.GA28576@basil.nowhere.org> <c4e36d110803110503v3f25d852nf52ebdc709d73706@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c4e36d110803110503v3f25d852nf52ebdc709d73706@mail.gmail.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I'm not sure whether this is good or bad sign - but with this patch
> you have posted,
> I do not have to wait in qemu for minutes to get the 'busy-loop' - I
> get the exact same loop almost instantly when I start  disk read of LV
> partition and running my simple module insertion testcase.

Hmm, my fix was intended to fix a gdb problem. Or rather the gdb
problem was already fixed by disabling some functionality and with
this patch the functionality would be reenabled again.

If it fixed a qemu problem too that's great but was unintended
on my part. In fact it is a little worrying because there should
be no user visible change. Can you double check by unapply/test/reapply/test
the patch really makes a difference? 

> 
> >  This patch changes these traps instead to always switch
> >  to the process stack when the trap originated from user mode.
> >  For kernel traps it keeps running non preemptive on the IST stack
> >   because that is much safer (e.g. to still get nmi watchdog events
> >  out even when the process stack is corrupted)
> >
> 
> So what should I check to get fixed my problem in qemu ?

I don't know. Someone has to debug it.

-Andi
