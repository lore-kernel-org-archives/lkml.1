Return-Path: <linux-kernel-owner+w=401wt.eu-S1760463AbXESJ4R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760463AbXESJ4R (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 May 2007 05:56:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754767AbXESJ4I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 May 2007 05:56:08 -0400
Received: from d06184ca.dreamhost.com ([208.97.132.202]:41128 "EHLO
	spaceymail-a3.g.dreamhost.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754560AbXESJ4H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 May 2007 05:56:07 -0400
From: Anant Nitya <kernel@prachanda.info>
Organization: Prachanda Hub
To: linux-kernel@vger.kernel.org
Subject: Re: [BUG] local_softirq_pending storm
Date: Sat, 19 May 2007 15:25:27 +0530
User-Agent: KMail/1.9.6
Cc: Thomas Gleixner <tglx@linutronix.de>
References: <200705091942.22920.kernel@prachanda.hub> <200705171211.23350.kernel@prachanda.hub> <1179493277.12981.69.camel@chaos>
In-Reply-To: <1179493277.12981.69.camel@chaos>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705191525.28400.kernel@prachanda.hub>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 18 May 2007 18:31:17 Thomas Gleixner wrote:
> On Thu, 2007-05-17 at 12:11 +0530, Anant Nitya wrote:
> > On Friday 11 May 2007 03:28:46 Thomas Gleixner wrote:
> > > Ok, that's consistent with earlier reports. The problem surfaces when
> > > one of the SMT-"cpus" goes idle. The problem goes away when you disable
> > > hyperthreading.
> >
> > Yes with HT disabled in BIOS there is no local_softirq_pending messages.
> > BTW why does this problem persist only with X ?
>
> No idea. I uploaded a debug patch against 2.6.22-rc1 to
>
> http://www.tglx.de/private/tglx/2.6.22-rc1-hrt-debug.patch
>
> Can you give it a try and report the output ?
Hi
Here it goes 
[  159.646196] NOHZ softirq pending 22 on CPU 0
[  159.646207] .... task state: 1 00000000
[  159.646217] .... last caller: __tasklet_schedule
[  159.646997] NOHZ softirq pending 22 on CPU 0
[  159.647006] .... task state: 1 00000000
[  159.647013] .... last caller: __tasklet_schedule
[  159.647398] NOHZ softirq pending 22 on CPU 0
[  159.647405] .... task state: 1 00000000
[  159.647412] .... last caller: __tasklet_schedule
[  159.647768] NOHZ softirq pending 22 on CPU 0
[  159.647775] .... task state: 1 00000000
[  159.647781] .... last caller: __tasklet_schedule
[  166.285664] NOHZ softirq pending 22 on CPU 0
[  166.285675] .... task state: 1 00000000
[  166.285687] .... last caller: raise_softirq
[  166.286321] NOHZ softirq pending 22 on CPU 0
[  166.286329] .... task state: 1 00000000
[  166.286337] .... last caller: raise_softirq
[  166.286715] NOHZ softirq pending 22 on CPU 0
[  166.286722] .... task state: 1 00000000
[  166.286729] .... last caller: raise_softirq
[  166.287085] NOHZ softirq pending 22 on CPU 0
[  166.287092] .... task state: 1 00000000
[  166.287098] .... last caller: raise_softirq
[  171.512134] NOHZ softirq pending 22 on CPU 0
[  171.512144] .... task state: 1 00000000
[  171.512154] .... last caller: __tasklet_schedule
[  171.512712] NOHZ softirq pending 22 on CPU 0
[  171.512720] .... task state: 1 00000000
[  171.512727] .... last caller: __tasklet_schedule

Regards
Ananitya

