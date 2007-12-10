Return-Path: <linux-kernel-owner+w=401wt.eu-S1752751AbXLJWFg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752751AbXLJWFg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2007 17:05:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751592AbXLJWF3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Dec 2007 17:05:29 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:51980 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751496AbXLJWF2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2007 17:05:28 -0500
Date: Mon, 10 Dec 2007 14:04:57 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org, "Luck, Tony" <tony.luck@intel.com>
Subject: Re: [PATCH] Avoid overflows in kernel/time.c
Message-Id: <20071210140457.7a93de20.akpm@linux-foundation.org>
In-Reply-To: <475D8C88.5080706@zytor.com>
References: <200711300019.lAU0Jpbr003807@tazenda.hos.anvin.org>
	<20071204032949.c677c021.akpm@linux-foundation.org>
	<475D8C88.5080706@zytor.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 10 Dec 2007 10:59:20 -0800
"H. Peter Anvin" <hpa@zytor.com> wrote:

> Andrew Morton wrote:
> > 
> > My ia64 allmodconfig build has taken
> > 
> > akpm     15700 89.6  0.0   8256   700 pts/4    RN+  03:09  10:41 bc -q kernel/timeconst.bc
> > 
> > 11 minutes so far.  fc6/x86_64.
> > 
> 
> I just tried this on my system, using your cross-compiler chain.  I got 
> a different error:
> 
> /opt/crosstool/gcc-3.4.5-glibc-2.3.6/ia64-unknown-linux-gnu/lib/gcc/ia64-unknown-linux-gnu/3.4.5/../../../../ia64-unknown-linux-gnu/bin/ld: 
> section .data.patch [a000000000000500 -> a000000000000507] overlaps 
> section .dynamic [a0000000000003c8 -> a000000000000507]
> collect2: ld returned 1 exit status
> make[2]: *** [arch/ia64/kernel/gate.so] Error 1

You'll need rc4-mm1's ia64-increase-datapatch-offset.patch.  That's now in
Tony's tree and should go into 2.6.24 IMO.

> ... but the timeconst stuff worked fine.  I tried it both from the 
> command line and using your xb script.
> 
> This is on a fc7/x86-64 box.  I also ran through all the values from 48 
> to 1024 on both an fc5 and an fc7 box (no fc6 box readily available, 
> although bc has been at 1.06 since 2000...)
> 
> In short, this is highly weird.  Could you possibly do me a favour and 
> just run, at the command line:
> 
> echo 250 | bc -q kernel/timeconst.bc

That works OK.

> ... and see if it reproduces the lockup (I'm assuming HZ == 250 in your 
> config, since that's what I get when I do "make allmodconfig" on IA64.)
> 
> (No need to wait 11 minutes.  It should run in a small fraction of a 
> second.)

I retested 2.6.24-rc4-mm1 plus avoid-overflows-in-kernel-timec.patch and
the failure has magically gone away.

Ho hum.  I'll reconstitute the patch and will keep an eye on it.
It'd be nice to avoid the introduction of the bc dependency though.
