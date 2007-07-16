Return-Path: <linux-kernel-owner+w=401wt.eu-S1758371AbXGPI4I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758371AbXGPI4I (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2007 04:56:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754784AbXGPIzx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jul 2007 04:55:53 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:44682 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753000AbXGPIzw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2007 04:55:52 -0400
Date: Mon, 16 Jul 2007 10:55:45 +0200
From: Ingo Molnar <mingo@elte.hu>
To: "Ni@m" <niam.niam@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: performance -cfs19 vs. -ck1 for 2.6.22
Message-ID: <20070716085545.GA5964@elte.hu>
References: <a9e22dff0707160112pc3b7bfcmc73adbd4edec670e@mail.gmail.com> <20070716082917.GA1325@elte.hu> <a9e22dff0707160138v109e2080u96726906ccb8b716@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a9e22dff0707160138v109e2080u96726906ccb8b716@mail.gmail.com>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Ni@m <niam.niam@gmail.com> wrote:

> Hi, Ingo!
> 
> >>Could you run the
> >>following script:
> >> http://people.redhat.com/mingo/cfs-scheduler/tools/cfs-debug-info.sh
> I'll do that! But a little bit later - I have tested that on my home 
> computer.
> 
> >>hm, is there no other workload on the system?
> Workload: firefox, transmission(torrent client), gnome terminal, music 
> player.
> 
> Now I think it could be not a scheduler issue but network subsystem 
> ... but I've got such situation on previous kernels and w/o torrent 
> client running.
>
> The problem is not in switching tabs in firefox but in 
> _opening_new_url_. I'm not good in Con's patches but are they touching 
> network subsystem?

Con's patches are not really touching the network subsystem, but we want 
to analyze this and figure out where the difference in behavior comes 
from, be that scheduling, networking or something else.

to help us figure out the nature of the delay, could you do another 
thing as well:

  strace -ttt -TTT -f -o firefox.trace.txt -p `pidof firefox-bin`

this will produce firefox.trace.txt - compress that via bzip -9. (and 
send that file privately - it might include private information embedded 
in URLs, etc.) Please do such a trace both under CFS and under -ck, 
under similar circumstances.

To isolate it down to the CPU scheduler changes you can create a pure 
2.6.22+SD kernel by applying this patch to a vanilla v2.6.22 tree:

  http://kernel.org/pub/linux/kernel/people/ck/patches/2.6/2.6.22/2.6.22-ck1/patches/sched-staircase-deadline-cpu-scheduler.patch

	Ingo
