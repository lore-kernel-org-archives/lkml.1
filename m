Return-Path: <linux-kernel-owner+w=401wt.eu-S1754074AbZJ2Tmu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754074AbZJ2Tmu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Oct 2009 15:42:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753849AbZJ2Tmu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Oct 2009 15:42:50 -0400
Received: from smtp-out.google.com ([216.239.33.17]:21155 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753591AbZJ2Tmt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Oct 2009 15:42:49 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=uoFg4fnWIQdc7FR79gOO0MjP7pkPO1gALMEdiX1TzyMKLCMX+inxLesRJGn2Ys6cK
	K4+fmCIJ8nAU8D89V04ww==
Date: Thu, 29 Oct 2009 12:42:40 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: vedran.furac@gmail.com
cc: Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>, minchan.kim@gmail.com,
       Andrew Morton <akpm@linux-foundation.org>,
       Andrea Arcangeli <aarcange@redhat.com>
Subject: Re: Memory overcommit
In-Reply-To: <4AE97618.6060607@gmail.com>
Message-ID: <alpine.DEB.2.00.0910291225460.27732@chino.kir.corp.google.com>
References: <hav57c$rso$1@ger.gmane.org> <20091013120840.a844052d.kamezawa.hiroyu@jp.fujitsu.com> <hb2cfu$r08$2@ger.gmane.org> <20091014135119.e1baa07f.kamezawa.hiroyu@jp.fujitsu.com> <4ADE3121.6090407@gmail.com> <20091026105509.f08eb6a3.kamezawa.hiroyu@jp.fujitsu.com>
 <4AE5CB4E.4090504@gmail.com> <20091027122213.f3d582b2.kamezawa.hiroyu@jp.fujitsu.com> <Pine.LNX.4.64.0910271843510.11372@sister.anvils> <alpine.DEB.2.00.0910271351140.9183@chino.kir.corp.google.com> <4AE78B8F.9050201@gmail.com>
 <alpine.DEB.2.00.0910271723180.17615@chino.kir.corp.google.com> <4AE792B8.5020806@gmail.com> <alpine.DEB.2.00.0910272047430.8988@chino.kir.corp.google.com> <4AE846E8.1070303@gmail.com> <alpine.DEB.2.00.0910281307370.23279@chino.kir.corp.google.com>
 <4AE9068B.7030504@gmail.com> <alpine.DEB.2.00.0910290132320.11476@chino.kir.corp.google.com> <4AE97618.6060607@gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 29 Oct 2009, Vedran Furac wrote:

> [ 1493.064458] Out of memory: kill process 6304 (kdeinit4) score 1190231
> or a child
> [ 1493.064467] Killed process 6409 (konqueror)
> [ 1493.261149] knotify4 invoked oom-killer: gfp_mask=0x201da, order=0,
> oomkilladj=0
> [ 1493.261166]  [<ffffffff810d6dd7>] ? oom_kill_process+0x9a/0x264
> [ 1493.276528] Out of memory: kill process 6304 (kdeinit4) score 1161265
> or a child
> [ 1493.276538] Killed process 6411 (krusader)
> [ 1499.221160] akregator invoked oom-killer: gfp_mask=0x201da, order=0,
> oomkilladj=0
> [ 1499.221178]  [<ffffffff810d6dd7>] ? oom_kill_process+0x9a/0x264
> [ 1499.236431] Out of memory: kill process 6304 (kdeinit4) score 1067593
> or a child
> [ 1499.236441] Killed process 6412 (irexec)
> [ 1499.370192] firefox-bin invoked oom-killer: gfp_mask=0x201da,
> order=0, oomkilladj=0
> [ 1499.370209]  [<ffffffff810d6dd7>] ? oom_kill_process+0x9a/0x264
> [ 1499.385417] Out of memory: kill process 6304 (kdeinit4) score 1066861
> or a child
> [ 1499.385427] Killed process 6420 (xchm)
> [ 1499.458304] kio_file invoked oom-killer: gfp_mask=0x201da, order=0,
> oomkilladj=0
> [ 1499.458333]  [<ffffffff810d6dd7>] ? oom_kill_process+0x9a/0x264
> [ 1499.458367]  [<ffffffff81120900>] ? d_kill+0x5c/0x7c
> [ 1499.473573] Out of memory: kill process 6304 (kdeinit4) score 1043690
> or a child
> [ 1499.473582] Killed process 6425 (kio_file)
> [ 1500.250746] korgac invoked oom-killer: gfp_mask=0x201da, order=0,
> oomkilladj=0
> [ 1500.250765]  [<ffffffff810d6dd7>] ? oom_kill_process+0x9a/0x264
> [ 1500.266186] Out of memory: kill process 6304 (kdeinit4) score 1020350
> or a child
> [ 1500.266196] Killed process 6464 (icedove)
> [ 1500.349355] syslog-ng invoked oom-killer: gfp_mask=0x201da, order=0,
> oomkilladj=0
> [ 1500.349371]  [<ffffffff810d6dd7>] ? oom_kill_process+0x9a/0x264
> [ 1500.364689] Out of memory: kill process 6304 (kdeinit4) score 1019864
> or a child
> [ 1500.364699] Killed process 6477 (kio_http)
> [ 1500.452151] kded4 invoked oom-killer: gfp_mask=0x201da, order=0,
> oomkilladj=0
> [ 1500.452167]  [<ffffffff810d6dd7>] ? oom_kill_process+0x9a/0x264
> [ 1500.452196]  [<ffffffff81120900>] ? d_kill+0x5c/0x7c
> [ 1500.467307] Out of memory: kill process 6304 (kdeinit4) score 993142
> or a child
> [ 1500.467316] Killed process 6478 (kio_http)
> [ 1500.780222] akregator invoked oom-killer: gfp_mask=0x201da, order=0,
> oomkilladj=0
> [ 1500.780239]  [<ffffffff810d6dd7>] ? oom_kill_process+0x9a/0x264
> [ 1500.796280] Out of memory: kill process 6304 (kdeinit4) score 966331
> or a child
> [ 1500.796290] Killed process 6484 (kio_http)
> [ 1501.065374] syslog-ng invoked oom-killer: gfp_mask=0x201da, order=0,
> oomkilladj=0
> [ 1501.065390]  [<ffffffff810d6dd7>] ? oom_kill_process+0x9a/0x264
> [ 1501.080579] Out of memory: kill process 6304 (kdeinit4) score 939434
> or a child
> [ 1501.080587] Killed process 6486 (kio_http)
> [ 1501.381188] knotify4 invoked oom-killer: gfp_mask=0x201da, order=0,
> oomkilladj=0
> [ 1501.381204]  [<ffffffff810d6dd7>] ? oom_kill_process+0x9a/0x264
> [ 1501.396338] Out of memory: kill process 6304 (kdeinit4) score 912691
> or a child
> [ 1501.396346] Killed process 6487 (firefox-bin)
> [ 1502.661294] icedove-bin invoked oom-killer: gfp_mask=0x201da,
> order=0, oomkilladj=0
> [ 1502.661311]  [<ffffffff810d6dd7>] ? oom_kill_process+0x9a/0x264
> [ 1502.676563] Out of memory: kill process 7580 (test) score 708945 or a
> child
> [ 1502.676575] Killed process 7580 (test)
> 

Ok, so this is the forkbomb problem by adding half of each child's 
total_vm into the badness score of the parent.  We should address this 
completely seperately by addressing that specific part of the heuristic, 
not changing what we consider to be a baseline.

The rationale is quite simple: we'll still experience the same problem 
with rss as we did with total_vm in the forkbomb scenario above on certain 
workloads (maybe not yours, but others).  The oom killer always kills a 
child first if it has a different mm than the selected parent, so the 
amount of memory freeing as a result of that is entirely dependent on the 
order of the child list.  It may be very little, but killed because its 
siblings had large total_vm values.

So instead of focusing on rss, we simply need to find a better heuristic 
for the forkbomb issue which I've already proposed a very trivial solution 
for.  Then, afterwards, we can debate about how the scoring heuristic can 
be changed to select better tasks (and perhaps remove a lot of the clutter 
that's there currently!).

> > Can you explain why Xorg is preferred as a baseline to kill rather than 
> > krunner in your example?
> 
> Krunner is a small app for running other apps and do similar things. It
> shouldn't use a lot of memory. OTOH, Xorg has to hold all the pixmaps
> and so on. That was expected result. Fist Xorg, then firefox and
> thunderbird.
> 

You're making all these claims and assertions based _solely_ on the theory 
that killing the application with the most resident RAM is always the 
optimal solution.  That's just not true, especially if we're just 
allocating small numbers of order-0 memory.

Much better is to allow the user to decide at what point, regardless of 
swap usage, their application is using much more memory than expected or 
required.  They can do that right now pretty well with /proc/pid/oom_adj 
without this outlandish claim that they should be expected to know the rss 
of their applications at the time of oom to effectively tune oom_adj.

What would you suggest?  A script that sits in a loop checking each task's 
current rss from /proc/pid/stat or their current oom priority though 
/proc/pid/oom_score and adjusting oom_adj preemptively just in case the 
oom killer is invoked in the next second?

And that "small app" has 30MB of rss which could be freed, if killed, and 
utilized for subsequent page allocations.
