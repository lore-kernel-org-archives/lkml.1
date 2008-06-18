Return-Path: <linux-kernel-owner+w=401wt.eu-S1752971AbYFRQJh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752971AbYFRQJh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2008 12:09:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751219AbYFRQJa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jun 2008 12:09:30 -0400
Received: from [213.77.9.205] ([213.77.9.205]:63433 "EHLO serum.com.pl"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751194AbYFRQJ3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2008 12:09:29 -0400
Date: Wed, 18 Jun 2008 17:06:29 +0100 (BST)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
To: Cyrill Gorcunov <gorcunov@gmail.com>
cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: nmi_watchdog suspicious
In-Reply-To: <20080617155120.GA9440@cvg>
Message-ID: <Pine.LNX.4.55.0806181654450.4857@cliff.in.clinika.pl>
References: <20080610185759.GA7353@cvg> <Pine.LNX.4.55.0806160040270.11995@cliff.in.clinika.pl>
 <20080616170000.GC7273@cvg> <Pine.LNX.4.55.0806161819500.20218@cliff.in.clinika.pl>
 <20080617155120.GA9440@cvg>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 17 Jun 2008, Cyrill Gorcunov wrote:

> Thanks a lot Maciej for comments! I've marked them. I'm not sure but it seems
> I wrote a bit unclear /my english bad indeed/ ;) I mean - this say 'slipping'
> (ie useless code executions) _was_ before the patch applied. Now it doesn't
> slip on this since we do mention explicitly in which case there should be
> alert counters reset. Other then that - will try to handle your notes. Thanks!

 It will happen regardless if touch_nmi_watchdog() is called before the
NMI watchdog has been set up in setup_nmi() or lapic_watchdog_init().  It
may also happen during that window if an NMI is signalled without any NMI
status bits set in the Port B register at 0x61 -- in theory that should
not happen except for a broken configuration, but reality out there seems
to be quite creative about breakage.

  Maciej
