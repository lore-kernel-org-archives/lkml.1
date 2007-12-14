Return-Path: <linux-kernel-owner+w=401wt.eu-S1762873AbXLNKoS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762873AbXLNKoS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2007 05:44:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753895AbXLNKoD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Dec 2007 05:44:03 -0500
Received: from www.tglx.de ([62.245.132.106]:33443 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752497AbXLNKoB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2007 05:44:01 -0500
Date: Fri, 14 Dec 2007 11:43:37 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Jiri Slaby <jirislaby@gmail.com>
cc: Arun Thomas <arun.thomas@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: PROBLEM: E6850 has an 8+ minute delay during boot
In-Reply-To: <4762586F.8090603@gmail.com>
Message-ID: <alpine.LFD.0.99999.0712141140310.10584@localhost.localdomain>
References: <9a8cbed90712140110l156a34e3x38533b7710544cf8@mail.gmail.com>  <20071214015315.09829a99.akpm@linux-foundation.org> <9a8cbed90712140201r6cb287d9w99cc1210c68e8e60@mail.gmail.com> <4762586F.8090603@gmail.com>
User-Agent: Alpine 0.99999 (LFD 796 2007-11-08)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 14 Dec 2007, Jiri Slaby wrote:

> On 12/14/2007 11:01 AM, Arun Thomas wrote:
> > On Dec 14, 2007 4:53 AM, Andrew Morton <akpm@linux-foundation.org> wrote:
> >> On Fri, 14 Dec 2007 04:10:31 -0500 "Arun Thomas" <arun.thomas@gmail.com> wrote:
> >>
> 
> some time before:
> [   20.101392] Calibrating delay using timer specific routine..
> 5989.01 BogoMIPS (lpj=11978034)
> 
> >>> [   20.185881] Initializing CPU#1
> >>> [  527.926587] Calibrating delay using timer specific routine..
> >>> 200566.59 BogoMIPS (lpj=401133185)
> >> Silly question: is that delay actually observeable by a human,
> >> or is it just a leap in the printk timestamping?
> > 
> > Good question. Yes, it's human-observable. The kernel "hangs" for  8
> > mins by my wall clock, and then it continues to boot up.
> 
> By the way, the same processor here, but
> Calibrating delay using timer specific routine.. 5984.76 BogoMIPS (lpj=11969527)
> for the second core.
> 
> The calibration is some kind of weird there.
> 
> If any info needed from me, feel free to ask (x86_64 here). No problems with it
> here AFAIK.

The problem is caused by an SMI during the calibration routine. We
really need to come up with a solid solution which does not rely on
the periodic timer coming in, when there is something else (HPET,
pm_timer) available.

I have a look into this.

Arun, do you have an USB keyboard plugged in ? If not, can you connect
one and check, whether it changes things or not ?

Thanks,

	tglx

