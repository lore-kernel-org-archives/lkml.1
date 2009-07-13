Return-Path: <linux-kernel-owner+w=401wt.eu-S1756451AbZGMQdt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756451AbZGMQdt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jul 2009 12:33:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756323AbZGMQds
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Jul 2009 12:33:48 -0400
Received: from zrtps0kp.nortel.com ([47.140.192.56]:55112 "EHLO
	zrtps0kp.nortel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755870AbZGMQds (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jul 2009 12:33:48 -0400
Message-ID: <4A5B61DF.8090101@nortel.com>
Date: Mon, 13 Jul 2009 10:33:35 -0600
From: "Chris Friesen" <cfriesen@nortel.com>
User-Agent: Thunderbird 2.0.0.22 (X11/20090605)
MIME-Version: 1.0
To: Raistlin <raistlin@linux.it>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Douglas Niehaus <niehaus@ittc.ku.edu>, Henrik Austad <henrik@austad.us>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Bill Huey <billh@gnuppy.monkey.org>,
       Linux RT <linux-rt-users@vger.kernel.org>,
       Fabio Checconi <fabio@gandalf.sssup.it>,
       "James H. Anderson" <anderson@cs.unc.edu>,
       Thomas Gleixner <tglx@linutronix.de>, Ted Baker <baker@cs.fsu.edu>,
       Dhaval Giani <dhaval.giani@gmail.com>,
       Noah Watkins <jayhawk@soe.ucsc.edu>,
       KUSP Google Group <kusp@googlegroups.com>,
       Tommaso Cucinotta <cucinotta@sssup.it>,
       Giuseppe Lipari <lipari@retis.sssup.it>
Subject: Re: RFC for a new Scheduling policy/class in the Linux-kernel
References: <200907102350.47124.henrik@austad.us>	 <1247336891.9978.32.camel@laptop>  <4A594D2D.3080101@ittc.ku.edu>	 <1247412708.6704.105.camel@laptop> <1247499843.8107.548.camel@Palantir>
In-Reply-To: <1247499843.8107.548.camel@Palantir>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 13 Jul 2009 16:33:37.0005 (UTC) FILETIME=[ABE209D0:01CA03D7]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Raistlin wrote:

> Very basically: from the analysis point of view one easy and effective
> solution would be to have the blocked-running tasks --i.e., the tasks
> blocked on some lock that have been left on the rq to proxy-execute the
> lock owner-- busy waiting while the lock owner is running. This allows
> for retaining a lot of nice properties BWI already has, as far as
> analyzability is concerned.
> 
> On the other hand, from the practical end efficiency point of view, it
> would be not that difficult to block these otherwise-spinning tasks, in
> order to avoid wasting CPU time too much... The only important thing is
> to properly account the budget of the correct server/group (which
> probably must be the otherwise-spinning task's one), or the analysis is
> gone again! :-O

Could you elaborate on this "proper accounting"?

If task A is blocked waiting for a lock (held by a task B on another
cpu) and we run task C instead, how would you propose that the
accounting be handled?

Chris
