Return-Path: <linux-kernel-owner+w=401wt.eu-S1755523AbYCYNRv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755523AbYCYNRv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2008 09:17:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754118AbYCYNRa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Mar 2008 09:17:30 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:37129 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754106AbYCYNR3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2008 09:17:29 -0400
Date: Tue, 25 Mar 2008 14:17:08 +0100
From: Ingo Molnar <mingo@elte.hu>
To: David Miller <davem@davemloft.net>
Cc: jirislaby@gmail.com, viro@ZenIV.linux.org.uk, joe@perches.com,
       tglx@linutronix.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 109/148] include/asm-x86/serial.h: checkpatch cleanups
	- formatting only
Message-ID: <20080325131708.GB9612@elte.hu>
References: <47E64BF7.4070808@gmail.com> <20080323.053037.144236584.davem@davemloft.net> <20080325084457.GA32103@elte.hu> <20080325.024204.175042056.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080325.024204.175042056.davem@davemloft.net>
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


* David Miller <davem@davemloft.net> wrote:

> > could you please give me a file name as an example that i could 
> > double-check myself? Thanks,
> 
> I can't because I pacified it to cut down the review noise for the 
> patch in question last time it happened.

ok, so i'll have to come up with some hard data about code you maintain 
i guess - please provide contrary data if you have it.

Using the "code-quality" script mentioned at:

   http://people.redhat.com/mingo/x86.git/README

on the Sparc64 tree:

   $ code-quality `find arch/sparc64/ include/asm-sparc64/ -name '*.c'` | 
        tee ~/quality-sparc.txt
   $ sort -n -k 4 ~/quality-sparc.txt | tail -20

shows the following "20 worst files":

                                      errors   lines of code   errors/KLOC
arch/sparc64/kernel/sys_sparc32.c         48            1034          46.4
arch/sparc64/kernel/signal32.c            65            1392          46.6
arch/sparc64/kernel/sys_sunos32.c         73            1360          53.6
arch/sparc64/solaris/misc.c               43             787          54.6
arch/sparc64/solaris/socket.c             30             462          64.9
arch/sparc64/kernel/binfmt_aout32.c       34             420          80.9
arch/sparc64/oprofile/init.c               2              24          83.3
arch/sparc64/solaris/fs.c                 64             746          85.7
arch/sparc64/prom/devops.c                 4              42          95.2
arch/sparc64/prom/console.c                8              75         106.6
arch/sparc64/solaris/ioctl.c              89             826         107.7
arch/sparc64/kernel/cpu.c                 17             155         109.6
arch/sparc64/solaris/ipc.c                19             127         149.6
arch/sparc64/solaris/timod.c             157             977         160.6
arch/sparc64/kernel/sunos_ioctl32.c       49             276         177.5
arch/sparc64/solaris/signal.c             81             430         188.3
arch/sparc64/solaris/socksys.c            39             204         191.1
arch/sparc64/prom/tree.c                  58             300         193.3
arch/sparc64/math-emu/math.c             215             514         418.2
arch/sparc64/boot/piggyback.c             47             110         427.2

most of these are certainly legacy stuff that dont matter to active 
maintenance anymore (nobody will ever change math-emu/math.c i hope), 
but for example looking at:

  scripts/checkpatch.pl --file arch/sparc64/kernel/cpu.c
  [...]
  total: 17 errors, 2 warnings, 154 lines checked

all 17 errors and both warnings are legitimate complaints and if i was 
maintaining that file i'd accept any patch that cleans those problems 
up, in a heartbeat.

And today's mainstream files might become tomorrow's legacy files. To 
come up with a hypothetical example: had you applied checkpatch.pl on 
all changes to this file in the past 15 years (checkpatch.pl only exists 
for less than 5 years so this is hypothetical), you'd have a 
squeaky-clean file and no need for any annoying "monkey patches".

or take a look at the 65 errors that arch/sparc64/kernel/signal32.c 
produces:

  total: 65 errors, 33 warnings, 1391 lines checked

i've just checked all of the 65 errors and all look legitimate at first 
sight and should be fixed.

even looking at "best of breed" arch/sparc64 code, arch/sparc64/mm/*.c 
gives 34 errors:

  scripts/checkpatch.pl --file arch/sparc64/mm/*.c | grep ERROR | wc -l
  34

all of which seem legitimate complaints.

so the score right now: checkpatch versus DaveM 116:0 ;-)

i'm sure there are false positives in it too, but in my experience (from 
the scheduler and from arch/x86) there's less than 1 false positive for 
every 100 legitimate errors that checkpatch.pl it finds. So for the 1500 
errors reported by checkpatch.pl for the whole sparc64 tree:

                            errors   lines of code   errors/KLOC
  arch/sparc64/               1460           49801          29.3

i estimate that there will be less than 15 false positive "ERROR" lines, 
and my random sample of about 100 errors confirms that rate. That's a 
diminishing rate IMO.

as a comparison, core kernel code has this 'style quality':

                            errors   lines of code   errors/KLOC
  kernel/                      727          100364           7.2

in my experience, subsystems (of any significant size - i.e. above a few 
KLOC) where errors/KLOC is "single digit", has very clean code in 
general. Subsystems that have low-double-digit errors/KLOC are OK-ish, 
subsystems with high-double-digit or triple-digit errors/KLOC are messy. 

There can be fluctuations and artifacts, and obviously this is just 
another (arbitrary) static metric that has no forced relationship with 
real code quality - but in my experience it's surprisingly close to 
reality - closer than any other code metric i've seen.

	Ingo
