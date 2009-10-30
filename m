Return-Path: <linux-kernel-owner+w=401wt.eu-S1756701AbZJ3JjJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756701AbZJ3JjJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Oct 2009 05:39:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756672AbZJ3JjJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Oct 2009 05:39:09 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:56034 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756653AbZJ3JjH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Oct 2009 05:39:07 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Fri, 30 Oct 2009 18:36:38 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: David Rientjes <rientjes@google.com>
Cc: vedran.furac@gmail.com, Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>, minchan.kim@gmail.com,
       Andrew Morton <akpm@linux-foundation.org>,
       Andrea Arcangeli <aarcange@redhat.com>
Subject: Re: Memory overcommit
Message-Id: <20091030183638.1125c987.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <alpine.DEB.2.00.0910300200170.18076@chino.kir.corp.google.com>
References: <hav57c$rso$1@ger.gmane.org>
	<20091027122213.f3d582b2.kamezawa.hiroyu@jp.fujitsu.com>
	<Pine.LNX.4.64.0910271843510.11372@sister.anvils>
	<alpine.DEB.2.00.0910271351140.9183@chino.kir.corp.google.com>
	<4AE78B8F.9050201@gmail.com>
	<alpine.DEB.2.00.0910271723180.17615@chino.kir.corp.google.com>
	<4AE792B8.5020806@gmail.com>
	<alpine.DEB.2.00.0910272047430.8988@chino.kir.corp.google.com>
	<20091028135519.805c4789.kamezawa.hiroyu@jp.fujitsu.com>
	<alpine.DEB.2.00.0910272205200.7507@chino.kir.corp.google.com>
	<20091028150536.674abe68.kamezawa.hiroyu@jp.fujitsu.com>
	<alpine.DEB.2.00.0910272311001.15462@chino.kir.corp.google.com>
	<20091028152015.3d383cd6.kamezawa.hiroyu@jp.fujitsu.com>
	<alpine.DEB.2.00.0910290136000.11476@chino.kir.corp.google.com>
	<4AE97861.1070902@gmail.com>
	<alpine.DEB.2.00.0910291248480.2276@chino.kir.corp.google.com>
	<20091030084836.5428e085.kamezawa.hiroyu@jp.fujitsu.com>
	<alpine.DEB.2.00.0910300200170.18076@chino.kir.corp.google.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 30 Oct 2009 02:10:37 -0700 (PDT)
David Rientjes <rientjes@google.com> wrote:

> >    - The kernel can't know the program is bad or not. just guess it.
> 
> Totally irrelevant, given your fourth point about /proc/pid/oom_adj.  We 
> can tell the kernel what we'd like the oom killer behavior should be if 
> the situation arises.
> 

My point is that the server cannot distinguish memory leak from intentional
memory usage. No other than that.



> >    - Then, there is no "correct" OOM-Killer other than fork-bomb killer.
> 
> Well of course there is, you're seeing this is a WAY too simplistic 
> manner.  If we are oom, we want to be able to influence how the oom killer 
> behaves and respond to that situation.  You are proposing that we change 
> the baseline for how the oom killer selects tasks which we use CONSTANTLY 
> as part of our normal production environment.  I'd appreciate it if you'd 
> take it a little more seriously.
> 
Yes, I'm serious.

In this summer, at lunch with a daily linux user, I was said
"you, enterprise guys, don't consider desktop or laptop problem at all."
yes, I use only servers. My customer uses server, too. My first priority
is always on server users.
But, for this time, I wrote reply to Vedran and try to fix desktop problem.
Even if current logic works well for servers, "KDE/GNOME is killed" problem
seems to be serious. And this may be a problem for EMBEDED people, I guess.


> >    - User has a knob as oom_adj. This is very strong.
> > 
> 
> Agreed.
> 
This and memcg are very useful. But everone says "bad workaround" ;(
Maybe only servers can use these functions.

> > Then, there is only "reasonable" or "easy-to-understand" OOM-Kill.
> > "Current biggest memory eater is killed" sounds reasonable, easy to
> > understand. And if total_vm works well, overcommit_guess should catch it.
> > Please improve overcommit_guess if you want to stay on total_vm.
> > 
> 
> I don't necessarily want to stay on total_vm, but I also don't want to 
> move to rss as a baseline, as you would probably agree.
> 
I'll rewrite all. I'll not rely only on rss. There are several situations
and we need some more information than we have know. I'll have to implement
ways to gather information before chaging badness.


> We disagree about a very fundamental principle: you are coming from a 
> perspective of always wanting to kill the biggest resident memory eater 
> even for a single order-0 allocation that fails and I'm coming from a 
> perspective of wanting to ensure that our machines know how the oom killer 
> will react when it is used. 
yes.

> Moving to rss reduces the ability of the user to specify an expected oom
> priority other than polarizing it by either 
> disabling it completely with an oom_adj value of -17 or choosing the 
> definite next victim with +15.  That's my objection to it: the user cannot 
> possibly be expected to predict what proportion of each application's 
> memory will be resident at the time of oom.
> 
I can say the same thing to total_vm size. total_vm size doesn't include any
good information for oom situation. And tweaking based on that not-useful
parameter will make things worse.

For oom_adj tweak, we may need other technique other than "shift".
If I've wrote oom_adj, I'll write it as

   /proc/<pid>/guarantee_nooom_size

  #echo 3G > /proc/<pid>/guarantee_nooom_size

  Then, 3G bytes of this process's memory usage will not be accounted to badness.

I'm not sure I can add new interface or replace oom_adj, now.
But to do this, current chilren's score problem etc...should be fixed.

> I understand you want to totally rewrite the oom killer for whatever 
> reason, but I think you need to spend a lot more time understanding the 
> needs that the Linux community has for its behavior instead of insisting 
> on your point of view.
> 
yes, use more time. I don't think all of changes can be in quick work.

To be honest, this is a part of work to implement "custom oom handler" cgroup.
Before going further, I'd like to fix current problem.

Thanks,
-Kame


