Return-Path: <linux-kernel-owner+w=401wt.eu-S1753438AbZKNBY4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753438AbZKNBY4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Nov 2009 20:24:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753341AbZKNBYy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Nov 2009 20:24:54 -0500
Received: from mail-pz0-f171.google.com ([209.85.222.171]:34206 "EHLO
	mail-pz0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753339AbZKNBYx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Nov 2009 20:24:53 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=eu64GX5jL6gS1MnM1jeQUTdIb5+ye1r73HEJN4lg5NlaAy4fcMyZVVabfbFcgzifuf
         EcDmGo5iNCu90rSN4jQdfOMDjXirYlGMb7XB1iwVCaekqtykPnB6+mwHVhpBsaoFTvgm
         QyG/rwVnjdrQwqpcsufPFazfDjiZqDTNva5SA=
MIME-Version: 1.0
In-Reply-To: <1258071249.22249.72.camel@gandalf.stny.rr.com>
References: <a27c0c970911121552w63f63baew93d06336b39816a5@mail.gmail.com>
	 <1258071249.22249.72.camel@gandalf.stny.rr.com>
Date: Fri, 13 Nov 2009 17:24:59 -0800
X-Google-Sender-Auth: b2ba1df373555c31
Message-ID: <a27c0c970911131724o3ffb03d3sc58f1e78e17932b1@mail.gmail.com>
Subject: Re: RT wakeup woes in Linux 2.6.31.6 on Mac Mini
From: Greg Steuck <greg@nest.cx>
To: rostedt@goodmis.org
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Steven,

Thanks for your reply. I believe the answer to my outliers question is
- that's normal. I am lucky enough that 1ms delay is acceptable for my
project and so I can stick with vanilla kernel for now.

On Thu, Nov 12, 2009 at 4:14 PM, Steven Rostedt <rostedt@goodmis.org> wrote:
> Have you tried the -rt kernel?

I have now.

> I think you want "wakeup_rt", since that ignores SCHED_OTHER tasks.
> SCHED_OTHER may wake up poorly, and hide the results of your RT task.

Yes, done that now.

> Looks like NEED_RESCHED is set, but interrupts are disabled. This is
> typical for vanilla linux. I really suggest trying out the latest -rt
> patch.

With -rt9 I see a different set of interesting behaviors. I should
mention that my task needs to send network packets. So, I end up
trying to juggle priorities of  irq/27-eth0, sirq-net-rx/1 and my
rxtest tasks. If I make my task higher priority than the other two, I
get interrupts delayed (because my task is being a hog sometimes). If
I go the other way and my task gets lower priority, I end up with my
task not getting to run when there is a lot of network activity which
ultimately kills it.

Thanks
Greg
-- 
nest.cx is Gmail hosted, use PGP for anything private. Key:
http://tinyurl.com/ho8qg
Fingerprint: 5E2B 2D0E 1E03 2046 BEC3  4D50 0B15 42BD 8DF5 A1B0
