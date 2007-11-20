Return-Path: <linux-kernel-owner+w=401wt.eu-S1759830AbXKTV7p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759830AbXKTV7p (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2007 16:59:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752557AbXKTV7e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Nov 2007 16:59:34 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:60477 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752113AbXKTV7d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2007 16:59:33 -0500
Date: Tue, 20 Nov 2007 22:59:14 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Pavel Emelyanov <xemul@openvz.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Pavel Machek <pavel@ucw.cz>, kernel list <linux-kernel@vger.kernel.org>,
       netdev <netdev@vger.kernel.org>
Subject: Re: 2.6.24-rc3: find complains about /proc/net
Message-ID: <20071120215914.GE24156@elte.hu>
References: <20071119191000.GA1560@elf.ucw.cz> <200711192304.25087.rjw@sisk.pl> <4743026B.2020907@openvz.org> <m11wakshyz.fsf@ebiederm.dsl.xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m11wakshyz.fsf@ebiederm.dsl.xmission.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Eric W. Biederman <ebiederm@xmission.com> wrote:

> > lr-x------  1 root root 64 Nov 20 18:03 3 -> /proc/net
> > ...
> 
> Yes all of those are nasty.  So much for my clever way of implementing 
> these things.  Grr. Simple hacks that almost work!

btw., in case you feel inclined, i recently did some userspace coding 
and found to my surprise that /proc/self points to the parent task, not 
the thread itself (giving threads no real way to examine themselves). If 
you are hacking in this area, would it be a big trouble to add something 
like /proc/self-task/ or something like that? I had to use a raw gettid 
syscall to figure out the TID to get to /proc/*/tasks/TID/sched 
instrumentation info - which is quite a PITA.

	Ingo
