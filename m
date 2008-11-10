Return-Path: <linux-kernel-owner+w=401wt.eu-S1753906AbYKJPk2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753906AbYKJPk2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2008 10:40:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751746AbYKJPkS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Nov 2008 10:40:18 -0500
Received: from terminus.zytor.com ([198.137.202.10]:45434 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751347AbYKJPkR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2008 10:40:17 -0500
Message-ID: <491855AA.5060100@zytor.com>
Date: Mon, 10 Nov 2008 07:39:22 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Alexander van Heukelum <heukelum@fastmail.fm>,
       Andi Kleen <andi@firstfloor.org>, Cyrill Gorcunov <gorcunov@gmail.com>,
       Alexander van Heukelum <heukelum@mailshack.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, lguest@ozlabs.org,
       jeremy@xensource.com, Steven Rostedt <srostedt@redhat.com>,
       Mike Travis <travis@sgi.com>
Subject: Re: [PATCH RFC/RFB] x86_64, i386: interrupt dispatch changes
References: <20081104122839.GA22864@mailshack.com> <20081104150729.GC21470@localhost> <20081104170501.GE29626@one.firstfloor.org> <1225822006.21441.1282961299@webmail.messagingengine.com> <20081104204400.GC10825@elte.hu> <1226243805.27361.1283784629@webmail.messagingengine.com> <20081110085846.GG22392@elte.hu>
In-Reply-To: <20081110085846.GG22392@elte.hu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Alexander van Heukelum <heukelum@fastmail.fm> wrote:
> 
> hackbench is _way_ too noisy to measure such cycle-level differences 
> as irq entry changes cause. It also does not really stress interrupts 
> - it only stresses networking, the VFS and the scheduler.
> 
> a better test might have been to generate a ton of interrupts, but 
> even then it's _very_ hard to measure it properly. The best method is 
> what i've suggested to you early on: run a loop in user-space and 
> observe irq costs via RDTSC, as they happen. Then build a histogram 
> and compare the before/after histogram. Compare best-case results as 
> well (the first slot of the histogram), as those are statistically 
> much more significant than a noisy average.
> 

For what it's worth, I tested this out, and I'm pretty sure you need to
run a uniprocessor configuration (or system) for it to make sense --
otherwise you end up missing too many of the interrupts.  I first tested
this on an 8-processor system and, well, came up with nothing.

I'm going to try this later on a uniprocessor, unless Alexander beats me
to it.

	-hpa
