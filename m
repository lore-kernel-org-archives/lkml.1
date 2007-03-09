Return-Path: <linux-kernel-owner+w=401wt.eu-S1767661AbXCIXjI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767661AbXCIXjI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2007 18:39:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767627AbXCIXjH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Mar 2007 18:39:07 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:36438 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1767663AbXCIXjF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2007 18:39:05 -0500
Date: Sat, 10 Mar 2007 00:38:28 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Chris Wright <chrisw@sous-sol.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Zachary Amsden <zach@vmware.com>, Thomas Gleixner <tglx@linutronix.de>,
       john stultz <johnstul@us.ibm.com>, akpm@linux-foundation.org,
       LKML <linux-kernel@vger.kernel.org>,
       Rusty Russell <rusty@rustcorp.com.au>, Andi Kleen <ak@suse.de>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: ABI coupling to hypervisors via CONFIG_PARAVIRT
Message-ID: <20070309233828.GA5566@elte.hu>
References: <20070309180230.GA17988@elte.hu> <Pine.LNX.4.64.0703091022490.10832@woody.linux-foundation.org> <20070309192420.GA27747@elte.hu> <Pine.LNX.4.64.0703091137340.10832@woody.linux-foundation.org> <20070309210430.GA14905@elte.hu> <20070309212714.GU10574@sequoia.sous-sol.org> <20070309214704.GA20988@elte.hu> <20070309221046.GV10574@sequoia.sous-sol.org> <20070309222435.GB24341@elte.hu> <45F1E160.1090608@goop.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45F1E160.1090608@goop.org>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Jeremy Fitzhardinge <jeremy@goop.org> wrote:

> The important part is that there's more to the story than just pv_ops. 
> If you wanted to make such a change, then you'd need to refactor the 
> i386 support code to add a vma->paging helper layer.  That layer would 
> be available for any pv_ops interface to use if it wishes.

no such change is needed to native. [ other than the removal of tons of 
lowlevel hooks ;-) ] Think of this in terms of a completely separate MM 
layer for guest kernels, with all memory management details done on the 
hypervisor side, ok? I dont think you can emulate that in an equivalent 
way via VMI, the kernel object in this model is on the hypervisor side - 
while with VMI that does not look possible.

	Ingo
