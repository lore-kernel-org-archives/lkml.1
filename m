Return-Path: <linux-kernel-owner+w=401wt.eu-S1757503AbYARIhO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757503AbYARIhO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 03:37:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751278AbYARIhB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 03:37:01 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:60755 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751055AbYARIhA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 03:37:00 -0500
Date: Fri, 18 Jan 2008 09:36:10 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Andrew Morton <akpm@linux-foundation.org>, Zan Lynx <zlynx@acm.org>,
       Thomas Gleixner <tglx@linutronix.de>, Len Brown <lenb@kernel.org>,
       linux-kernel@vger.kernel.org
Subject: Re: echo mem > /sys/power/state
Message-ID: <20080118083610.GA19792@elte.hu>
References: <20080116222445.6f7ff66e.akpm@linux-foundation.org> <1200591411.34145.4.camel@localhost> <20080117111355.29554f38.akpm@linux-foundation.org> <200801172238.17176.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200801172238.17176.rjw@sisk.pl>
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


* Rafael J. Wysocki <rjw@sisk.pl> wrote:

> > Probably it would be more efficient to have the people who wrote the 
> > code also test it.
> 
> Well, that would certainly help.
> 
> I do test all of my patches and generally all of the patches I sign 
> off, but surely that's not enough.

please add a .config option dependent on CONFIG_DEBUG_KERNEL=y [and 
default-disabled] that auto-tests suspend/resume functionality 60 
seconds after hitting user-space (the suspend/resume cycle kept small 
via a small RTC timeout) and s2ram correctness will be tested _a lot_ 
more.

(it doesnt matter if graphics does not resume fine - at least for my 
tests)

kprobes had similar problems and it now has a few simple smoke-tests - 
which i just saw trigger on a patch that i did not notice would break 
kprobes. I think this should be done for all functionality that is not 
regularly triggered by a normal distro bootup (and which is easy to 
overlook in testing).

	Ingo
