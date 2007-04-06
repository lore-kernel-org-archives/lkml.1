Return-Path: <linux-kernel-owner+w=401wt.eu-S933675AbXDFRgz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933675AbXDFRgz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2007 13:36:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933701AbXDFRgy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Apr 2007 13:36:54 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:50973 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933675AbXDFRgx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2007 13:36:53 -0400
Date: Fri, 6 Apr 2007 19:36:39 +0200
From: Ingo Molnar <mingo@elte.hu>
To: John <linux.kernel@free.fr>
Cc: linux-kernel@vger.kernel.org, tglx@timesys.com
Subject: Re: 2.6.20-rt8 patch tweaked for 2.6.20.5
Message-ID: <20070406173639.GA2929@elte.hu>
References: <461672D8.7090100@free.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <461672D8.7090100@free.fr>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* John <linux.kernel@free.fr> wrote:

> Hello,
> 
> I've tweaked patch-2.6.20-rt8 so that it applies to 2.6.20.5
> 
> The unified diff is attached to this message.

thanks - this is useful to those who are not that much on the bleeding 
edge.

> I'd be happy to hear comments on what I've done wrong.
> 
> 78 hunks had to be offset and 3 hunks had to be fuzzed.
> 
> $ grep -B1 fuzz patch.log
> patching file arch/ia64/kernel/iosapic.c
> Hunk #3 succeeded at 469 with fuzz 2.
> --
> patching file kernel/fork.c
> Hunk #9 succeeded at 975 with fuzz 1.
> --
> patching file kernel/sched.c
> Hunk #46 succeeded at 3996 with fuzz 1.
> 
> What is the fuzz value, exactly?

it's harmless: when the 'patch' utility didnt find the 'context' of the 
patch chunk at its claimed position (because all patch chunks have 
precise coordinates of source code embedded), but finds them 'nearby' 
(or at least, somewhere in the file), it emits this reminder that the 
underlying code did change since the patch was generated. Generating a 
'clean' patch will get rid of these messages.

	Ingo
