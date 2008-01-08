Return-Path: <linux-kernel-owner+w=401wt.eu-S1762109AbYAHQ4P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762109AbYAHQ4P (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 11:56:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753980AbYAHQ4A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 11:56:00 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:45954 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752954AbYAHQz7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 11:55:59 -0500
Date: Tue, 8 Jan 2008 17:55:41 +0100
From: Ingo Molnar <mingo@elte.hu>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Peter Osterlund <petero2@telia.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Matthew Wilcox <matthew@wil.cx>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Al Viro <viro@ftp.linux.org.uk>
Subject: Re: [patch] scsi: revert "[SCSI] Get rid of scsi_cmnd->done"
Message-ID: <20080108165541.GD13746@elte.hu>
References: <1199304735.3258.53.camel@localhost.localdomain> <alpine.LFD.1.00.0801021227140.32517@woody.linux-foundation.org> <1199316785.3258.85.camel@localhost.localdomain> <alpine.LFD.1.00.0801021756310.3010@woody.linux-foundation.org> <m3ir27oe7f.fsf@telia.com> <1199627875.5205.1.camel@localhost.localdomain> <20080106144706.GA25419@elte.hu> <1199632845.5205.31.camel@localhost.localdomain> <20080106161207.GB27863@elte.hu> <1199639407.5205.60.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1199639407.5205.60.camel@localhost.localdomain>
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


* James Bottomley <James.Bottomley@HansenPartnership.com> wrote:
> 
> On Sun, 2008-01-06 at 17:12 +0100, Ingo Molnar wrote:
> > * James Bottomley <James.Bottomley@HansenPartnership.com> wrote:
> > 
> > > > The reproducer came to you via Peter Osterlund who has never 
> > > > authored a single drivers/scsi/ commit before (according to git-log) 
> > > > and who (and here i'm out on a limb guessing it) does not even 
> > > > follow linux-scsi@vger.kernel.org.
> > > > 
> > > > this bug was obscure and hidden on linux-scsi@vger.kernel.org 
> > > > for _months_, (it is a rarely visited and rarely read mailing 
> > > > list) and there was just not enough "critical mass" to get this 
> > > > issue fixed.
> > > 
> > > If I were you, I'd actually make a cursory effort to get my facts 
> > > straight before spouting off.
> > > 
> > > This bug was actually hidden in bugzilla for ages, where Matthew 
> > > Wilcox was trying to deal with it on his own. [...]
> > 
> > Huh? The bugzilla just tracked a bug reported to lkml. The very 
> > description of the bugzilla says:
> > 
> >  Subject         : v2.6.24-rc2-409-g9418d5d: attempt to access beyond end of device
> >  Submitter       : Thomas Meyer <thomas@m3y3r.de>
> >  References      : http://lkml.org/lkml/2007/11/13/250
> > 
> > so no, it was evidently not "hidden in bugzilla for ages" - all the 
> > important action happened on lkml.
> 
> ... and your original accusation was "this bug was obscure and hidden 
> on linux-scsi@vger.kernel.org for _months_" which I was pointing out 
> wasn't true.

you are right - let me rephrase it as: "this issue was mainly hidden due 
to the unhealthy ping-pong between lkml (which you said you didnt read), 
linux-scsi and bugzilla".

> Even the original lkml report was obscured by sweeping the report into 
> bugzilla and forgetting about it, so in fact, no action happened, even 
> on lkml.

all the "action" already happened on the first day of reporting the bug. 
(the wrong commit was identified, but that's besides the point - it all 
sat inactive after that point. I pinged the bugzilla to get the lkml 
discussion active again, not to debug it there.)

what got movement into it all again was the revert.

> Can we stop it with the recriminations and blame shifting now. [...]

what "blame shifting" ???

all i'm worried about here is the long latency for a bugfix which very 
apparently (to me) happened due to the isolation of linux-scsi and the 
resulting bug processing inefficiencies. Bugs happen and nobody is to be 
"blamed" for the bug itself - but the bug processing flow was broken and 
i've pointed that out. (If you see similar cases for code i maintain, 
and if you can pinpoint the reason why you think it happened and how to 
improve that, then please point it out to me as well.)

	Ingo
