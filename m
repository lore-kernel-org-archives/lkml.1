Return-Path: <linux-kernel-owner+w=401wt.eu-S1757426AbYDMVwt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757426AbYDMVwt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Apr 2008 17:52:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755884AbYDMVwc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Apr 2008 17:52:32 -0400
Received: from keg.few.vu.nl ([130.37.24.4]:45288 "EHLO keg.few.vu.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754558AbYDMVw0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Apr 2008 17:52:26 -0400
Date: Sun, 13 Apr 2008 23:51:50 +0200 (CEST)
From: Erik Bosman <ejbosman@cs.vu.nl>
X-X-Sender: ebn310@keg.few.vu.nl
To: "H. Peter Anvin" <hpa@zytor.com>
cc: Arjan van de Ven <arjan@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       Andrea Arcangeli <andrea@cpushare.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] x86: Implement prctl PR_GET_TSC and PR_SET_TSC
In-Reply-To: <48012002.8030701@zytor.com>
Message-ID: <Pine.GSO.4.56.0804132320260.6537@keg.few.vu.nl>
References: <Pine.GSO.4.56.0804111855070.16669@keg.few.vu.nl>
 <20080412124947.146865e4@laptopd505.fenrus.org> <48012002.8030701@zytor.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 12 Apr 2008, H. Peter Anvin wrote:

>
> I also saw no mention about performance impact, which need to be
> considered whenever *anything* is proposed to be inserted into a hot
> path.  It may be (heck, *should be*) that the performance impact isn't
> measurable, but that needs to be positively established.
>
> 	-hpa
>

It took me a while, but I have done some tests om my system with and
without my patch applied.

All deamons but klogd/syslogd were shut down andI used the following
command:

LMBENCH_SCHED="SINGLE" \
/usr/lib/lmbench/bin/{i686-pc,x86_64}-linux-gnu/lat_ctx -s 0 2

The variation was quite high so I ran it a 1000 times for each
configuration.

x86_32, patch applied,     1000x repeated, avg: 1.319, rmse: 0.081
x86_32, patch not applied, 1000x repeated, avg: 1.335, rmse: 0.107

x86_64, patch applied,     1000x repeated, avg: 1.417, rmse: 0.0716
x86_64, patch not applied, 1000x repeated, avg: 1.423, rmse: 0.0745

This is on a core 2 duo E6300.

Erik
