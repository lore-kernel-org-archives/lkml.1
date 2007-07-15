Return-Path: <linux-kernel-owner+w=401wt.eu-S1761295AbXGOM7S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761295AbXGOM7S (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jul 2007 08:59:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753003AbXGOM7L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Jul 2007 08:59:11 -0400
Received: from mx.treblig.org ([80.68.94.177]:4421 "EHLO mx.treblig.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751751AbXGOM7K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jul 2007 08:59:10 -0400
Date: Sun, 15 Jul 2007 13:58:56 +0100
From: "Dr. David Alan Gilbert" <linux@treblig.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Alan Stern <stern@rowland.harvard.edu>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       "Huang, Ying" <ying.huang@intel.com>,
       Jeremy Maitin-Shepard <jbms@cmu.edu>,
       Kyle Moffett <mrmacman_g4@mac.com>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       Pavel Machek <pavel@ucw.cz>,
       pm list <linux-pm@lists.linux-foundation.org>, david@lang.hm,
       Al Boldi <a1426z@gawab.com>
Subject: Re: Hibernation considerations
Message-ID: <20070715125855.GA1737@gallifrey>
References: <200707151433.34625.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200707151433.34625.rjw@sisk.pl>
X-Chocolate: 70 percent or better cocoa solids preferably
X-Operating-System: Linux/2.6.20.3-bytemark-uml-2 (i686)
X-Uptime: 13:52:25 up 72 days,  6:35,  1 user,  load average: 0.35, 0.44, 0.49
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Rafael J. Wysocki (rjw@sisk.pl) wrote:

> (5) Hibernation should be transparent from the applications' point of view
> 
>     Generally, applications should not notice that hibernation took place.
>     [Note that I don't regard all processes as applications and I think that
>     there may be processes which need to handle the hibernation in a special
>     way.]  Ideally, for example, if some audio is being played when a
>     hibernation starts, the audio player should be able to continue playing the
>     same audio after the restore from the point in which it has been
>     interrupted by the hibernation.  Also, the CPU affinities and similar

That would be _so_ embarrassing in a library; I'd rather the audio
player had the opportunity to consider whether restarting was a good idea.

> (6) State of devices from before hibernation should be restored, if possible
> 
>     If possible, during a restore devices should be brought back to the same
>     state in which they were before the corresponding hibernation.  Of course
>     in some situations it might be impossible to do that (eg. the user
>     connected the hibernated system to a different IP subnet and then
>     restored), but as a general rule, we should do our best to restore the
>     state of devices, which is directly related to point (5) above.

Or the user unplugs their flash drive after hibernation rather than before.

Two things which I think would be nice to consider are:
   1) Encryption - I'd actually prefer if my luks device did not
       remember the key accross a hibernation; I want to be forced to
       reenter the phrase.  However I don't know what the best thing
       to do to partitions/applications using the luks device is.

   2) Some level of debugging needs to be available so that users can
      provide something so you can see why something hasn't hibernated
      or why (as in the case of this tosh laptop) it still takes power
      during hibernation.

Dave
-- 
 -----Open up your eyes, open up your mind, open up your code -------   
/ Dr. David Alan Gilbert    | Running GNU/Linux on Alpha,68K| Happy  \ 
\ gro.gilbert @ treblig.org | MIPS,x86,ARM,SPARC,PPC & HPPA | In Hex /
 \ _________________________|_____ http://www.treblig.org   |_______/
