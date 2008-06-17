Return-Path: <linux-kernel-owner+w=401wt.eu-S1759548AbYFQPex@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759548AbYFQPex (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2008 11:34:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758776AbYFQPem
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jun 2008 11:34:42 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:47509 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759089AbYFQPej (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2008 11:34:39 -0400
Date: Tue, 17 Jun 2008 17:33:56 +0200
From: Ingo Molnar <mingo@elte.hu>
To: David Miller <davem@davemloft.net>
Cc: arjan@linux.intel.com, linux-kernel@vger.kernel.org,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       tglx@linutronix.de, linville@tuxdriver.com, davej@redhat.com,
       gregkh@suse.de
Subject: Re: Oops report for the week preceding June 16th, 2008
Message-ID: <20080617153356.GA3510@elte.hu>
References: <4856AFDF.5080901@linux.intel.com> <20080617092023.GA20621@elte.hu> <20080617.022652.76635616.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080617.022652.76635616.davem@davemloft.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
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

> On the wireless front, I severely doubt... in fact I know because I'm 
> looking at every wireless merge going into my tree, that John Linville 
> is not holding back new drivers submissions from the current 2.6.26 
> tree. Neither is Jeff Garzik for non-wireless net drivers.

i have no gripes about the current situation of wireless in linux-next, 
other than it all came 1-2 years too late:

  $ for ((v=12; v<27; v++)); do v2=v2.6.$[$v+1]; \
    [ $v = 25 ] && v2=linus/master; \
    [ $v = 26 ] && v2=linux-next/master; \
    echo -n v2.6.$[$v+1]": "; \
    git-diff --shortstat -M v2.6.$v..$v2 drivers/net/wireless/; done

 v2.6.13:   16 files changed,   1707 insertions(+),  1353 deletions(-)
 v2.6.14:   46 files changed,  40734 insertions(+),   756 deletions(-)
 v2.6.15:   53 files changed,   8016 insertions(+),  4183 deletions(-)
 v2.6.16:   37 files changed,   1818 insertions(+),  2513 deletions(-)
 v2.6.17:   64 files changed,  17829 insertions(+),  2214 deletions(-)
 v2.6.18:   78 files changed,  11159 insertions(+),  1427 deletions(-)
 v2.6.19:   63 files changed,   3441 insertions(+),  1500 deletions(-)
 v2.6.20:   58 files changed,   1290 insertions(+),  1028 deletions(-)
 v2.6.21:   42 files changed,    729 insertions(+),   678 deletions(-)
 v2.6.22:   85 files changed,  18989 insertions(+),   552 deletions(-)
 v2.6.23:   42 files changed,   2824 insertions(+),   356 deletions(-)
 v2.6.24:  208 files changed, 100960 insertions(+),  4303 deletions(-)
 v2.6.25:  227 files changed,  54467 insertions(+), 23126 deletions(-)
    -git:  214 files changed,  21940 insertions(+), 34143 deletions(-)
   -next:  126 files changed,  13585 insertions(+), 10146 deletions(-)

up to v2.6.24 (released only 4 months ago!) we amassed a huge backlog of 
~100+ KLOC wireless changes - there were OSS wireless drivers that 
havent been merged for up to 1.5 years.

v2.6.24 was no doubt a huge step in the right direction but it came too 
late and we are still suffering from the fallout today as we have not 
reached test cycle equilibrium yet: by the time mainline gets the 
patches a new large batch comes up, invalidating much of mainline's role 
and forcing distros to gamble with (much untested and thus detached from 
reality) experimental branches.

That's my main point: when we mess up and dont merge OSS driver code 
that was out there in time - and we messed up big time with wireless - 
we should admit the screwup and swallow the bitter pill.

I.e. should merge the _full_ pipeline, open up to every developer who is 
willing to help with the mess, face instability for a short while until 
the dust settles and go for absolutely short turnaround for fixes and 
even enhancements - because there's little QA value in the existing 
code. Instead of pretending that we are "stable" (in this area of the 
kernel) - with a code base that distros end up skipping over.

Have a look at Fedora's kernel-2.6.25.6-24.fc8.src.rpm (which is the 
Fedora kernel Arjan referred to and which we are talking about here) to 
see how this all ends up in distros in practice:

 earth4:/usr/src/redhat/SOURCES> ls -ldt *wireless*

 -rw-r--r-- 1 root root 4102957 2008-06-03 23:01 linux-2.6-wireless.patch

   (excluding renames: 214 files changed, 21940 insertions, 34143 deletions)

 -rw-r--r-- 1 root root 1663540 2008-05-29 20:46 linux-2.6-wireless-pending.patch

   (excluding renames: 126 files changed, 13585 insertions, 10146 deletions)

 -rw-r--r-- 1 root root 38430 2008-05-29 20:46 linux-2.6-wireless-fixups.patch

linux-2.6-wireless.patch [4 MB patch, 55KLOC flux] is what v2.6.26 will 
be in a month or so, and it is already an obsolete, historic version, 
compared to what Fedora ships today...

linux-2.6-wireless-pending.patch [1.6 MB patch, 23 KLOC flux] is what is 
in linux-next in essence and what will go into v2.6.27. Do you think 
Fedora jumped to the linux-next version of wireless because the current 
(not even released) mainline version was working so well?

And lets finally admit that this pain is all happening to us because we:

       _didnt merge drivers soon enough_

Just about anyone who tried to use 3D and wireless on a Linux PC in the 
past 3 years will attest to that, without the need for much background 
research ;-)

IMO we are not learning and are repeating history once again, as the 
Nouveau situation is building up towards a similar "we didnt merge it in 
time" pain point. From kernel-2.6.25.6-24.fc8.src.rpm:

  -rw-r--r-- 1 root root 513639 2008-05-22 04:31 nouveau-drm.patch

  39 files changed, 13960 insertions(+), 5 deletions(-)

Nouveau has been started in 2006, about two years ago. It's a lot less 
painful (not the least it is a lot faster as well) if such things are 
developed gradually in mainline.

	Ingo
