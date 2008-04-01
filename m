Return-Path: <linux-kernel-owner+w=401wt.eu-S1756893AbYDAIeS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756893AbYDAIeS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2008 04:34:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755977AbYDAIeM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Apr 2008 04:34:12 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:37561 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755897AbYDAIeL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2008 04:34:11 -0400
Date: Tue, 1 Apr 2008 10:33:59 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jiri Kosina <jkosina@suse.cz>
Cc: linux-kernel@vger.kernel.org
Subject: Re: spinlocks -- why are releases inlined and acquires are not?
Message-ID: <20080401083359.GB32272@elte.hu>
References: <Pine.LNX.4.64.0804010202390.5541@jikos.suse.cz> <Pine.LNX.4.64.0804010236110.5541@jikos.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0804010236110.5541@jikos.suse.cz>
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


* Jiri Kosina <jkosina@suse.cz> wrote:

> > What is the reason for this asymetry? Shouldn't the acquiring 
> > functions be implemented in the very same way? Or at least, 
> > shouldn't all the __lockfunc functions be inlined?
> 
> i.e. is there any particular reason why we don't have something like 
> the patch below (implemented for all the lock variants of course, this 
> is just to demonstrate what I mean)?

IIRC the main reason we decided to uninline them was image size. So i'd 
suggest for you to check how this change impacts vmlinux size (on both 
64-bit and 32-bit), a typical distro config (or allyesconfig with lock 
debugging disabled).

If you do the test on x86.git/latest you'll also have the 
CONFIG_OPTIMIZE_INLINING=y and CONFIG_CC_OPTIMIZE_FOR_SIZE=y combination 
as well, which generates the most compact x86 kernel image ever.

	Ingo
