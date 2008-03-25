Return-Path: <linux-kernel-owner+w=401wt.eu-S1757462AbYCYQls@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757462AbYCYQls (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2008 12:41:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753168AbYCYQlk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Mar 2008 12:41:40 -0400
Received: from mu-out-0910.google.com ([209.85.134.185]:43872 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752790AbYCYQlj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2008 12:41:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=TtbsBr5Mqk0mvkOW2rIjUdcoCL1OQ6xGdCcDK6TiQYS5MckuptwUJeGe0RX1NeNUNmQgnJBUby6Z4xOTxiwP6r7oMhfgFrTvaDfKg40hsZD2iAoyKiKu6gKe27B61J66t+YyKmljUvU4aq67tFiXlhvkc32K8D+RPV7MyIR/MGo=
Message-ID: <2c0942db0803250941j65be093et718bb838a2779e9c@mail.gmail.com>
Date: Tue, 25 Mar 2008 09:41:30 -0700
From: "Ray Lee" <ray-lk@madrabbit.org>
To: "Sanders, Rob M." <sanders-rob@zai.com>
Subject: Re: Performance changes between 2.6.13 and 2.6.23
Cc: linux-kernel@vger.kernel.org, bart.vanassche@gmail.com
In-Reply-To: <D108F32273D3044F8C7B24328CB7713701A4D1@york.rivers.zai.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <D108F32273D3044F8C7B24328CB7713701A4D1@york.rivers.zai.com>
X-Google-Sender-Auth: b4d3a4b436739cd3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 25, 2008 at 5:34 AM, Sanders, Rob M. <sanders-rob@zai.com> wrote:
> Hello all,
>   I've been lurking on the digest for some time (don't want to receive full lkml traffic at work) and saw the
>  posts about Wine performance regressions in 2.6.24.  Some of what I saw there, particularly Andi Kleen's
>  responses, mirror something that I see on my box at home.  I had emailed Andi directly since I only read the
>  digest, and I'm posting this here at his suggestion.  Please CC: rms@zai.com with any replies, as I'm only
>  getting the lkml digest.
>   I'm running on a dual 2GHZ G5 Powermac w/2GB ram.  I recently upgraded from YDL4.0.91 (2.6.13 kernel) to
>  YDL6 (2.6.23 kernel) and noticed that the overall performance of the box seems more sluggish after the upgrade.
>  Of more particular concern, the main application that I build has seen a 4-5X slowdown in performance.  Under
>  YDL4.0.91 I could process roughly 1e8 data points in ~2 seconds, and under YDL6.0 I now process 1e8 data points

So, two processors, and multiple processes passing data back and
forth. Key point seems to be:

>  in ~8 seconds.  Total CPU loading (from top) is about 5%, under both systems.  The application spawns multiple
>  processes and uses semaphores and shared memory to move data between the processes.  When I use 'vmstat 3' the
>  single biggest difference I see between YDL4.0.91 and YDL6 is that the YDL4.0.91 system is the YDL4.0.91 system is
>  context switching about 7000 per interval, whereas the YDl6 system is context switching about 1200 times per interval.

Many more context switches per second, so a lot less work is getting
done each time.

>   I've been talking somewhat with Owen Stampflee (works for the distro maker, TSS) and have rebuilt the kernel on
>  the 2.6 box removing some of the things that I don't need on my box (cell support, etc).  There did seem (subjectively)
>  to be a slight improvement after that.  When I get some more time to play at home I'm going to take the 2.6.13 .config
>  I use and build a 2.6.23 kernal using 'make oldconfig' and try to figure if it is a config issues.
>   I realize that going from 2.6.13 to 2.6.23 is a *huge* change, and that the problems may not be tied to the kernel
>  but to other things, but are there any other suggestions folks have for finding the cause of the performance slowdow

A lot has changed between 2.6.23 and current mainline as well.
Particularly in the scheduler, which I suspect is the issue for your
test. If possible, could you try a 2.6.25-rc-latest kernel, both
before and after an "echo 5 > /proc/sys/kernel/sched_features" and see
if that makes any difference?
