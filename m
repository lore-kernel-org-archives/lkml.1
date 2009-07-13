Return-Path: <linux-kernel-owner+w=401wt.eu-S1756698AbZGMR2c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756698AbZGMR2c (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jul 2009 13:28:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756663AbZGMR2b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Jul 2009 13:28:31 -0400
Received: from viefep14-int.chello.at ([62.179.121.34]:16460 "EHLO
	viefep14-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756438AbZGMR2a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jul 2009 13:28:30 -0400
X-SourceIP: 213.93.53.227
Subject: Re: RFC for a new Scheduling policy/class in the Linux-kernel
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Raistlin <raistlin@linux.it>
Cc: Douglas Niehaus <niehaus@ittc.ku.edu>, Henrik Austad <henrik@austad.us>,
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
In-Reply-To: <1247499843.8107.548.camel@Palantir>
References: <200907102350.47124.henrik@austad.us>
	 <1247336891.9978.32.camel@laptop>  <4A594D2D.3080101@ittc.ku.edu>
	 <1247412708.6704.105.camel@laptop>  <1247499843.8107.548.camel@Palantir>
Content-Type: text/plain
Date: Mon, 13 Jul 2009 19:28:22 +0200
Message-Id: <1247506102.7500.41.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-07-13 at 17:44 +0200, Raistlin wrote:
> What we would like to achieve is some set of rules that, extending the
> UP ones, yield a situation which is both:
> - analyzable from the real-time theorist's point of view... Which is
>   (un?)fortunately what we are :-)
> - possible to implement... Which is not always (un!)fortunately obvious 
>   here :-)

I would very much like a proper theoretical foundation for whatever we
end up with ;-)

> Very basically: from the analysis point of view one easy and effective
> solution would be to have the blocked-running tasks --i.e., the tasks
> blocked on some lock that have been left on the rq to proxy-execute the
> lock owner-- busy waiting while the lock owner is running. This allows
> for retaining a lot of nice properties BWI already has, as far as
> analyzability is concerned.

Right, practically we cannot do this, since we expose the block graph to
userspace and you could in userspace construct a program that would
exploit this spinning to DoS the system.

