Return-Path: <linux-kernel-owner+w=401wt.eu-S1752858AbZGXN0o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752858AbZGXN0o (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jul 2009 09:26:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752370AbZGXN0n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Jul 2009 09:26:43 -0400
Received: from qw-out-2122.google.com ([74.125.92.25]:50701 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751798AbZGXN0m convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jul 2009 09:26:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=chTWtQc7UBvfxazJB+wXtIXGsQ5fC284OG6IsmG8wFc3odhnYIOjlDp7slb5HI1SCD
         Gn4kIjIog9PCH8a46ulMtjPOnr7xqeeIotN8cwEvOBuKJcPsaBuAAPr2V8vqEsx86+i3
         Y9gtL7uV6UMfAUWtkvcqxit8SWeTFDh4Q0Whg=
MIME-Version: 1.0
In-Reply-To: <1248441290.6987.52.camel@twins>
References: <454c71700907240357l61f5c4fajaca73db0fba7db8@mail.gmail.com>
	 <1248437670.6987.26.camel@twins>
	 <454c71700907240604h4673f117j8ed58b9f2ee54798@mail.gmail.com>
	 <1248441290.6987.52.camel@twins>
Date: Fri, 24 Jul 2009 21:26:42 +0800
Message-ID: <454c71700907240626w127fd890ufa91ef90cbcaaa@mail.gmail.com>
Subject: Re: report a bug about sched_rt
From: sen wang <wangsen.linux@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: mingo@elte.hu, akpm@linux-foundation.org, kernel@kolivas.org,
       npiggin@suse.de, arjan@infradead.org,
       linux-arm-kernel@lists.arm.linux.org.uk, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

don't tell me what theory. don't be so doctrinairism! OK?
If cpu is free and there is a running state task,how can you scdedule
idle task up?
I tell you again:we are not talking about a bandwidth of 100% for RT!
Bug lies in the bandwidth of (100- X)%.(X<100)
even in the time of 100-X,if there is a rt task, you should not idle()
the system.


2009/7/24 Peter Zijlstra <peterz@infradead.org>:
> Don't top post -- again!
>
> On Fri, 2009-07-24 at 21:04 +0800, sen wang wrote:
>> Linux is used in many fieldes. SCHED_OTHER tasks is important to
>> embedded system.
>
> Irrelevant.
>
>> if there is a running state task（a realtime task）, how can we
>> shcedule the idle task up?
>
> Because it ran out of bandwidth.
>
>> It is ridiculous！
>>
>> since the throttle has a bug, why not fix it?
>
> It doesn't have a bug, therefore I won't fix it.
>
> The throttle limits the RT tasks to a bandwidth w of u/p.
> Since real-time scheduling is about determinism a maximum bandwidth
> larger than the minimum bandwidth specified by w is useless since it
> cannot be relied upon.
>
> Therefore we don't run RT tasks beyond their bandwidth limit.
>
> Go read up on scheduling theory.
>
> Now you might want a bandwidth of 100% for your RT application (not
> something I can recommend for the overall health of your machine) in
> which case you're free to change this setting:
>
>  echo -1 > /proc/sys/kernel/sched_rt_runtime_us
>
> Should do that for you. Also read:
>
>  Documentation/scheduler/sched-rt-group.txt
>
>
>
