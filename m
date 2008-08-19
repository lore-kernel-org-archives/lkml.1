Return-Path: <linux-kernel-owner+w=401wt.eu-S1756244AbYHSK13@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756244AbYHSK13 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2008 06:27:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754046AbYHSK1E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Aug 2008 06:27:04 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:39204 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755252AbYHSK1B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2008 06:27:01 -0400
Date: Tue, 19 Aug 2008 12:26:33 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Rene Herman <rene.herman@keyaccess.nl>
Cc: Dave Airlie <airlied@gmail.com>, Shaohua Li <shaohua.li@intel.com>,
       Yinghai Lu <yhlu.kernel@gmail.com>,
       Andreas Herrmann <andreas.herrmann3@amd.com>,
       Arjan van de Ven <arjan@infradead.org>, dri-users@lists.sourceforge.net,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Suresh Siddha <suresh.b.siddha@intel.com>,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: AGP and PAT (induced?) problem (on AMD family 6)
Message-ID: <20080819102633.GE6722@elte.hu>
References: <48972EA8.8040001@keyaccess.nl> <20080815142218.GC12954@elte.hu> <48A59FAC.7050605@keyaccess.nl> <48AA9C3B.5030309@keyaccess.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48AA9C3B.5030309@keyaccess.nl>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Rene Herman <rene.herman@keyaccess.nl> wrote:

> On 15-08-08 17:24, Rene Herman wrote:
>
>> On 15-08-08 16:22, Ingo Molnar wrote:
>>
>>> (more people Cc:-ed)
>>
>> Thank you. Additional information at http://lkml.org/lkml/2008/8/6/449
>>
>>> agreed - +12 seconds wait suggest some rather fundamental breakage.
>>> Did we go back to uncached for some critical display area that makes
>>> X start up (shut down) that slowly? Did we mark the BIOS uncacheable
>>> perhaps, causing X to execute BIOS code very slowly?
>>
>> Quite a lot "uncached-minus" in those lists. I am desperately trying to 
>> avoid a clue about mostly anything graphics related so, "I dunno".
>>
>> I haven't just disabled PAT yet (although I was about to just do so) 
>> and am available for testing.
>
> <waiting with bated breath>
>
> Additional observation with respect to first,next shutdown:
>
> With Option "AGPSize" "64", and booted with "nopat", X startup (from 
> startx<enter> to functional desktop) is approximately 5 seconds, 
> shutdown is 1 second as calibration times.
>
> Booted without "nopat", X startup seems to alternate between 10+ and 
> 16+ seconds and for shutdown -- the first shutdown after boot takes 
> some 14 seconds total, subsequent shutdowns settle at around 5 
> seconds.

would it be possible to start up and shut down X in the slow case via 
strace, by doing something like this:

  strace -f -ttt -TTT -o trace.log startx

and see which system calls (or other activities) took suspiciously long?

	Ingo
