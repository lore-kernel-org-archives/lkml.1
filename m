Return-Path: <linux-kernel-owner+w=401wt.eu-S1759359AbYDJUvd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759359AbYDJUvd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2008 16:51:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757094AbYDJUvZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Apr 2008 16:51:25 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:55960 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757029AbYDJUvZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2008 16:51:25 -0400
Date: Thu, 10 Apr 2008 22:51:06 +0200
From: Ingo Molnar <mingo@elte.hu>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Pavel Machek <pavel@ucw.cz>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Anvin" <hpa@zytor.com>
Subject: Re: x86 git tree broken
Message-ID: <20080410205106.GB15440@elte.hu>
References: <200804102159.14563.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200804102159.14563.rjw@sisk.pl>
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

> Second, if I try to suspend the box to RAM, it enters a state it 
> cannot leave until power is physically cut from it (using the power 
> button to power off / power on the box doesn't help).

i used your config on an AMD system here and s2ram works just fine, both 
using CONFIG_PM_TEST_SUSPEND=y bootup suspend self-test [which x86.git 
QA uses all the time], and using a manual pm-suspend command at the 
console.

you can also try your luck and remove the last 20% of x86.git [which is 
always the newest stuff], by picking a commit 200 patches down the line, 
via:

 git-rev-list x86/base..x86/latest | head -200 | tail -1

and testing that. If that tree works, it's the last 200 commits that 
break stuff.

exactly what kind of system are you using? If you revert the trampoline 
changes, does it get any better - but i guess it might be better to do a 
bisection.

	Ingo
