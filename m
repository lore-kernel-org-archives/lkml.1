Return-Path: <linux-kernel-owner+w=401wt.eu-S1750934AbZHJGX7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750934AbZHJGX7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Aug 2009 02:23:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750850AbZHJGX6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Aug 2009 02:23:58 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:58155 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750823AbZHJGX5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Aug 2009 02:23:57 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Mon, 10 Aug 2009 15:22:05 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: balbir@linux.vnet.ibm.com, Andrew Morton <akpm@linux-foundation.org>,
       andi.kleen@intel.com, Prarit Bhargava <prarit@redhat.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       "lizf@cn.fujitsu.com" <lizf@cn.fujitsu.com>,
       "menage@google.com" <menage@google.com>,
       Pavel Emelianov <xemul@openvz.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: Help Resource Counters Scale Better (v3)
Message-Id: <20090810152205.d37d8e2f.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20090810144559.ac5a3499.kamezawa.hiroyu@jp.fujitsu.com>
References: <20090807221238.GJ9686@balbir.in.ibm.com>
	<39eafe409b85053081e9c6826005bb06.squirrel@webmail-b.css.fujitsu.com>
	<20090808060531.GL9686@balbir.in.ibm.com>
	<99f2a13990d68c34c76c33581949aefd.squirrel@webmail-b.css.fujitsu.com>
	<20090809121530.GA5833@balbir.in.ibm.com>
	<20090810093229.10db7185.kamezawa.hiroyu@jp.fujitsu.com>
	<20090810053025.GC5257@balbir.in.ibm.com>
	<20090810144559.ac5a3499.kamezawa.hiroyu@jp.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 10 Aug 2009 14:45:59 +0900
KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:

> > Do you agree?
> 
> Ok. Config is enough at this stage.
> 
> The last advice for merge is, it's better to show the numbers or
> ask someone who have many cpus to measure benefits. Then, Andrew can
> know how this is benefical.
> (My box has 8 cpus. But maybe your IBM collaegue has some bigger one)
> 
> In my experience (in my own old trial),
>  - lock contention itself is low. not high.
>  - but cacheline-miss, pingpong is very very frequent.
> 
> Then, this patch has some benefit logically but, in general,
> File-I/O, swapin-swapout, page-allocation/initalize etc..dominates
> the performance of usual apps. You'll have to be careful to select apps
> to measure the benfits of this patch by application performance.
> (And this is why I don't feel so much emergency as you do)
> 

Why I say "I want to see the numbers" again and again is that
this is performance improvement with _bad side effect_.
If this is an emergent trouble, and need fast-track, which requires us
"fix small problems later", plz say so. 

I have no objection to this approach itself because I can't think of
something better, now. percpu-counter's error tolerance is a generic
problem and we'll have to visit this anyway.

Thanks,
-Kame

