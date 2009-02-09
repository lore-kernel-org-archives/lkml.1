Return-Path: <linux-kernel-owner+w=401wt.eu-S1756127AbZBIXXz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756127AbZBIXXz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Feb 2009 18:23:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752751AbZBIXXq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Feb 2009 18:23:46 -0500
Received: from x35.xmailserver.org ([64.71.152.41]:49808 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752038AbZBIXXp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Feb 2009 18:23:45 -0500
X-AuthUser: davidel@xmailserver.org
Date: Mon, 9 Feb 2009 15:23:43 -0800 (PST)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Michael Kerrisk <mtk.manpages@gmail.com>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [patch 2/2] timerfd extend clockid support
In-Reply-To: <cfd18e0f0902091503o52f551ceu559fff657e1cc7c9@mail.gmail.com>
Message-ID: <alpine.DEB.1.10.0902091523010.8503@alien.or.mcafeemobile.com>
References: <alpine.DEB.1.10.0902081510150.18839@alien.or.mcafeemobile.com>  <cfd18e0f0902090128i1a4902f4of0d4d830b567602f@mail.gmail.com>  <alpine.DEB.1.10.0902090940100.8084@alien.or.mcafeemobile.com>  <cfd18e0f0902091128pf5723c8rcfa1c08d77d4e55d@mail.gmail.com>
  <alpine.DEB.1.10.0902091148520.8503@alien.or.mcafeemobile.com> <cfd18e0f0902091503o52f551ceu559fff657e1cc7c9@mail.gmail.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 10 Feb 2009, Michael Kerrisk wrote:

> On Tue, Feb 10, 2009 at 9:10 AM, Davide Libenzi <davidel@xmailserver.org> wrote:
> > On Tue, 10 Feb 2009, Michael Kerrisk wrote:
> >
> >> > and I did not have even the time to peek
> >> > into the core timer code to see if the usage of other timer types in
> >> > eventfd would create problems. That's why I asked Thomas if they'd behave
> >> > differently from an hrtimer caller POV.
> >> > I'll try to take a look by myself today or tomorrow.
> >>
> >> Okay -- hopefully my test program may be useful (even if it is not
> >> itself fully tested yet, it's patterned after a similar test program I
> >> wrote fot the POSIX timers API, so it should mostly work).
> >
> > Answer was pretty easy once you look at the code :)
> > Timerfd uses core hrtimer functions, and clockids different from the ones
> > timerfd already handles, fall into the CPU-timers domain. Domain that is
> > not handled by hrtimer.
> > Changes to timerfd to support CPU-based timers are really deep (more than
> > changes, is a total rewrite). not only to timerfd, but also to CPU-based
> > timers to deliver notification by means different than signals.
> > Given the amount of code change, and given that a posix-timers->signalfd
> > bridge could solve the problem, I'm not going even close to suggest such a
> > change.
> 
> Davide,
> 
> Will you nevertheless push the patch that adds the EINVAL flags checks?

Sure, I'll send it to Greg and Andrew.


- Davide


