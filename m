Return-Path: <linux-kernel-owner+w=401wt.eu-S1030831AbXCNJne@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030831AbXCNJne (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2007 05:43:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030832AbXCNJne
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Mar 2007 05:43:34 -0400
Received: from hermes2.dur.ac.uk ([129.234.8.21]:49162 "EHLO hermes2.dur.ac.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030831AbXCNJnd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2007 05:43:33 -0400
Date: Wed, 14 Mar 2007 09:47:11 +0000
From: Ash Milsted <thatistosayiseenem@gawab.com>
To: "Chris Friesen" <cfriesen@nortel.com>
Cc: Lee Revell <rlrevell@joe-job.com>, Con Kolivas <kernel@kolivas.org>,
       linux kernel mailing list <linux-kernel@vger.kernel.org>,
       ck list <ck@vds.kolivas.org>
Subject: Re: [ck] RSDL v0.30 cpu scheduler for mainline kernels
Message-Id: <20070314094711.d0d3a580.thatistosayiseenem@gawab.com>
In-Reply-To: <45F6E34E.9020308@nortel.com>
References: <200703121058.11966.kernel@kolivas.org>
	<20070313153514.428dc3e1.thatistosayiseenem@gawab.com>
	<75b66ecd0703130853p4c7d029en2405caee4447d29e@mail.gmail.com>
	<45F6E34E.9020308@nortel.com>
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.10.9; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-DurhamAcUk-MailScanner: Found to be clean, Found to be clean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 13 Mar 2007 11:45:50 -0600
"Chris Friesen" <cfriesen@nortel.com> wrote:

> Lee Revell wrote:
> 
> > Sounds like Wengophone is broken.  It should be using RT threads for
> > time critical work, as JACK and Ardour2 are doing.
> 
> If the app has root privileges to set RT policy, then it could also set 
> deeply negative nice values as well.
> 
> Doesn't reallly help the regular user with no privileges.
> 
> Chris

Well my distro (Arch) does have the relevant PAM support for giving
users realtime capabilities, but naturally Wengophone is not designed
to make use of them (does any internet phone do this?). The
main problem is that it worked fine on mainline and does not with RSDL,
and even boosting it to nice -19 (with root privs) makes no difference
(although I only tested nice -19 with the slightly dodgy patch Con
posted for Mike Galbraith, that patch reportedly only affects a few
positive nice values). Two possibilities occur to me:

1. RSDL just isn't giving sched_other tasks as low latency as
mainline (Wengophone is not using much CPU time from as far as
top can tell).

2. The problem is actually caused by increased network latency
somehow caused by RSDL (this is an internet phone).

I would like to add that the problem seems to be latency *spikes* that
occur when there is sudden activity in another app (say, I open a
folder in nautilus) that was previously largely idle.
I suppose if Con does what he says and reduces latency overall, this
problem might disappear. For now, of course, I hope his neck gets
better :)
