Return-Path: <linux-kernel-owner+w=401wt.eu-S1753975AbZLATBi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753975AbZLATBi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Dec 2009 14:01:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753280AbZLATBh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Dec 2009 14:01:37 -0500
Received: from tomts36.bellnexxia.net ([209.226.175.93]:43771 "EHLO
	tomts36-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752869AbZLATBg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Dec 2009 14:01:36 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ArcEAMv1FEuuWOh5/2dsb2JhbACBTtcMhDEEgxo
Date: Tue, 1 Dec 2009 14:01:40 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Nick Piggin <npiggin@suse.de>
Cc: Arnd Bergmann <arnd@arndb.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [rfc] "fair" rw spinlocks
Message-ID: <20091201190140.GA5421@Krystal>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20091123145409.GA29627@wotan.suse.de>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.27.31-grsec (i686)
X-Uptime: 13:46:53 up 105 days,  5:36,  4 users,  load average: 1.33, 1.06,
	0.92
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nick Piggin <npiggin@suse.de> wrote:
> Anyway, I don't have a patch yet. I'm sure it can be done
> without extra atomics in fastpaths. Comments?

Hi Nick,

I actually have an implementation doing what you are looking for. I did
it last year, but after that had to focus on finishing my Ph.D., so it
went a bit out of focus. You can see this old thread:

http://lwn.net/Articles/297493/
"Priority Sifting Reader-Writer Lock v13"

It's not fair per-se: it's biased to favor writers over readers.
However, writers vs writers are fair.

Disclaimer: there may be some amount of dust accumulated on these
patches over the past year. Also, I did not do any formal proof of
correctness of these algorithms (yet) ;)

The code is in the LTTng tree for the 2.6.32-rc8 kernel, they can be
listed by searching for "psrwlock" commits, e.g.:

http://git.kernel.org/?p=linux%2Fkernel%2Fgit%2Fcompudj%2Flinux-2.6-lttng.git&a=search&h=HEAD&st=commit&s=psrwlock

The main commit is:
http://git.kernel.org/?p=linux/kernel/git/compudj/linux-2.6-lttng.git;a=commit;h=4ae9a3960df1eefb726709ed6b697d739db3380b

Documentation (design explanation, performance tests):
http://git.kernel.org/?p=linux/kernel/git/compudj/linux-2.6-lttng.git;a=blob;f=Documentation/psrwlock.txt;h=5309aeb3d04d645d890b5dd7702982631a81e4c8;hb=18f769c8588a9368254b6c4bffc870f08cee6f97

I currently have to focus on my thesis defense (it's actually this
Friday), but I'll try to catch up with feedback if there happens to be
some. Please feel free to look at the code and clean it up if you think
it's worthwhile. It would be a shame to duplicate that work.

Thanks,

Mathieu


-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
