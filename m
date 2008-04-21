Return-Path: <linux-kernel-owner+w=401wt.eu-S1754718AbYDUOnw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754718AbYDUOnw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 10:43:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751505AbYDUOnn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 10:43:43 -0400
Received: from accolon.hansenpartnership.com ([76.243.235.52]:44363 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751157AbYDUOnm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 10:43:42 -0400
Subject: Re: [REGRESSION] 2.6.25 on parisc - CPU 1 is stuck
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Domenico Andreoli <cavokz@gmail.com>
Cc: Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-parisc@vger.kernel.org
In-Reply-To: <20080420231818.GA2162@ska.dandreoli.com>
References: <20080420231818.GA2162@ska.dandreoli.com>
Content-Type: text/plain
Date: Mon, 21 Apr 2008 09:43:38 -0500
Message-Id: <1208789018.3640.6.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-4.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-04-21 at 01:18 +0200, Domenico Andreoli wrote: 
> as soon as I booted my dual PA8600 with 2.6.25 I got 1 CPU less. The
> only other kernel I successfully used on that box is Debian's 2.6.22-3.
> 
> Debian never built 2.6.23 for parisc, 2.6.24 was still hanging last
> time I checked it, 2.6.25 did not even build until recent -rc. So I am
> not in the best position to bisect.

Try this one; it's a corrected version of debian 2.6.24-1 for parisc
systems:

http://www.parisc-linux.org/~jejb/parisc_debs/linux-image-2.6.24-1-parisc64-smp_2.6.24-5+b1_hppa.deb

It's known to boot correctly on B, A and rp3440 systems, but we don't
have a J system to try it out on.

> Here is the relevant dmesg.
> Releasing cpu 1 now, hpa=fffffffffffa2000
> SMP: CPU:1 is stuck.
> CPU(s): 2 x PA8600 (PCX-W+) at 552.000000 MHz
> Setting cache flush threshold to f84c0 (1 CPUs online)

Unfortunately that doesn't tell us anything other than the start IPI
failed for some reason.  One thing to try with the J series is a 32 bit
kernel just in case: they're the only SMP systems that will boot 32
bits, just in case you could try a 32 bit smp kernel.

As Dave Anglin said, it could be a config problem, although when I have
CPUs deconfigured by firmware, they usually don't show up in the
inventory.

James


