Return-Path: <linux-kernel-owner+w=401wt.eu-S1755404AbZAMD2c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755404AbZAMD2c (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2009 22:28:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757070AbZAMD2F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Jan 2009 22:28:05 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:50203 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756666AbZAMD2C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2009 22:28:02 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: "Mike Snitzer" <snitzer@gmail.com>
Cc: "Ingo Molnar" <mingo@elte.hu>, "Nicholas Miell" <nmiell@comcast.net>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "jim owens" <jowens@hp.com>, "H. Peter Anvin" <hpa@zytor.com>,
       "Chris Mason" <chris.mason@oracle.com>,
       "Peter Zijlstra" <peterz@infradead.org>,
       "Steven Rostedt" <rostedt@goodmis.org>, paulmck@linux.vnet.ibm.com,
       "Gregory Haskins" <ghaskins@novell.com>,
       "Matthew Wilcox" <matthew@wil.cx>, "Andi Kleen" <andi@firstfloor.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       linux-btrfs <linux-btrfs@vger.kernel.org>,
       "Thomas Gleixner" <tglx@linutronix.de>, "Nick Piggin" <npiggin@suse.de>,
       "Peter Morreale" <pmorreale@novell.com>,
       "Sven Dietrich" <SDietrich@novell.com>, sam@ravnborg.org,
       "Dave Anderson" <anderson@redhat.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Kexec Mailing List <kexec@lists.infradead.org>
References: <170fa0d20901100621m74680e0ewd1916c70f1636c9b@mail.gmail.com>
	<20090110153446.GA13976@elte.hu>
	<170fa0d20901101021s3b9a18e9qe6150c374efa4d6f@mail.gmail.com>
	<20090111012811.GG12885@elte.hu>
	<170fa0d20901102052s7488ff0bl14507169fd4c03b3@mail.gmail.com>
Date: Mon, 12 Jan 2009 19:19:32 -0800
In-Reply-To: <170fa0d20901102052s7488ff0bl14507169fd4c03b3@mail.gmail.com>
	(Mike Snitzer's message of "Sat, 10 Jan 2009 23:52:11 -0500")
Message-ID: <m1tz83x58b.fsf@frodo.ebiederm.org>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=mx04.mta.xmission.com;;;ip=24.130.11.59;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 24.130.11.59
X-SA-Exim-Rcpt-To: too long (recipient list exceeded maximum allowed size of 128 bytes)
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa02 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;"Mike Snitzer" <snitzer@gmail.com>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa02 1397; Body=1 Fuz1=1 Fuz2=1]
	*  3.0 XMStockSpam_06 Stock Index Spam Sym,Price
	*  0.0 XM_SPF_Neutral SPF-Neutral
Subject: Re: source line numbers with x86_64 modules? [Was: Re: [patch] measurements, numbers about CONFIG_OPTIMIZE_INLINING=y impact]
X-SA-Exim-Version: 4.2.1 (built Thu, 07 Dec 2006 04:40:56 +0000)
X-SA-Exim-Scanned: Yes (on mx04.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Mike Snitzer" <snitzer@gmail.com> writes:

> On Sat, Jan 10, 2009 at 8:28 PM, Ingo Molnar <mingo@elte.hu> wrote:
>>
>> Note, back when kdump was added to the kernel many moons ago i strongly
>> supported it and helped out with the patches, etc. I still think it might
>> have the potential to become big - but it needs a ton of tech and care to
>> reach that level of convenience.
>>
>> 'kdump light' perhaps that dumps the most important data structures like
>> registers of all CPUs, task struct and the symbol tables, the current task
>> itself including the kernel stack plus the surrounding 4K of all pointers
>> that are in current registers and that point into kernel memory - maybe
>> straight to kerneloops.org [if the user agrees] - or something like that.
>
> I think 'kdump light' is a good idea.  I'm all for infrastructure that
> works better for more people.  Having to deal with multi-gigabyte dump
> files can be a chore.
>
> The mechanics of dumping your suggested 'light' amount of data vs. all
> memory should be configurable (e.g. /sys/kernel/kexec_crash_light).

Not in sys because this is a user space configuration issue.
All of the dumping happens from user space.  The kernel just provides
access to the state of the previous kernel.

> And this obviously doesn't change the potentially fragile nature of
> kexec'ing to a crash kernel from an arbitrary context; or the fact
> that drivers can easily be incompatible with cleanly shutting down and
> restarting on kexec.

Yep.  Although the general answer in the kdump case is that if
the kdump kernel is running you have gotten past all of the driver
problems.  

> But honestly 99+% of my filesystem/storage enduced Linux crashes
> kexec/kdump properly (with RHEL5, 2.6.22, 2.6.25, and 2.6.28); so all
> the hard work of people like yourself and other kexec/kdump hackers
> (upstream and at RedHat) really is paying off for real Linux users!

Thanks.  It is good to hear that the code works in the field.

> Now if only I could fix line numbers when debugging crashes in x86_64
> modules with the crash utility! :)

It's a userspace problem...

All of the little usability things are userspace problems.

I won't claim that it is trivial because it is a userspace problem, at the same
time there is no reason to wait for any kernel features to merge etc.  Someone
just has to scratch an itch and go fix it.

Eric
