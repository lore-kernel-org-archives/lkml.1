Return-Path: <linux-kernel-owner+w=401wt.eu-S1759771AbYARMSd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759771AbYARMSd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 07:18:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755201AbYARMS0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 07:18:26 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:54336 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754226AbYARMSZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 07:18:25 -0500
Date: Fri, 18 Jan 2008 13:18:03 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Zan Lynx <zlynx@acm.org>,
       Thomas Gleixner <tglx@linutronix.de>, Len Brown <lenb@kernel.org>,
       linux-kernel@vger.kernel.org
Subject: Re: echo mem > /sys/power/state
Message-ID: <20080118121803.GF11044@elte.hu>
References: <20080116222445.6f7ff66e.akpm@linux-foundation.org> <1200591411.34145.4.camel@localhost> <20080117111355.29554f38.akpm@linux-foundation.org> <200801172238.17176.rjw@sisk.pl> <20080118083610.GA19792@elte.hu> <20080118004725.dcd132ee.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080118004725.dcd132ee.akpm@linux-foundation.org>
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


* Andrew Morton <akpm@linux-foundation.org> wrote:

> > (it doesnt matter if graphics does not resume fine - at least for my 
> > tests)
> > 
> > kprobes had similar problems and it now has a few simple smoke-tests 
> > - which i just saw trigger on a patch that i did not notice would 
> > break kprobes. I think this should be done for all functionality 
> > that is not regularly triggered by a normal distro bootup (and which 
> > is easy to overlook in testing).
> 
> Seeing as we're so lame about being able to distribute userspace 
> stuff: create a shell script in /proc/rc.kernel and start teaching 
> initscripts to run it.  Then we can modify it at will.

would be fine to me. The problem isnt just distribution and the tests 
getting out of sync with the kernel (and its capabilities enabled in the 
.config, etc.), the other problem is unintrusive testing: i for example 
use unmodified images of various distributions, with only a new bzImage 
plopped in. That is an intentionally minimal impact test vector, any 
userspace side changes are discouraged. And that's how many people test 
new kernels, they just plop it in. The moment we require any userlevel 
changes, the testing barrier increases significantly.

[ and a Friday rant: that's why the objection against my 
  make-relatime-actually-useful-to-people patch is so stupid, 
  shortsighted, self-defeating and misplaced. The "Dont put policy into 
  the kernel, use a new mount option and update your /etc/fstab" 
  stupidity that people have been repeating for 10 years without 
  thinking about it is a move that scares away 90% of our testers and
  99% of the distros. See:

    http://people.redhat.com/mingo/relatime-patches/improve-relatime.patch

  Trivial improvement, it's 6 months and still not upstream. We are just 
  so good at shooting in our feet by creating artificial barriers and 
  making it as hard as possible for people to actually use our kernel 
  features ;-) ]

	Ingo
