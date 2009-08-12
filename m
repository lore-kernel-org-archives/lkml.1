Return-Path: <linux-kernel-owner+w=401wt.eu-S1754598AbZHLRTr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754598AbZHLRTr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Aug 2009 13:19:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754580AbZHLRTq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Aug 2009 13:19:46 -0400
Received: from e28smtp02.in.ibm.com ([59.145.155.2]:35288 "EHLO
	e28smtp02.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754579AbZHLRTp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Aug 2009 13:19:45 -0400
Date: Wed, 12 Aug 2009 22:49:40 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, nishimura@mxp.nes.nec.co.jp,
       kosaki.motohiro@jp.fujitsu.com, menage@google.com, prarit@redhat.com,
       andi.kleen@intel.com, xemul@openvz.org, lizf@cn.fujitsu.com,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH] Help Resource Counters Scale better (v4.1)
Message-ID: <20090812171940.GD5087@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
References: <20090811144405.GW7176@balbir.in.ibm.com> <20090811163159.ddc5f5fd.akpm@linux-foundation.org> <20090812045716.GH7176@balbir.in.ibm.com> <49a88ef4a1ba9ec9426febe9e3633b89.squirrel@webmail-b.css.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <49a88ef4a1ba9ec9426febe9e3633b89.squirrel@webmail-b.css.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> [2009-08-13 01:28:57]:

> Balbir Singh wrote:
> > Hi, Andrew,
> >
> > Does this look better, could you please replace the older patch with
> > this one.
> >
> > 1. I did a quick compile test
> > 2. Ran scripts/checkpatch.pl
> >
> 
> In general, seems reasonable to me as quick hack for root cgroup.
> thank you.
> 
> Reviewed-by: KAMEAZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
>

Thanks, yes, we still need to do the percpu counter work, but this
will give us breathing space to do it correctly and define strict and
non-strict accounting.
 
> Finally, we'll have to do some rework for light-weight res_counter.
> But yes, it will take some amount of time.
> My only concern is account leak, but, if some leak, it's current code's
> bug, not this patch.
> 

Yeah.. we'll need to check for that.

> And..hmm...I like following style other than open-coded.
> ==
> int mem_coutner_charge(struct mem_cgroup *mem)
> {
>       if (mem_cgroup_is_root(mem))
>                return 0; // always success
>       return res_counter_charge(....)
> }
> ==
> But maybe nitpick.
> 

Yes, we can refactor for simplication, but we'll need some exceptions.
I'll do that as an add-on patch.



-- 
	Balbir
