Return-Path: <linux-kernel-owner+w=401wt.eu-S1756300AbZJLLZz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756300AbZJLLZz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 07:25:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756283AbZJLLZx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 07:25:53 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:50467 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756264AbZJLLZw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 07:25:52 -0400
Date: Mon, 12 Oct 2009 13:25:04 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>, Greg KH <gregkh@suse.de>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [crash] NULL pointer dereference at IP: [<ffffffff812e9ccb>]
	uart_close+0x2a/0x1e4
Message-ID: <20091012112504.GA10002@elte.hu>
References: <alpine.LFD.2.01.0910111446410.3438@localhost.localdomain> <20091012080511.GA22607@elte.hu> <20091012091954.GA31171@elte.hu> <20091012092713.GA32647@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091012092713.GA32647@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Ingo Molnar <mingo@elte.hu> wrote:

> i also have a crash with vanilla -rc4, test on this commit:
> 
>   d93a8f8: Revert "USB: Work around BIOS bugs by quiescing USB controllers earlier"
> 
> crashlog pasted below - config attached.

i did a full .31 -> .32-rc4 bisection and came up with this result:

|  46d57a449aa13d9c6adcc9d1dbc7b9a0ecfb69d8 is first bad commit
|  commit 46d57a449aa13d9c6adcc9d1dbc7b9a0ecfb69d8
|  Author: Alan Cox <alan@linux.intel.com>
|  Date:   Sat Sep 19 13:13:29 2009 -0700
|
|     serial: use tty_port pointers in the core code

this is the second time i have bisected back to this commit, see also 
this prior thread on lkml:

 Subject: [origin tree boot crash] Re: [GIT PATCH] TTY patches for 2.6.31-git

i chalked that first crash/hang up to potential cosmic entropy 
(especially since it happened even with all serial logging disabled, and 
because i was unable to get any log of the spontaneous reboot), but this 
second crash occurs on a completely different system and has an 
analyzable crash signature as well.

Both systems are rock-solid with no known hardware weirdness, the first 
test-system passed two hundred thousand boot tests in the past 1.5 
years, and the second one has performed tens of thousands of build+boot 
tests as well. I'd exclude hardware failure as a likely candidate for 
now.

Unfortunately 46d57a449aa13d9c6adcc9d1dbc7b9a0ecfb69d8 is not easy to 
revert, at all. Would be glad to try any patch - fixes or some manual 
revert as well (if that's feasible).

	Ingo
