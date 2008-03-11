Return-Path: <linux-kernel-owner+w=401wt.eu-S1755587AbYCKN6m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755587AbYCKN6m (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2008 09:58:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752218AbYCKN6c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Mar 2008 09:58:32 -0400
Received: from wx-out-0506.google.com ([66.249.82.234]:56863 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752065AbYCKN6c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2008 09:58:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=sFJLFhnSybyLkSVt2Z/ATWk6eebRVL0rc0vbzCMpcCVP6fp9m2YQFbhWti78sq4f9dGkw6vCcpatVdrkyz08E65eyf6cH0b75laRuZwbEAywHW9EzJnTlpMswxvt1mtHblmBryrE9ptCpFoinhCm4o9gcnZrq8+uAwZNAw4ZltE=
Message-ID: <c4e36d110803110658k276c5c63x2d3703b4741a4d05@mail.gmail.com>
Date: Tue, 11 Mar 2008 14:58:30 +0100
From: "Zdenek Kabelac" <zdenek.kabelac@gmail.com>
To: "Andi Kleen" <andi@firstfloor.org>
Subject: Re: [PATCH REPOST] Run IST traps from user mode preemptive on process stack
Cc: "Ingo Molnar" <mingo@elte.hu>, tglx@linutronix.de,
       linux-kernel@vger.kernel.org, jkosina@suse.cz
In-Reply-To: <20080311132616.GH18917@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080311012432.GA28576@basil.nowhere.org>
	 <c4e36d110803110503v3f25d852nf52ebdc709d73706@mail.gmail.com>
	 <20080311132616.GH18917@one.firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/3/11, Andi Kleen <andi@firstfloor.org>:
> > I'm not sure whether this is good or bad sign - but with this patch
>  > you have posted,
>  > I do not have to wait in qemu for minutes to get the 'busy-loop' - I
>  > get the exact same loop almost instantly when I start  disk read of LV
>  > partition and running my simple module insertion testcase.
>
>
> Hmm, my fix was intended to fix a gdb problem. Or rather the gdb
>  problem was already fixed by disabling some functionality and with
>  this patch the functionality would be reenabled again.
>
>  If it fixed a qemu problem too that's great but was unintended
>  on my part. In fact it is a little worrying because there should
>  be no user visible change. Can you double check by unapply/test/reapply/test
>  the patch really makes a difference?

I've not said it has 'fixed' my problem - I said it has exposed the
problem much faster.
But now when I've made a double test - I think I was wrong - I've been
probably judging too fast and its also probably depending on the
sunlight position, but now I can see that even with recent git kernel
without your patch I get the busy loop pretty quick :(.

>  > >  This patch changes these traps instead to always switch
>  > >  to the process stack when the trap originated from user mode.
>  > >  For kernel traps it keeps running non preemptive on the IST stack
>  > >   because that is much safer (e.g. to still get nmi watchdog events
>  > >  out even when the process stack is corrupted)
>  > >
>  >
>  > So what should I check to get fixed my problem in qemu ?
>
>
> I don't know. Someone has to debug it.

But who :) ?

Zdenek
