Return-Path: <linux-kernel-owner+w=401wt.eu-S1752083AbZHJFWx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752083AbZHJFWx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Aug 2009 01:22:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751724AbZHJFWw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Aug 2009 01:22:52 -0400
Received: from e28smtp04.in.ibm.com ([59.145.155.4]:57997 "EHLO
	e28smtp04.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751523AbZHJFWv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Aug 2009 01:22:51 -0400
Date: Mon, 10 Aug 2009 10:52:43 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, andi.kleen@intel.com,
       Prarit Bhargava <prarit@redhat.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       "lizf@cn.fujitsu.com" <lizf@cn.fujitsu.com>,
       "menage@google.com" <menage@google.com>,
       Pavel Emelianov <xemul@openvz.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: Help Resource Counters Scale Better (v3)
Message-ID: <20090810052243.GB5257@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
References: <20090807221238.GJ9686@balbir.in.ibm.com> <39eafe409b85053081e9c6826005bb06.squirrel@webmail-b.css.fujitsu.com> <20090808060531.GL9686@balbir.in.ibm.com> <99f2a13990d68c34c76c33581949aefd.squirrel@webmail-b.css.fujitsu.com> <20090809121530.GA5833@balbir.in.ibm.com> <20090810093229.10db7185.kamezawa.hiroyu@jp.fujitsu.com> <20090810094344.77a8ef55.kamezawa.hiroyu@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20090810094344.77a8ef55.kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> [2009-08-10 09:43:44]:

> On Mon, 10 Aug 2009 09:32:29 +0900
> KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:
> 
> > 1. you use res_counter_read_positive() in force_empty. It seems force_empty can
> >    go into infinite loop. plz check. (especially when some pages are freed or swapped-in
> >    in other cpu while force_empry runs.)
> > 
> > 2. In near future, we'll see 256 or 1024 cpus on a system, anyway.
> >    Assume 1024cpu system, 64k*1024=64M is a tolerance.
> >    Can't we calculate max-tolerane as following ?
> >   
> >    tolerance = min(64k * num_online_cpus(), limit_in_bytes/100);
> >    tolerance /= num_online_cpus();
> >    per_cpu_tolerance = min(16k, tolelance);
> > 
> >    I think automatic runtine adjusting of tolerance will be finally necessary,
> >    but above will not be very bad because we can guarantee 1% tolerance.
> > 
> 
> Sorry, one more.
> 
> 3. As I requested when you pushed softlimit changes to mmotom, plz consider
>    to implement a way to check-and-notify gadget to res_counter.
>    See: http://marc.info/?l=linux-mm&m=124753058921677&w=2
>

Yes, I will do that, but only after the scaling, since this is more
important at the moment. 

-- 
	Balbir
