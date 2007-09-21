Return-Path: <linux-kernel-owner+w=401wt.eu-S1755628AbXIUIYT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755628AbXIUIYT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2007 04:24:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753572AbXIUIYI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Sep 2007 04:24:08 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:60249 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752994AbXIUIYG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2007 04:24:06 -0400
Date: Fri, 21 Sep 2007 01:22:48 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Matthias Hensler <matthias@wspse.de>
Cc: Chuck Ebbert <cebbert@redhat.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       richard kennedy <richard@rsk.demon.co.uk>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: Processes spinning forever, apparently in lock_timer_base()?
Message-Id: <20070921012248.3d2e9cd9.akpm@linux-foundation.org>
In-Reply-To: <20070921080808.GA28849@kobayashi-maru.wspse.de>
References: <46B10BB7.60900@redhat.com>
	<20070803113407.0b04d44e.akpm@linux-foundation.org>
	<20070804084426.GA20464@kobayashi-maru.wspse.de>
	<20070809095943.GA7763@kobayashi-maru.wspse.de>
	<20070809095534.25ae1c42.akpm@linux-foundation.org>
	<46F2E103.8000907@redhat.com>
	<20070920142927.d87ab5af.akpm@linux-foundation.org>
	<46F2EE76.4000203@redhat.com>
	<20070920153654.b9e90616.akpm@linux-foundation.org>
	<20070921080808.GA28849@kobayashi-maru.wspse.de>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 21 Sep 2007 10:08:08 +0200 Matthias Hensler <matthias@wspse.de> wrote:

> On Thu, Sep 20, 2007 at 03:36:54PM -0700, Andrew Morton wrote:
> > That's all a bit crappy if the wrong races happen and some other task
> > is somehow exceeding the dirty limits each time this task polls them.
> > Seems unlikely that such a condition would persist forever.
> 
> How exactly do you define forever? It looks to me, that this condition
> never resolves on its own, at least not in a window of several hours
> (the system used to get stuck around 3am and was normally rebooted
> between 7am and 8am, so at least hours are not enough to have the problem
> resolve on its own).

That's forever.

> > So the question is, why do we have large amounts of dirty pages for
> > one disk which appear to be sitting there not getting written?
> 
> Unfortunately I have no idea. The full stacktrace for all processes was
> attached to the original bugreport, maybe that can give a clue to that.
> 
> > Do we know if there's any writeout at all happening when the system is
> > in this state?
> 
> Not sure about that. The system is responsible on a still open SSH
> session, allowing several tasks still to be executed. However, that SSH
> session gets stuck very fast if the wrong commands are executed. New
> logins are not possible (Connection is akzepted but resulting in a
> timeout 60 seconds later, so most likely /bin/login is not able to log
> into wtmp).
> 
> From all that I suspect that there is no more write activity on that
> system, but cannot say for sure.

Easiest would be to run `vmstat 1' in a separate ssh session then just
leave it running.

> > Did anyone try running /bin/sync when the system is in this state?
> 
> I did not, no.

Would be interesting if poss, please.
