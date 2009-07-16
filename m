Return-Path: <linux-kernel-owner+w=401wt.eu-S933486AbZGPWea@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933486AbZGPWea (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jul 2009 18:34:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932938AbZGPWe3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Jul 2009 18:34:29 -0400
Received: from mail-ew0-f226.google.com ([209.85.219.226]:40653 "EHLO
	mail-ew0-f226.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932898AbZGPWe2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jul 2009 18:34:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Xz5ElxOJRoKQFpA5slPwIrs1j3tUI8JOJQ2vJrr/UhpgED5FjBklZnc48gNW3Nw+mk
         fXn+19SWpMuhxn2/nhqjeb78WdvTotaJfnG3YTHtNwC2qzJChxowRhlpDH97BaZZyxDE
         lcGjFnHuVhbQqMbqKGHCOSuoiy4kKmZcBm+iU=
MIME-Version: 1.0
In-Reply-To: <20090716221514.GC27757@cs.fsu.edu>
References: <1247336891.9978.32.camel@laptop>
	 <1247412708.6704.105.camel@laptop>
	 <1247499843.8107.548.camel@Palantir> <1247505941.7500.39.camel@twins>
	 <5B78D181-E446-4266-B9DD-AC0A2629C638@soe.ucsc.edu>
	 <20090713201305.GA25386@cs.fsu.edu> <4A5BAAE7.5020906@nortel.com>
	 <20090715231109.GH14993@cs.fsu.edu> <1247731113.15471.24.camel@twins>
	 <20090716221514.GC27757@cs.fsu.edu>
Date: Thu, 16 Jul 2009 17:34:25 -0500
Message-ID: <1ca41c0f0907161534j1918bb44m73f8005d47258534@mail.gmail.com>
Subject: Re: RFC for a new Scheduling policy/class in the Linux-kernel
From: Karthik Singaram Lakshmanan <karthiksingaram@gmail.com>
To: Ted Baker <baker@cs.fsu.edu>
Cc: Peter Zijlstra <peterz@infradead.org>, Chris Friesen <cfriesen@nortel.com>,
       Noah Watkins <jayhawk@soe.ucsc.edu>, Raistlin <raistlin@linux.it>,
       Douglas Niehaus <niehaus@ittc.ku.edu>, Henrik Austad <henrik@austad.us>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Bill Huey <billh@gnuppy.monkey.org>,
       Linux RT <linux-rt-users@vger.kernel.org>,
       Fabio Checconi <fabio@gandalf.sssup.it>,
       "James H. Anderson" <anderson@cs.unc.edu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Dhaval Giani <dhaval.giani@gmail.com>,
       KUSP Google Group <kusp@googlegroups.com>,
       Tommaso Cucinotta <cucinotta@sssup.it>,
       Giuseppe Lipari <lipari@retis.sssup.it>, Raj Rajkumar <raj@ece.cmu.edu>,
       dionisio@sei.cmu.edu
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I still conceptually prefer the idea of granting locks to
> contending tasks in priority order, of course.  It is just a
> question of whether you want to have to agree (1) that all
> scheduling is based on priority, and (2) pay the price for either
> (2a) dynamically re-ordering all those queues every time a task
> gains or loses priority (due to inheritance, or whatever), or (2b)
> pay the O(n) price of scanning the queue for the currently
> highest-priority task when you grant the lock.  If you go this
> way, I would favor the latter.  In any system that does not
> already have poor performance due to excessive lock contention,
> the queues should rarely have more than one member.  Assuming
> integrity of the queue is maintained by the corresponding lock
> itself, it is much easier to do this scanning at the point the
> lock is released than to support (asynchronous) queue reordering
> for every potential priority change.
>
Just chiming in that from an implementation perspective, we could use
a priority bitmap of active tasks contending for the lock. An
implementation similar to the one used by the O(1) scheduler can be of
great use here. Hardware support like "find_first_bit" can drastically
reduce the time taken to search for the highest-priority task pending
on the lock. Given realistic values for the number of distinct
priority values required by most practical systems, such an
implementation could prove effective.

Thanks,
Karthik
