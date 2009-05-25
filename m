Return-Path: <linux-kernel-owner+w=401wt.eu-S1753602AbZEYMNs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753602AbZEYMNs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 May 2009 08:13:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752074AbZEYMNm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 May 2009 08:13:42 -0400
Received: from mail-bw0-f174.google.com ([209.85.218.174]:60784 "EHLO
	mail-bw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751824AbZEYMNl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 May 2009 08:13:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=rDWiD0LAZ+5a3DaSgkAtKNnx4Smzj9v+Kn5BGiv7mG/0n3qWono+K+8yrT/WRb0Las
         0sPHS1gU7rFvUhmO2r2LYaETxDOfI9aXxstV0jQGqIGR8FieT8iqhWLp3JiLiV1bEPoi
         g9HMQKqYUM+JD1MU7s3oxfozuByLpu1m+h6M0=
MIME-Version: 1.0
In-Reply-To: <1243151839.26820.642.camel@twins>
References: <63386a3d0905112337p2d426481o5f9bf9b9489cc57e@mail.gmail.com>
	 <63386a3d0905231446h245bb4a9gec111f68a74a44e4@mail.gmail.com>
	 <1243151839.26820.642.camel@twins>
Date: Mon, 25 May 2009 14:13:41 +0200
Message-ID: <63386a3d0905250513q6ca56eeepcf7bebe46c447fb4@mail.gmail.com>
Subject: Re: [PATCH] U300 sched_clock implementation
From: Linus Walleij <linus.ml.walleij@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu,
       linux-arm-kernel@lists.arm.linux.org.uk
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/5/24 Peter Zijlstra <peterz@infradead.org>:

> On Sat, 2009-05-23 at 23:46 +0200, Linus Walleij wrote:
>
>> This overrides the global sched_clock() symbol in the Linux
>> scheduler with a local implementation which takes advantage of
>> the timesource in U300 giving a scheduling resolution of 1us. The
>> solution is the same as found in the OMAP2 core code.
>
> We assume sched_clock() to return time in ns (e-9) resolution.

Yep okay and in this case:

>> +       ret = (unsigned long long) u300_get_cycles();
>> +       ret = (ret * clocksource_u300_1mhz.mult_orig) >>
>> +               clocksource_u300_1mhz.shift;
>> +       return ret;

(mult_orig >> shift) == 1000

So for each cycle in cyclecount register we return 1000 * cycles
i.e 1000ns.

If it looks nicer we can of course simply:
return (unsigned long long) u300_get_cycles * 1000;

But the question here is whether this resolution is enough for
sched_clock() or if it is irrelevant to override sched_clock()
if it cannot schedule with better precision than 1000 ns.

Yours,
Linus Walleij
