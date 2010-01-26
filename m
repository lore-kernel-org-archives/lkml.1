Return-Path: <linux-kernel-owner+w=401wt.eu-S1753085Ab0AZK5A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753085Ab0AZK5A (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jan 2010 05:57:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752366Ab0AZK47
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jan 2010 05:56:59 -0500
Received: from ey-out-2122.google.com ([74.125.78.26]:28845 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751845Ab0AZK46 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jan 2010 05:56:58 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=CtOkaOzMzHF9WK0TQpG4PW3zTFopCtOAaOugVE8EjpGSCAPHpRG3YMyNBVHs8ewdXb
         j1BrnW+Lw2yYkhZZ3a+ebxVuBf+Rm9GkX32EIRsGYw581Vi7cFFuqLKjcADg4jpFGfx6
         aD12xFpnnquBrmfBL7YBfu2FR1uPI/PsE6h48=
MIME-Version: 1.0
Date: Tue, 26 Jan 2010 10:56:57 +0000
Message-ID: <6278d2221001260256q5f35457fye8baabcc333d40@mail.gmail.com>
Subject: Re: Hyperthreading on Core i7s: To use or not to use?
From: Daniel J Blueman <daniel.blueman@gmail.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>,
       Justin Piszcz <jpiszcz@lucidpixels.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jan 26, 10:10 am, Justin Piszcz <jpiszcz@lucidpixels.com> wrote:
> Hello,
>
> Should the 'correct' kernel [CPU] configuration for a core i7 860/870..?
>
> - Multi-core support
> - Cores: 8
> - SMT: Enabled/ON
>
> From CONFIG_SCHED_SMT:
>
>    . SMT scheduler support improves the CPU scheduler's decision making      .
>    . when dealing with Intel Pentium 4 chips with HyperThreading at a        .
>    . cost of slightly increased overhead in some places. If unsure say       .
>    . N here.                                                                 .
>
> Does this also 'help' and/or 'apply' as much when dealing with Core i7s?
>
> --
>
> Quick little benchmark (pbzip2 -9 linux kernel source), the benchmark is
> really within the noise (8 on/off)
> - Multicore(8)/HT(Off) = 73.72user 0.33system 0:09.50elapsed 779%CPU (0avgtext+0avgdata 458528maxresident
> - Multicore(8)/HT(On) = 74.28user 0.40system 0:09.67elapsed 772%CPU (0avgtext+0avgdata 428304maxresident
> - Multicore(4)/HT(On) = 68.76user 0.30system 0:17.44elapsed 396%CPU (0avgtext+0avgdata 213616maxresident)k
>
> --
>
> Has anyone done any in-depth benchmarking for the core i7s that have multiple
> cores and HT disabled/enabled?

With my Dell Studio 15 (model 1557) laptop, there is no option to
disable HT in the current BIOS, so booting with maxcpus=4 (since the
kernel enumerates non-sibling cores first) gave me a 5-15% speedup on
some large image processing (convolution, FFTs, conversion) on all
available cores, presumably due to better cache efficiency.

Booting with maxcpus=4 prevents any of the cores sitting in C6, needed
for turbo-boost and a lower thermal profile, though I did find
scheduling latency and responsiveness better under load booting with
maxcpus=4, so favour this when plugged in.

Clearly, having the BIOS option allows benefit to certain applications
- Dell should give their users the choice!

Perhaps the 'noht' boot option should be reintroduced to initialise
all cores, but only expose non-sibling cores to the OS (thus allowing
C6)?

Daniel

tip: modprobe msr and use turbostat to monitor turbo-boost and C-state
residency: http://bugzilla.kernel.org/attachment.cgi?id=24673
-- 
Daniel J Blueman
