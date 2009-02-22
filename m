Return-Path: <linux-kernel-owner+w=401wt.eu-S1754079AbZBVUkd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754079AbZBVUkd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Feb 2009 15:40:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752462AbZBVUkZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Feb 2009 15:40:25 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:49096 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752441AbZBVUkY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Feb 2009 15:40:24 -0500
Date: Sun, 22 Feb 2009 21:39:33 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Rodolfo Giometti <giometti@linux.it>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       David Woodhouse <dwmw2@infradead.org>, Dave Jones <davej@redhat.com>,
       Sam Ravnborg <sam@ravnborg.org>, Greg KH <greg@kroah.com>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Kay Sievers <kay.sievers@vrfy.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Michael Kerrisk <mtk.manpages@gmail.com>,
       Christoph Hellwig <hch@infradead.org>,
       John Stultz <johnstul@us.ibm.com>
Subject: Re: [PATCH 1/1] LinuxPPS core support.
Message-ID: <20090222203933.GA18914@elte.hu>
References: <1234274752-29847-1-git-send-email-giometti@linux.it> <1234274752-29847-2-git-send-email-giometti@linux.it>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1234274752-29847-2-git-send-email-giometti@linux.it>
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


* Rodolfo Giometti <giometti@linux.it> wrote:

> This patch adds the kernel side of the PPS support currently 
> named "LinuxPPS".
> 
> PPS means "pulse per second" and a PPS source is just a device 
> which provides a high precision signal each second so that an 
> application can use it to adjust system clock time.
> 
> Common use is the combination of the NTPD as userland program 
> with a GPS receiver as PPS source to obtain a wallclock-time 
> with sub-millisecond synchronisation to UTC.

Hm. I was looking at this stuff with the prospect of adding it 
to the timer tree, but i'm really struggling with a few 
fundamental questions.

The most basic one is: why do we need this?

The main purpose of your current patchset seems to be to deliver 
interrupt timestamps to user-space, where it will in essence be 
used to feed new adjtimex adjustments via ntpd.

I.e. the whole thing comes around in a circle in the end, but 
via user-space, where jitter will only increase.

Why not cut out the jittery middle man and add some intelligent 
API to register PPS interrupt sources straight with the NTP 
code, and let those IRQ timestamps be fed _directly_ into our 
time adjustment code?

	Ingo
