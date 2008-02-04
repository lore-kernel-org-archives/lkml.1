Return-Path: <linux-kernel-owner+w=401wt.eu-S1758510AbYBDUdg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758510AbYBDUdg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2008 15:33:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755501AbYBDUd2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Feb 2008 15:33:28 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:32980 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754570AbYBDUd1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2008 15:33:27 -0500
Date: Mon, 4 Feb 2008 21:33:15 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Cyrill Gorcunov <gorcunov@gmail.com>, Andi Kleen <ak@suse.de>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: vmlinux_64.lds.S - use THREAD_SIZE instead of
	numeric constant
Message-ID: <20080204203315.GA31341@elte.hu>
References: <20080204171037.GA6743@cvg> <20080204202241.GA16919@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080204202241.GA16919@uranus.ravnborg.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
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


* Sam Ravnborg <sam@ravnborg.org> wrote:

> Hi Cyrill.
> On Mon, Feb 04, 2008 at 08:10:37PM +0300, Cyrill Gorcunov wrote:
> > Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
> 
> The patch looks simple but please explain why you do what you do. It 
> took me some digging before I could convince mysleft this was indeed a 
> correct change. And I am pretty sure you did the same investigation 
> yourself.
> 
> A comment like:
> 
> arch/x866/kernel/inittask.c require all variables allocated in
> the section .data.init_task to be aligned with THREAD_SIZE.
> 
> would have made me happy.

Btw., given that on x86 we've moved away from the %esp based task stack 
trick and use an %fs based Percpu-Data-Area (PDA) to access the current 
task pointer, this alignment might not be necessary anymore. It's a 
historic relic of the mask-%esp trick.

	Ingo
