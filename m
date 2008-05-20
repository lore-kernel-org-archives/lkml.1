Return-Path: <linux-kernel-owner+w=401wt.eu-S1762568AbYETI1d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762568AbYETI1d (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 04:27:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758525AbYETI1T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 04:27:19 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52661 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753386AbYETI1Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 04:27:16 -0400
Date: Tue, 20 May 2008 01:26:58 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-kernel@vger.kernel.org, wim@iguana.be,
       Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [PATCH 18/57] iTCO: unlocked_ioctl, coding style and cleanup
Message-Id: <20080520012658.274b0c1e.akpm@linux-foundation.org>
In-Reply-To: <20080519130625.31722.68489.stgit@core>
References: <20080519124659.31722.51847.stgit@core>
	<20080519130625.31722.68489.stgit@core>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 19 May 2008 14:06:25 +0100 Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:

>  drivers/watchdog/iTCO_vendor.h         |   15 ++
>  drivers/watchdog/iTCO_vendor_support.c |   53 +++---
>  drivers/watchdog/iTCO_wdt.c            |  294 ++++++++++++++++----------------

This runs afoul of git-watchdog and/or itco_wdt-ich9do-support.patch

Hunk #1 succeeded at 66 (offset 1 line).
Hunk #3 FAILED at 139.
Hunk #4 FAILED at 158.
Hunk #5 FAILED at 201.
Hunk #6 FAILED at 222.
Hunk #7 FAILED at 246.
Hunk #8 succeeded at 374 (offset 12 lines).
Hunk #9 FAILED at 429.
Hunk #10 FAILED at 458.
Hunk #11 FAILED at 472.
Hunk #12 FAILED at 480.
Hunk #13 FAILED at 489.
Hunk #14 FAILED at 518.
Hunk #15 FAILED at 534.
Hunk #16 FAILED at 588.
Hunk #17 succeeded at 454 (offset -140 lines).
Hunk #18 FAILED at 475.
Hunk #19 succeeded at 669 (offset 27 lines).
Hunk #20 succeeded at 512 (offset -140 lines).
Hunk #21 FAILED at 534.
Hunk #22 succeeded at 814 (offset 29 lines).
15 out of 22 hunks FAILED -- saving rejects to file drivers/watchdog/iTCO_wdt.c.rej

so I ducked this one.

booke-watchdog-clean-up-and-unlocked_ioctl gets 8-out-of-ten against
watchdog-fix-booke_wdtc-on-mpc85xx-smp-system.patch so I ducked that one too.

w83697hf_wdt-cleanup-coding-style-and-switch-to-unlocked_ioctl gets
4-of-17 against git-watchdog - also ducked.


The rest applied, although about half of them needed fixes because
Rusty has been running around fiddling with other peoples stuff
renaming down_trylock to down_nowait all over the tree.

This means that the watchdog patches now have a Rusty dependency so I
NEED TO KNOW if those patches aren't for 2.6.27 or if they get nacked
or something.

It also means that the patches which I queued cannot go into Wim's tree
as-is.  If Wim queues the originals then it means that Stephen and/or
myself get to fix all the rejects again, and there'll be a
decent-sized smashup during the merge window.  There are lessons
here...

And if Wim decides to merge these patches prior to merging

itco_wdt-ich9do-support.patch
watchdog-fix-booke_wdtc-on-mpc85xx-smp-system.patch

then those two patches will get wrecked.
