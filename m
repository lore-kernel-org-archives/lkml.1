Return-Path: <linux-kernel-owner+w=401wt.eu-S1751781AbZIBLZX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751781AbZIBLZX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Sep 2009 07:25:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751686AbZIBLZW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Sep 2009 07:25:22 -0400
Received: from viefep14-int.chello.at ([62.179.121.34]:2744 "EHLO
	viefep14-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751655AbZIBLZW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Sep 2009 07:25:22 -0400
X-SourceIP: 213.93.53.227
Subject: Re: [RFC][PATCH 3/8] sched: update the cpu_power sum during
 load-balance
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: ego@in.ibm.com
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Andreas Herrmann <andreas.herrmann3@amd.com>,
       Balbir Singh <balbir@in.ibm.com>
In-Reply-To: <20090902111759.GB3817@in.ibm.com>
References: <20090901083431.748830771@chello.nl>
	 <20090901083825.985050292@chello.nl>  <20090902111759.GB3817@in.ibm.com>
Content-Type: text/plain
Date: Wed, 02 Sep 2009 13:25:06 +0200
Message-Id: <1251890706.7547.150.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-09-02 at 16:47 +0530, Gautham R Shenoy wrote:
> > +     if (local_group) {
> >               balance_cpu = group_first_cpu(group);
> > +             if (balance_cpu == this_cpu)
> > +                     update_sched_power(sd);
> > +     }
> 
> I guess the intention of this check is to ensure that the cpu_power for
> the group of sd is updated only by a specific member of the group and
> that would ideally be the first member of the group.
> 
> Thus, this check has more to do with this_cpu being the
> group_first_cpu() than this_cpu being the balance_cpu. Correct ?

Right, so the load-balancer walks the sd tree in the fashion that only
the first cpu of the domain goes up a level. So I made that cpu also
aggregate the new cpu-power.

