Return-Path: <linux-kernel-owner+w=401wt.eu-S1752078AbZERI7q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752078AbZERI7q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 May 2009 04:59:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751918AbZERI7f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 May 2009 04:59:35 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:51304 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751073AbZERI7f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 May 2009 04:59:35 -0400
Date: Mon, 18 May 2009 10:59:02 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [GIT PULL] xen /proc/mtrr implementation
Message-ID: <20090518085902.GE10687@elte.hu>
References: <1242170864-13560-1-git-send-email-jeremy@goop.org> <20090513133021.GA7277@elte.hu> <4A0ADBA2.2020300@goop.org> <20090515182757.GA19256@elte.hu> <4A0DCC11.10307@goop.org> <m1my9ex818.fsf@fess.ebiederm.org> <4A0DFF78.6000501@goop.org> <20090515202250.0f1218ef@jbarnes-g45> <m1iqk1k708.fsf@fess.ebiederm.org> <4A10EAC4.9070701@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A10EAC4.9070701@goop.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
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


* Jeremy Fitzhardinge <jeremy@goop.org> wrote:

> It's not really virtualized.  We're talking about dom0, which is 
> the guest domain which has access to the real machine's real 
> hardware; the MTRR is part of that.

That is a really broken model and design of virtualization: 
splitting the hypervisor into Xen and then a separate Linux dom0 
entity because reality called home a few years ago and you needed 
actual working drivers and hardware support and a developer 
community to pull that off ...

Here Xen invades an already fragile piece of upstream code 
(/proc/mtrr) that is obsolete and on the way out. If you want a 
solution you should add PAT support to Xen and you should use recent 
upstream kernels. Or you should emulate /proc/mtrr in _Xen the 
hypervisor_, if you really care that much - without increasing the 
amount of crap in Linux.

Without a better reason than what you've given so far the answer is 
really: "no thanks" ...

My suspicion is that Linus would (rightfully) refuse to pull such a 
broken approach from me, so why should i pull it? If i'm wrong and 
if you can get an Acked-by from Linus _before_ sending a pull 
request we can override my NAK. I've Cc:-ed him, in case he wants to 
express an opinion.

	Ingo
