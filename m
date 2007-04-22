Return-Path: <linux-kernel-owner+w=401wt.eu-S965606AbXDVJy2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965606AbXDVJy2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Apr 2007 05:54:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030181AbXDVJy1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Apr 2007 05:54:27 -0400
Received: from mail19.syd.optusnet.com.au ([211.29.132.200]:45426 "EHLO
	mail19.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965606AbXDVJy1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Apr 2007 05:54:27 -0400
From: Con Kolivas <kernel@kolivas.org>
To: Willy Tarreau <w@1wt.eu>
Subject: Re: [ANNOUNCE] Staircase Deadline cpu scheduler version 0.45
Date: Sun, 22 Apr 2007 19:53:24 +1000
User-Agent: KMail/1.9.5
Cc: linux kernel mailing list <linux-kernel@vger.kernel.org>,
       ck list <ck@vds.kolivas.org>, Ingo Molnar <mingo@elte.hu>,
       Mike Galbraith <efault@gmx.de>, Al Boldi <a1426z@gawab.com>,
       Peter Williams <pwil3058@bigpond.net.au>, Nick Piggin <npiggin@suse.de>,
       Matt Mackall <mpm@selenic.com>, Bill Huey <billh@gnuppy.monkey.org>,
       William Lee Irwin III <wli@holomorphy.com>,
       Gene Heskett <gene.heskett@gmail.com>
References: <200704221441.48897.kernel@kolivas.org> <200704221853.59358.kernel@kolivas.org> <20070422091451.GA15913@1wt.eu>
In-Reply-To: <20070422091451.GA15913@1wt.eu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704221953.25157.kernel@kolivas.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 22 April 2007 19:14, Willy Tarreau wrote:
> On Sun, Apr 22, 2007 at 06:53:58PM +1000, Con Kolivas wrote:
> > On Sunday 22 April 2007 18:06, Willy Tarreau wrote:
> > > On Sun, Apr 22, 2007 at 05:31:58PM +1000, Con Kolivas wrote:
> > > > On Sunday 22 April 2007 17:27, Con Kolivas wrote:
> > > > > On Sunday 22 April 2007 17:00, Willy Tarreau wrote:
> > > > > > On Sun, Apr 22, 2007 at 02:41:48PM +1000, Con Kolivas wrote:
> > > > > > > A significant bugfix for SMP balancing was just posted for the
> > > > > > > staircase deadline cpu scheduler which improves behaviour
> > > > > > > dramatically on any SMP machine.
> > > > > > >
> > > > > > > Thanks to Willy Tarreau for noticing likely fault point.
> > > > > > >
> > > > > > > Also requested was a version in the Makefile so this version of
> > > > > > > the patch adds -sd045 to the kernel version.
> > > > > >
> > > > > > Con, I'm sorry, but it is worse with this one :-(
> > > > >
> > > > > Well that was quick testing, thanks.
> > > > >
> > > > > > The lag when typing in xterms is even more noticeable and vmstat
> > > > > > output oscillates between 8 and 65, with idle rates around 50%,
> > > > > > as you can see below :
> > > > > >
> > > > > > Renicing X or not does not change anything here.
> > > > > >
> > > > > > I suspect that the bug you fixed was hiding another one :-/
> > > > > > If you want me to test another patch, feel free to ask.
> > > >
> > > > Just as a debug point could you please try this patch? Thanks.
> > >
> > > OK, this time, the ocbench took ages to start. They appeared
> > > immediately but very few of them (less than 8 out of 64) really started
> > > to work. The system remained very responsive and smooth during the
> > > test. But I guess I know why : all the load was sent to CPU 0 :
> >
> > Shouldn't have affected smp balancing at all, but try this on top of the
> > ontop please? Thanks
>
> Does not change anything. There clearly is a huge regression somewhere :-/
> The second CPU is not used by ocbench, and again, out of 64 tasks, only
> a small bunch (between 4 and 8) do something.
>
> Con, you should review the changes between 0.44 and 0.45, I think you
> introduced a bug which broke fairness while fixing another one.

Hmm; well it was "better" without the first debug patch I sent (even though it 
ws worse than 0.44) which is important in itself. I thank you greatly for 
your testing so far. Unfortunately I'm close to a one man code show so I'll 
have to spend time reviewing it further. The changes so far look ok still. 
Something else is lurking.

Thanks!

-- 
-ck
