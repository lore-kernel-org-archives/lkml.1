Return-Path: <linux-kernel-owner+w=401wt.eu-S1756438AbZKJOez@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756438AbZKJOez (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Nov 2009 09:34:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756246AbZKJOey
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Nov 2009 09:34:54 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:59896 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756183AbZKJOex (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Nov 2009 09:34:53 -0500
Subject: Re: [PATCH] DRTL kernel 2.6.32-rc3 : SCHED_EDF, DI RT-Mutex,
 Deadline  Based Interrupt Handlers
From: Peter Zijlstra <peterz@infradead.org>
To: Raistlin <raistlin@linux.it>
Cc: Soumya K S <ssks.mt@gmail.com>, linux-kernel@vger.kernel.org,
       mingo@redhat.com, Dhaval Giani <dhaval.giani@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Claudio Scordino <claudio@evidence.eu.com>,
       michael trimarchi <trimarchi@gandalf.sssup.it>,
       Juri Lelli <juri.lelli@gmail.com>
In-Reply-To: <1256747090.25821.367.camel@Palantir>
References: <e932a33e0910210833j1fab6129m23b55101c5978c4a@mail.gmail.com>
	 <e932a33e0910210838j3be9286bo3953c4cae3f0e12e@mail.gmail.com>
	 <1256198088.6700.76.camel@Palantir>
	 <e932a33e0910220742v5d99adbere9fc9c31f72b6b95@mail.gmail.com>
	 <1256460376.15273.31.camel@Palantir>
	 <e932a33e0910280715u1722b8b4k9dabda45c61151ad@mail.gmail.com>
	 <1256747090.25821.367.camel@Palantir>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 10 Nov 2009 15:34:48 +0100
Message-ID: <1257863689.4108.441.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-10-28 at 17:24 +0100, Raistlin wrote:
> Relying on userspace to do things
> 'intelligently' is something I'm not sure I would do, especially in a so
> much general purpose OS like Linux, used in so much different contexts.
> But, again, that's only my opinion. :-) 

I'd put it even stronger, relying on userspace to do something
intelligent is utterly stupid. We have to assume userspace is hostile
and out to get you.

Therefore I fully support the model that puts admission control into the
kernel, because that provides isolation between, and guarantees to
applications.

Not providing this, and having no overload protection is one of the
biggest failures of SCHED_FIFO/RR.

On Tue, 2009-11-10 at 19:33 +0530, Soumya K S wrote:
> Hmm I guess you too are "totally" dependent on user giving you the
> right parameters _intelligently_ (deadline / budget)... I guess we are
> not too different there expecting the users to be _aware_ ..!

The difference is that if A messes up its own parameters only A suffers
and the rest of the system continues to work as expected.

With your approach anything is out the window.

So yes, userspace needs to be aware, but a task can only screw itself,
not everybody else, which is a very important feature.

@ DRTL folks:

If you want deadline based scheduling (it appears you do) I suggest you
start helping out Dario, your proposal isn't going to happen.

