Return-Path: <linux-kernel-owner+w=401wt.eu-S1755839AbXL3NEV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755839AbXL3NEV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Dec 2007 08:04:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752175AbXL3NEO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Dec 2007 08:04:14 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:47550 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751891AbXL3NEN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Dec 2007 08:04:13 -0500
Date: Sun, 30 Dec 2007 14:03:39 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Rene Herman <rene.herman@keyaccess.nl>, dpreed@reed.com,
       Islam Amer <pharon@gmail.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       hpa@zytor.com, Pavel Machek <pavel@ucw.cz>,
       Ingo Molnar <mingo@redhat.com>, Andi Kleen <andi@firstfloor.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: provide a DMI based port 0x80 I/O delay override
Message-ID: <20071230130339.GA16946@elte.hu>
References: <477711DC.5030800@keyaccess.nl> <alpine.LFD.1.00.0712300124440.32517@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.00.0712300124440.32517@woody.linux-foundation.org>
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


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> > This fixes "hwclock" triggered boottime hangs for a few HP/Compaq 
> > laptops and might as such be applicable to 2.6.24 still.
> 
> It's not a regression as far as I can see (ie we've always done that 
> port 80 access for slow-down), and quite frankly, I think the code is 
> horribly ugly.
> 
> Using a DMI quirk for something like this is just not maintainable. 
> Are we going to live with doing new quirks forever? I'd rather just 
> remove the slowdown entirely (obviously that is not for 2.6.24 either, 
> though!), and drivers that then are shown to really need it could use 
> their *own* ports.

yep, that's exactly the plan: in x86.git we've got it all set up so that 
we can switch over to ioport=nodelay by default in v2.6.25, and then get 
rid of all the iodelay infrastructure in 2.6.26 altogether if things 
work out fine (which is the expectation from all test feedback so far).

	Ingo
