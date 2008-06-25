Return-Path: <linux-kernel-owner+w=401wt.eu-S1756868AbYFYFjD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756868AbYFYFjD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2008 01:39:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754341AbYFYFiy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jun 2008 01:38:54 -0400
Received: from ozlabs.org ([203.10.76.45]:46850 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754007AbYFYFix (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2008 01:38:53 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Mike Travis <travis@sgi.com>
Subject: Re: v2.6.26-rc7: BUG: unable to handle kernel NULL pointer dereference
Date: Wed, 25 Jun 2008 15:38:45 +1000
User-Agent: KMail/1.9.9
Cc: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Vegard Nossum <vegard.nossum@gmail.com>, Adrian Bunk <bunk@kernel.org>,
       Srivatsa Vaddagiri <vatsa@in.ibm.com>, linux-kernel@vger.kernel.org,
       Gautham R Shenoy <ego@in.ibm.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       "Zhang, Yanmin" <yanmin.zhang@intel.com>,
       Heiko Carstens <heiko.carstens@de.ibm.com>
References: <20080622125633.GA8166@damson.getinternet.no> <200806242314.51656.rusty@rustcorp.com.au> <4861085D.8020506@sgi.com>
In-Reply-To: <4861085D.8020506@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806251538.45795.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 25 June 2008 00:44:45 Mike Travis wrote:
> Rusty Russell wrote:
> ...
>
> > Nice catch.  Basically, cpu_possible_map should only be cleared at boot,
> > and probably not even then.
>
> One thing that should be avoided, is clearing anything but the last bit in
> the cpu_possible_map.  This is because num_possible_cpus != nr_cpu_ids when
> there are holes in the map.  (nr_cpu_ids = highest possible cpu # + 1).

It's ok if nr_cpu_ids is an overestimate, isn't it?

But for this corner case, I think clearing cpu_possible_map is wrong.

Cheers,
Rusty.
