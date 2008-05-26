Return-Path: <linux-kernel-owner+w=401wt.eu-S1755581AbYEZQRI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755581AbYEZQRI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2008 12:17:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753250AbYEZQQl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 May 2008 12:16:41 -0400
Received: from fg-out-1718.google.com ([72.14.220.155]:64754 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754797AbYEZQQe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2008 12:16:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=upnLBgfxleZjULNXvLXfvYbu1ffecfLUzyRPxgAgroG8nNJkWVRpZm0KHKZZ7oxfVLppp7ghWSTdpHgIkRlS6/QeGM/MyO1lSvOdMK8vnZxOjUHFc+dwc3ND3qolrIQ8j9yzLkY8C6px6+zySt9FCEyyoQW4jbXkLCb5UjioBSk=
Date: Mon, 26 May 2008 20:16:23 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Sitsofe Wheeler <sitsofe@yahoo.com>
Cc: linux-kernel@vger.kernel.org, kernel-testers@vger.kernel.org
Subject: Re: [REGRESSION][BISECTED][X86] next-20080526 hangs on boot
Message-ID: <20080526161623.GC7305@cvg>
References: <g1eg2q$81q$1@ger.gmane.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <g1eg2q$81q$1@ger.gmane.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Sitsofe Wheeler - Mon, May 26, 2008 at 03:04:54PM +0100]
| <posted & mailed>
| 
| When using a 32 bit linux-next-20080526 the bootup process will hang at a
| random point (not even sysrq helps) with no additional output on the screen
| (whereas linux-next-20080523 did boot). Mysteriously, booting with
| nmi_watchdog=2 allows the boot to finish (booting with nmi_watchdog=1 still
| stalls). I have bisected it down to commit
| [d1b946b97d71423f365fa797d1428e1847c0bec1]:
| 
| commit d1b946b97d71423f365fa797d1428e1847c0bec1
| Author: Cyrill Gorcunov <gorcunov@gmail.com>
| Date:   Sat May 24 19:36:34 2008 +0400
| 
|     x86: nmi_32.c - add "panic" option
| 
|     Allow to pass "panic" option in 32bit mode
| 
|     Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
|     Cc: hpa@zytor.com
|     Cc: mingo@redhat.com
|     Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
| 
| Reverting this seemed to allow the boot to proceed without issue. Here is
| the bisection log:
| 
| # bad: [5ffeee1785c30303007b3d2dce85402b0bbf9b00] Add linux-next specific
| files
| # good: [7b6c98f0853b86c101948f1bf4e0a21d3065944f] Add linux-next specific
| files
| git-bisect start 'next-20080526' 'next-20080523'
| # bad: [cab464e32db5aef80c51831c20009ae7c3354396] Merge
| commit 'x86/auto-x86-next'
| git-bisect bad cab464e32db5aef80c51831c20009ae7c3354396
| # good: [497d7294d4fb1a0d2ce14bb891a1d812b2af3745] Merge
| branch 'x86/mpparse' into auto-x86-next
| git-bisect good 497d7294d4fb1a0d2ce14bb891a1d812b2af3745
| # good: [8315d6949d94b7513f8829b62d59d7d5699872dd] USB: driver for gotemp
| device
| git-bisect good 8315d6949d94b7513f8829b62d59d7d5699872dd
| # good: [289c79a4bd350e8a25065102563ad1a183d1b402] vlan: Use bitmask of
| feature flags instead of seperate feature bits
| git-bisect good 289c79a4bd350e8a25065102563ad1a183d1b402
| # bad: [c791e51837f26cba073d3c37cf04803bb3a5c6c0] Merge branch 'x86/timers'
| into auto-x86-next
| git-bisect bad c791e51837f26cba073d3c37cf04803bb3a5c6c0
| # bad: [4039cbaacf7874ab1effd0e9fb6c60bf9217f373] Merge branch 'x86/nmi'
| into auto-x86-next
| git-bisect bad 4039cbaacf7874ab1effd0e9fb6c60bf9217f373
| # bad: [4b82b277707a39b97271439c475f186f63ec4692] x86: nmi_32.c - add
| nmi_watchdog_default helper
| git-bisect bad 4b82b277707a39b97271439c475f186f63ec4692
| # good: [e56b3a12c45e439169f2d1f7194be397667320a6] x86: nmi - die_nmi()
| output message unification
| git-bisect good e56b3a12c45e439169f2d1f7194be397667320a6
| # bad: [d1b946b97d71423f365fa797d1428e1847c0bec1] x86: nmi_32.c -
| add "panic" option
| git-bisect bad d1b946b97d71423f365fa797d1428e1847c0bec1
| # good: [c6425b9f143a75bbcd0a7684b4df40e20d0b2f32] x86: move do_nmi(),
| stop_nmi() and restart_nmi() to traps_64.c
| git-bisect good c6425b9f143a75bbcd0a7684b4df40e20d0b2f32
| 
| -- 
| Sitsofe | http://sucs.org/~sits/
| 
| 

and, btw, could you post your config, please?

		- Cyrill -
