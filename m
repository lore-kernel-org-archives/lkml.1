Return-Path: <linux-kernel-owner+w=401wt.eu-S1753477AbXJBJTF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753477AbXJBJTF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2007 05:19:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751723AbXJBJS4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Oct 2007 05:18:56 -0400
Received: from www.tglx.de ([62.245.132.106]:39203 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751181AbXJBJSz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2007 05:18:55 -0400
Date: Tue, 2 Oct 2007 11:17:02 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Ingo Molnar <mingo@elte.hu>, Andi Kleen <ak@suse.de>,
       Greg KH <greg@kroah.com>, Rusty Russell <rusty@rustcorp.com.au>,
       Sam Ravnborg <sam@ravnborg.org>, "H. Peter Anvin" <hpa@zytor.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Venkatesch Pallipadi <venkatesh.pallipadi@intel.com>,
       Mike Travis <travis@sgi.com>, Avi Kivity <avi@qumranet.com>,
       Jason Wessel <jason.wessel@windriver.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Glauber de Oliveira Costa <glommer@gmail.com>,
       Chris Wright <chrisw@sous-sol.org>,
       Christoph Lameter <clameter@sgi.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>,
       Zachary Amsden <zach@vmware.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.23-rc9 and a heads-up for the 2.6.24 series..
In-Reply-To: <alpine.LFD.0.999.0710012029400.3579@woody.linux-foundation.org>
Message-ID: <alpine.LRH.0.999.0710021019310.23586@www.tglx.de>
References: <alpine.LFD.0.999.0710012029400.3579@woody.linux-foundation.org
 >
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 1 Oct 2007, Linus Torvalds wrote:
> This is also a good time to warn about the fact that we're doing the x86 
> merge very soon (as in the next day or two) after 2.6.23 is out, so if you 
> have pending patches for the next series that touch arch/i386 or x86-64, 
> you should get in touch with Thomas Gleixner and Ingo Molnar, who are the 
> keepers of the merge scripts, and will help you prepare..
> 
> Doing it as early as possible in the 2.6.24-rc4 series (basically I'll do 
> it first thing) will mean that we'll have the maximum amount of time to 
> sort out any issues, and the thing is, Thomas and Ingo already have a tree 
> ready to go, so people can check their work against that, and don't need 
> to think that they have to do any fixups after it his *my* tree. It would 
> be much better if everybody was just ready for it, and not taken by 
> surprise.
> 
> In other words, people who know they may be affected and would want to 
> prepare can look at (for example)
> 
> 	git://git.kernel.org/pub/scm/linux/kernel/git/tglx/linux-2.6-x86.git x86
> 
> and generally get ready for the switch-over. 

I have uploaded an update of the arch/x86 tree based on -rc9 to

	git://git.kernel.org/pub/scm/linux/kernel/git/tglx/linux-2.6-x86.git x86

For convenience there is a patch fixup script which helps you to
convert pending patches against this tree.

	http://userweb.kernel.org/~tglx/x86/x86-fixup-patches.py

It's generated from the merge script and fixes the namespace of
patches. There will still be some rejects which can not be fixed up
automatically, but this should be rare.

I did a test with Andrews -mm series and only ~10 arch/x86 related
patches had rejects, out of 230+ patches, so the 100%-painless
conversion ratio is better than 95%. Those patches with rejects were
trivial to fix.

Usage: x86-fixup-patches.py sourcepatch destpatch

source and dest can be the same.

A helper script to convert complete quilt series is here:
	http://userweb.kernel.org/~tglx/x86/fixupseries.sh

If there is anything we can help with the transition, please do not
hesitate to ask.

Thanks,

	Thomas, Ingo
