Return-Path: <linux-kernel-owner+w=401wt.eu-S1755404AbZJ2XvJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755404AbZJ2XvJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Oct 2009 19:51:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755122AbZJ2XvI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Oct 2009 19:51:08 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:49413 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755167AbZJ2XvI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Oct 2009 19:51:08 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Fri, 30 Oct 2009 08:48:36 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: David Rientjes <rientjes@google.com>
Cc: vedran.furac@gmail.com, Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>, minchan.kim@gmail.com,
       Andrew Morton <akpm@linux-foundation.org>,
       Andrea Arcangeli <aarcange@redhat.com>
Subject: Re: Memory overcommit
Message-Id: <20091030084836.5428e085.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <alpine.DEB.2.00.0910291248480.2276@chino.kir.corp.google.com>
References: <hav57c$rso$1@ger.gmane.org>
	<4ADE3121.6090407@gmail.com>
	<20091026105509.f08eb6a3.kamezawa.hiroyu@jp.fujitsu.com>
	<4AE5CB4E.4090504@gmail.com>
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
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 29 Oct 2009 12:53:42 -0700 (PDT)
David Rientjes <rientjes@google.com> wrote:

> > If you have OOM situation and Xorg is the first, that means it's leaking
> > memory badly and the system is probably already frozen/FUBAR. Killing
> > krunner in that situation wouldn't do any good. From a user perspective,
> > nothing changes, system is still FUBAR and (s)he would probably reboot
> > cursing linux in the process.
> > 
> 
> It depends on what you're running, we need to be able to have the option 
> of protecting very large tasks on production servers.  Imagine if "test" 
> here is actually a critical application that we need to protect, its 
> not solely mlocked anonymous memory, but still kill if it is leaking 
> memory beyond your approximate 2.5GB.  How do you do that when using rss 
> as the baseline?

As I wrote repeatedly,

   - OOM-Killer itselfs is bad thing, bad situation.
   - The kernel can't know the program is bad or not. just guess it.
   - Then, there is no "correct" OOM-Killer other than fork-bomb killer.
   - User has a knob as oom_adj. This is very strong.

Then, there is only "reasonable" or "easy-to-understand" OOM-Kill.
"Current biggest memory eater is killed" sounds reasonable, easy to
understand. And if total_vm works well, overcommit_guess should catch it.
Please improve overcommit_guess if you want to stay on total_vm.


Thanks,
-Kame

