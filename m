Return-Path: <linux-kernel-owner+w=401wt.eu-S1753730Ab0AZNL5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753730Ab0AZNL5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jan 2010 08:11:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753668Ab0AZNL4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jan 2010 08:11:56 -0500
Received: from mail-yx0-f187.google.com ([209.85.210.187]:62108 "EHLO
	mail-yx0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753535Ab0AZNLz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jan 2010 08:11:55 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=qjOzKjNPc3/5m2IsmI/NE+AhDvzmsMwrhI7fT8+2jRWYrz9oXDPvLzv5M568sdD9wg
         xSggZbm48t5HdBgdID2kC3l6y4ydK0l1RsSOm2f91ZaewJLsMZxj4VFb5f291bVXAzfv
         hIWHS2gKzMEUYf+jWE62VS+b8Sa+BVKg30gJ0=
Subject: Re: Hyperthreading on Core i7s: To use or not to use?
From: peng huang <huangpeng.linux@gmail.com>
To: Daniel J Blueman <daniel.blueman@gmail.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
       Justin Piszcz <jpiszcz@lucidpixels.com>
In-Reply-To: <6278d2221001260256q5f35457fye8baabcc333d40@mail.gmail.com>
References: <6278d2221001260256q5f35457fye8baabcc333d40@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 26 Jan 2010 22:11:52 +0900
Message-ID: <1264511512.29891.37.camel@huang-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I have been done some benchmark things on the processors with HT,
if you run lots of processes/threads that more than the physical 
cores,may be you should enable the HT to get more benefits.
#unless your processes cause some cache competitions. 

I will send you some test data later. 

-huang

2010-01-26 (火) の 10:56 +0000 に Daniel J Blueman さんは書きました:
> On Jan 26, 10:10 am, Justin Piszcz <jpiszcz@lucidpixels.com> wrote:
> > Hello,
> >
> > Should the 'correct' kernel [CPU] configuration for a core i7 860/870..?
> >
> > - Multi-core support
> > - Cores: 8
> > - SMT: Enabled/ON
> >
> > From CONFIG_SCHED_SMT:
> >
> >    . SMT scheduler support improves the CPU scheduler's decision making      .
> >    . when dealing with Intel Pentium 4 chips with HyperThreading at a        .
> >    . cost of slightly increased overhead in some places. If unsure say       .
> >    . N here.                                                                 .
> >
> > Does this also 'help' and/or 'apply' as much when dealing with Core i7s?
> >
> > --
> >
> > Quick little benchmark (pbzip2 -9 linux kernel source), the benchmark is
> > really within the noise (8 on/off)
> > - Multicore(8)/HT(Off) = 73.72user 0.33system 0:09.50elapsed 779%CPU (0avgtext+0avgdata 458528maxresident
> > - Multicore(8)/HT(On) = 74.28user 0.40system 0:09.67elapsed 772%CPU (0avgtext+0avgdata 428304maxresident
> > - Multicore(4)/HT(On) = 68.76user 0.30system 0:17.44elapsed 396%CPU (0avgtext+0avgdata 213616maxresident)k
> >
> > --
> >
> > Has anyone done any in-depth benchmarking for the core i7s that have multiple
> > cores and HT disabled/enabled?
> 
> With my Dell Studio 15 (model 1557) laptop, there is no option to
> disable HT in the current BIOS, so booting with maxcpus=4 (since the
> kernel enumerates non-sibling cores first) gave me a 5-15% speedup on
> some large image processing (convolution, FFTs, conversion) on all
> available cores, presumably due to better cache efficiency.
> 
> Booting with maxcpus=4 prevents any of the cores sitting in C6, needed
> for turbo-boost and a lower thermal profile, though I did find
> scheduling latency and responsiveness better under load booting with
> maxcpus=4, so favour this when plugged in.
> 
> Clearly, having the BIOS option allows benefit to certain applications
> - Dell should give their users the choice!
> 
> Perhaps the 'noht' boot option should be reintroduced to initialise
> all cores, but only expose non-sibling cores to the OS (thus allowing
> C6)?
> 
> Daniel
> 
> tip: modprobe msr and use turbostat to monitor turbo-boost and C-state
> residency: http://bugzilla.kernel.org/attachment.cgi?id=24673


-- 
peng huang <huangpeng.linux@gmail.com>

