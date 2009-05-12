Return-Path: <linux-kernel-owner+w=401wt.eu-S1755362AbZELRxs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755362AbZELRxs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 May 2009 13:53:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752038AbZELRxj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 May 2009 13:53:39 -0400
Received: from rankki.sonarnerd.net ([83.145.240.118]:33593 "EHLO
	mail.sonarnerd.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752062AbZELRxi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 May 2009 13:53:38 -0400
Message-ID: <4A09B7A1.2060706@sonarnerd.net>
Date: Tue, 12 May 2009 20:53:37 +0300
From: Jussi Laako <jussi@sonarnerd.net>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Chris Friesen <cfriesen@nortel.com>
CC: Peter Zijlstra <peterz@infradead.org>,
       James Courtier-Dutton <James@superbug.co.uk>,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       d.faggioli@sssup.it
Subject: Re: [RFC][PATCH] Multimedia scheduling class, take 2
References: <4959198A.3020209@sonarnerd.net>	 <1230622925.16718.26.camel@twins>  <4959DE51.2020605@sonarnerd.net>	 <1231756114.19771.6.camel@laptop> <496C6294.2040707@sonarnerd.net>	 <4971D3D5.6040801@superbug.co.uk>  <497CF128.2060903@sonarnerd.net>	 <1232954745.4863.4.camel@laptop>  <4A07E044.8040807@sonarnerd.net> <1242107859.11251.301.camel@twins> <4A094707.5040307@sonarnerd.net> <4A099670.5060902@nortel.com> <4A09A525.4080107@sonarnerd.net> <4A09AB2E.8030002@nortel.com>
In-Reply-To: <4A09AB2E.8030002@nortel.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Chris Friesen wrote:
> Of course, without glibc/pthreads support you would only be able to set
> the nice level for the current thread since you don't have any way to
> map from "pthread_t *" to tid.  And you wouldn't be able to create new
> threads with a particular nice level already set.

This is the problem... It has to work this way, otherwise it's pretty
useless.

> But that argument
> holds true for a new sched policy as well, because glibc checks the
> policy internally and only knows about the normal three.

Don't tell that to my system, where also SCHED_IDLE, SCHED_BATCH (which
are btw not listed on POSIX either) ...and... SCHED_MM work. It goes
directly to kernel which does the checks and fails if it sees fit.

> This option extends the "nice" API rather than the static priority API,
> so all of the above would still have a static priority of 0 for SCHED_OTHER.

For extending "nice" API, I would first ask for extension in POSIX, and
once it's there I could think about implementation.

And still this doesn't solve the second level problem.


	- Jussi
