Return-Path: <linux-kernel-owner+w=401wt.eu-S2992883AbXEBIAG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992883AbXEBIAG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 04:00:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992894AbXEBIAE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 04:00:04 -0400
Received: from mail.gmx.net ([213.165.64.20]:49165 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S2992883AbXEBIAA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 04:00:00 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX199t+xWdXd9TzpIG0cyDWVRxAq76EufiS0+bsrcjW
	Ks2or2ba0PxOZy
Subject: Re: [patch] CFS scheduler, -v8
From: Mike Galbraith <efault@gmx.de>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Con Kolivas <kernel@kolivas.org>, Nick Piggin <npiggin@suse.de>,
       Arjan van de Ven <arjan@infradead.org>,
       Peter Williams <pwil3058@bigpond.net.au>,
       Thomas Gleixner <tglx@linutronix.de>, caglar@pardus.org.tr,
       Willy Tarreau <w@1wt.eu>, Gene Heskett <gene.heskett@gmail.com>,
       Mark Lord <lkml@rtr.ca>, Zach Carter <linux@zachcarter.com>,
       buddabrod <buddabrod@gmail.com>, Balbir Singh <balbir@in.ibm.com>
In-Reply-To: <20070501212223.GA29867@elte.hu>
References: <20070501212223.GA29867@elte.hu>
Content-Type: text/plain
Date: Wed, 02 May 2007 09:59:54 +0200
Message-Id: <1178092794.8926.43.camel@Homer.simpson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-05-01 at 23:22 +0200, Ingo Molnar wrote:
>  - interactivity: precise load calculation and load smoothing

This seems to help quite a bit.

(5 second top sample)

 2636 root      15  -5 19148  15m 5324 R   73  1.5   1:42.29 0 amarok_libvisua
 5440 root      20   0  320m  36m 8388 S   18  3.6   3:28.55 1 Xorg
 4621 root      20   0 22776  18m 4168 R   12  1.8   0:00.63 1 cc1
 4616 root      20   0 19456  13m 2200 R    9  1.3   0:00.43 0 cc1

I no longer have to renice both X and Gforce to achieve a perfect
display when they are sharing my box with a make -j2.  X is displaying
everything it's being fed beautifully with no help.  I have to renice
Gforce (amarok_libvisual), but given it's very heavy CPU usage, that
seems perfectly fine.

No regressions noticed so far.  Box is _very_ responsive under load,
seemingly even more so than with previous releases.  That is purely
subjective, but the first impression was very distinct.

	-Mike

