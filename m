Return-Path: <linux-kernel-owner+w=401wt.eu-S1763307AbXK2V1G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763307AbXK2V1G (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2007 16:27:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758979AbXK2V0t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Nov 2007 16:26:49 -0500
Received: from hobbit.corpit.ru ([81.13.94.6]:23183 "EHLO hobbit.corpit.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758786AbXK2V0t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2007 16:26:49 -0500
Message-ID: <474F2E97.5080802@msgid.tls.msk.ru>
Date: Fri, 30 Nov 2007 00:26:47 +0300
From: Michael Tokarev <mjt@tls.msk.ru>
Organization: Telecom Service, JSC
User-Agent: Icedove 1.5.0.14pre (X11/20071018)
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: =?UTF-8?B?IlBhdWwgUm9sbGFuZCAo44Od44O844Or44O744Ot44Op44OzKSI=?= 
	<rol@witbe.net>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: constant_tsc and TSC unstable
References: <20071129171142.56c7890a@tux.DEF.witbe.net> <474F0D47.7020006@zytor.com>
In-Reply-To: <474F0D47.7020006@zytor.com>
X-Enigmail-Version: 0.94.2.0
OpenPGP: id=4F9CF57E
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin wrote:
> Paul Rolland (ポール・ロラン) wrote:
[]
>> Measured 3978592228 cycles TSC warp between CPUs, turning off TSC clock.
>> Marking TSC unstable due to: check_tsc_sync_source failed.
[]
>> but I was wondering if this is a bug or a feature ;)

> The problem you're having is that the TSCs of your two cores are
> completely different, over a second apart.  This is a bug, unrelated to
> constant_tsc.

A bug in where - in the CPU or in kernel?

The thing is that all our dual-core machines shows something like
that.

For example, dualcore PentiumD machine:
Nov  7 20:23:56 paltus kernel: Linux version 2.6.22-i686smp (mjt@paltus.tls.msk.ru) (gcc version 4.1.2 20061115 (prerelease) (Debian 4.1.1-21)) #2.6.22.12 SMP Wed Nov 7 20:02:14 MSK 2007
...
Nov  7 20:23:56 paltus kernel: checking TSC synchronization [CPU#0 -> CPU#1]:
Nov  7 20:23:56 paltus kernel: Measured 112 cycles TSC warp between CPUs, turning off TSC clock.
Nov  7 20:23:56 paltus kernel: Marking TSC unstable due to: check_tsc_sync_source failed.
Nov  7 20:23:56 paltus kernel: Brought up 2 CPUs

(not that huge difference as Paul reported, but still "unstable".
The same happens with 2.6.23)

Note that once TSC is disabled (it's using "jiffies" as far
as I can see), ntpd constantly speeds up and slows down the
clock, it jumps +/- 0.5sec every several minutes or hours -
I guess that's when ntpd process gets moved from one core
to another for whatever reason.  And an interesting thing
is that with 64bits kernel this TSC problem does not occur
on this very machine.

Something similar is reported on AMD X2 64 machines as well --
can't check right now.

Thanks.

/mjt
