Return-Path: <linux-kernel-owner+w=401wt.eu-S1765203AbYCFLOf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765203AbYCFLOf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2008 06:14:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761132AbYCFLOZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Mar 2008 06:14:25 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:42559 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759050AbYCFLOY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2008 06:14:24 -0500
Date: Thu, 6 Mar 2008 12:14:08 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Andi Kleen <ak@suse.de>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Pavel Machek <pavel@ucw.cz>,
       kernel list <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: 2.6.25-rc3: 34TB vmalloc total -- overflow in /proc/meminfo?
Message-ID: <20080306111408.GM13391@elte.hu>
References: <20080305090610.GA30024@atrey.karlin.mff.cuni.cz> <20080305093923.GA2049@atrey.karlin.mff.cuni.cz> <200803052312.37996.rjw@sisk.pl> <200803052331.42193.ak@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200803052331.42193.ak@suse.de>
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


* Andi Kleen <ak@suse.de> wrote:

> Just commenting on the subject. The 34TB are not an over/underflow. 
> x86-64 simply has so much address space reserved for vmalloc. It 
> doesn't mean of course that that much could be actually allocated in 
> real memory.

btw., the exact amount of available vmalloc space on 64-bit x86 is 32 TB 
(32768 GB), or 0x0000200000000000 hexa. (this is still only 0.0002% of 
the complete 64-bit address space [25% of the 128 TB 64-bit kernel 
address space] so we've got plenty of room)

but the first fundamental limit we'll hit on 64-bit is the 32-bit offset 
limit of binaries - this affects kernel modules, the kernel image, etc. 
We wont hit that anytime soon, but we'll eventually hit it. (user-space 
will be the first i guess)

	Ingo
