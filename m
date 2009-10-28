Return-Path: <linux-kernel-owner+w=401wt.eu-S1757447AbZJ1GWn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757447AbZJ1GWn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Oct 2009 02:22:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757417AbZJ1GWm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Oct 2009 02:22:42 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:58353 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757416AbZJ1GWl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Oct 2009 02:22:41 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Wed, 28 Oct 2009 15:20:15 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: David Rientjes <rientjes@google.com>
Cc: vedran.furac@gmail.com, Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>, minchan.kim@gmail.com,
       Andrew Morton <akpm@linux-foundation.org>,
       Andrea Arcangeli <aarcange@redhat.com>
Subject: Re: Memory overcommit
Message-Id: <20091028152015.3d383cd6.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <alpine.DEB.2.00.0910272311001.15462@chino.kir.corp.google.com>
References: <hav57c$rso$1@ger.gmane.org>
	<20091013120840.a844052d.kamezawa.hiroyu@jp.fujitsu.com>
	<hb2cfu$r08$2@ger.gmane.org>
	<20091014135119.e1baa07f.kamezawa.hiroyu@jp.fujitsu.com>
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
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 27 Oct 2009 23:17:41 -0700 (PDT)
David Rientjes <rientjes@google.com> wrote:

> On Wed, 28 Oct 2009, KAMEZAWA Hiroyuki wrote:
> 
> > All kernel engineers know "than expected or not" can be never known to the kernel.
> > So, oom_adj workaround is used now. (by some special users.)
> > OOM Killer itself is also a workaround, too.
> > "No kill" is the best thing but we know there are tend to be memory-leaker on bad
> > systems and all systems in this world are not perfect.
> > 
> 
> Right, and historically that has been addressed by considering total_vm 
> and adjusting it with oom_adj so that we can identify memory leaking tasks 
> through user-defined criteria.
> 
> > Yes, some more trustable values other than vmsize/rss/time are appriciated.
> > I wonder recent memory consumption speed can be an another key value.
> > 
> 
> Sounds very logical.
> 
> > Anyway, current bahavior of "killing X" is a bad thing.
> > We need some fixes.
> > 
> 
> You can easily protect X with OOM_DISABLE, as you know.  I don't think we 
> need any X-specific heuristics added to the kernel, it looks like the 
> special cases have already polluted badness() enough.
> 
It's _not_ special to X.

Almost all applications which uses many dynamica libraries can be affected by this,
total_vm. And, as I explained to Vedran, multi-threaded program like Java can easily
increase total_vm without using many anon_rss.
And it's the reason I hate overcommit_memory. size of VM doesn't tell anything.


Thanks,
-Kame

