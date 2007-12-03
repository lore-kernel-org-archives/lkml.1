Return-Path: <linux-kernel-owner+w=401wt.eu-S1753693AbXLCKY1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753693AbXLCKY1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2007 05:24:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751912AbXLCKYU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Dec 2007 05:24:20 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:35988 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751726AbXLCKYT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2007 05:24:19 -0500
Date: Mon, 3 Dec 2007 11:23:55 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Radoslaw Szkodzinski <lkml@astralstorm.puszkin.org>
Cc: Andi Kleen <andi@firstfloor.org>, Arjan van de Ven <arjan@infradead.org>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [feature] automatically detect hung TASK_UNINTERRUPTIBLE tasks
Message-ID: <20071203102355.GC30050@elte.hu>
References: <20071202185945.GA25990@elte.hu> <20071202114152.3bf4332d@laptopd505.fenrus.org> <20071202200953.GA23994@one.firstfloor.org> <20071202202602.GA16480@elte.hu> <20071202204725.GA25891@one.firstfloor.org> <20071202144331.6abf1289@laptopd505.fenrus.org> <20071203000741.GB26636@one.firstfloor.org> <20071202165913.3eaebee6@laptopd505.fenrus.org> <20071203095501.GB28560@one.firstfloor.org> <20071203111520.33ed2139@astralstorm.puszkin.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071203111520.33ed2139@astralstorm.puszkin.org>
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


* Radoslaw Szkodzinski <lkml@astralstorm.puszkin.org> wrote:

> > iirc TASK_KILLABLE fixed NFS only. While that's a good thing there 
> > are unfortunately a lot more subsystems that would need the same 
> > treatment.
> 
> Yes, that's exactly why the patch is needed - to find the bugs and fix 
> them. Otherwise you'll have problems finding some places to convert to 
> TASK_KILLABLE.
> 
> CIFS and similar have to be fixed - it tends to lock the app using it, 
> in unkillable state.

Amen. I still have to see a single rational argument against this 
debugging feature - and tons of arguments were listed in favor of it. So 
let's just try and see what happens.

> > Yes let's break things first instead of looking at the implications 
> > closely.
> 
> Throwing _rare_ stack traces is not breakage. 120s 
> task_uninterruptible in the usual case (no errors) is already broken - 
> there are no sane loads that can invoke that IMO.
> 
> A stack trace on x subsystem error is not that bad, especially as 
> these are limited to 10 per session.

we could lower that limit to 1 per bootup - if they become annoying. 
There's lots of flexibility in the code. Really, we should have done 
this 10 years ago - it would have literally saved me many days of 
debugging time combined, and i really have experience in identifying 
such bad tasks. (and it would have sped up debugging in countless number 
of instances when users were met with an uninterruptible task.)

	Ingo
