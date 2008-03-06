Return-Path: <linux-kernel-owner+w=401wt.eu-S1765326AbYCFVmp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765326AbYCFVmp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2008 16:42:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753463AbYCFVmd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Mar 2008 16:42:33 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:54162 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752587AbYCFVmc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2008 16:42:32 -0500
Date: Thu, 6 Mar 2008 22:42:18 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Pavel Machek <pavel@ucw.cz>
Cc: "H. Peter Anvin" <hpa@zytor.com>,
       Pawel Plociennik <paplociennik@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2.6.24] chroot= as a new kernel parameter
Message-ID: <20080306214218.GA886@elte.hu>
References: <200803060001.38432.paplociennik@gmail.com> <47CF79E4.3030107@zytor.com> <20080306102712.GE13391@elte.hu> <47D00B16.6040004@zytor.com> <20080306212028.GB1747@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080306212028.GB1747@elf.ucw.cz>
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


* Pavel Machek <pavel@ucw.cz> wrote:

> No, that will not work, if you don't have libraries at /. This should
> be exact replacement:
> 
> init=/working_distro/lib/ld-linux.so.2 --library-path 
> /working_distro/lib /working_distro/usr/sbin/chroot /working_distro/ 
> /sbin/init

ouch ...

> ...assuming your chroot uses ld-linux.so.2. I believe above is ugly 
> enough to warrant merge of chroot= option.
> 
> ...heck, how many tries would it take to get that right? Is chroot 
> /usr/sbin or /sbin?
> 
> This really should be in kernel, I should not have to partition my
> disk to get booting to few different distros.

agreed ...

i really find it so disheartening at times that people fight trivial 
usability additions tooth and nail in a _9 million lines of code_ kernel 
with a ... "bloat" argument.

Lets face it: Linux is _still_ hard and a pain to administer, our kernel 
boot parameters are ad-hoc, they dont match up to the .config parameters 
and it is all a total mess. There's absolutely no design behind them 
(look at all the inconsistent parameter forms for turning off smp, acpi, 
hpet, nohz, etc.).

if RAM overhead of a new boot option would really be an issue on smaller 
setups then the right solution is to make a new .config option that 
hardcodes a specific command line and _disable_ all the commandline 
parsing. That would also be a nice security feature for certain setups 
and would save _a lot more_ RAM than another rejected boot parameter. 
Really, all the 'bloat' based objections are totally, utterly silly.

i had a similar experience when i added the relatime boot option:

  http://people.redhat.com/mingo/relatime-patches/improve-relatime.patch

Look back the lkml discussion for all the "bloat" and "use /etc/fstab" 
clowning around that happened when i sent that patch ... and we still 
have no good configuration vectors to turn atime off. I'd rate it good 
comedy that happened around that patch: "Kernel hackers shoot in their 
own foot and are proud of it".

multiple, consistent vectors for configurability are _GOOD_. That was 
the success story behind Apache. Forcing everyone into a "you must use 
an initrd for this" idea is 80's thinking and actively harmful to Linux.

	Ingo
