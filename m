Return-Path: <linux-kernel-owner+w=401wt.eu-S1754025AbZBIJTS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754025AbZBIJTS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Feb 2009 04:19:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752462AbZBIJTE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Feb 2009 04:19:04 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:38532 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751637AbZBIJTC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Feb 2009 04:19:02 -0500
Date: Mon, 9 Feb 2009 10:18:49 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Paul Collins <paul@burly.ondioline.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [Bug #12667] Badness at kernel/time/timekeeping.c:98 in pmud
	(timekeeping_suspended)
Message-ID: <20090209091849.GF31890@elte.hu>
References: <AIghyjFgMFP.A.uZD._10jJB@chimera> <sWhNs83kKPE.A.p4D.L20jJB@chimera> <878wognj00.fsf@burly.wgtn.ondioline.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <878wognj00.fsf@burly.wgtn.ondioline.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
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


* Paul Collins <paul@burly.ondioline.org> wrote:

> "Rafael J. Wysocki" <rjw@sisk.pl> writes:
> 
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12667
> > Subject		: Badness at kernel/time/timekeeping.c:98 in pmud (timekeeping_suspended)
> > Submitter	: Paul Collins <paul@burly.ondioline.org>
> > Date		: 2009-01-21 7:15 (19 days old)
> > First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=1c5745aa380efb6417b5681104b007c8612fb496
> > References	: http://marc.info/?l=linux-kernel&m=123252215315106&w=4
> 
> I've just done ten suspend/resume cycles with 2.6.29-rc4 and this
> message was not logged, so it's either gone away or else become much
> more difficult to reproduce.

Various suspend handlers were enabling irqs spuriously - fixed by recent patches in 
-rc4. The warning above is consistent with the timekeeping code being surprised with 
a premature irqs-enable.

	Ingo
