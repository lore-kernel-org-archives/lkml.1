Return-Path: <linux-kernel-owner+w=401wt.eu-S932312AbYGRA1Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932312AbYGRA1Q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 20:27:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753101AbYGRA07
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 20:26:59 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:41594 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751659AbYGRA07 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 20:26:59 -0400
Message-ID: <487FE334.6070807@jp.fujitsu.com>
Date: Fri, 18 Jul 2008 09:26:28 +0900
From: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
User-Agent: Thunderbird 2.0.0.14 (Windows/20080421)
MIME-Version: 1.0
To: Paul Jackson <pj@sgi.com>
CC: Li Zefan <lizf@cn.fujitsu.com>, linux-kernel@vger.kernel.org,
       menage@google.com, peterz@infradead.org, akpm@linux-foundation.org,
       laijs@cn.fujitsu.com
Subject: Re: [RFC] [PATCH] cpuset: fix wrong calculation of relax domain level
References: <487EFDD0.2060101@cn.fujitsu.com> <20080717152833.1e14a1c4.pj@sgi.com>
In-Reply-To: <20080717152833.1e14a1c4.pj@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Jackson wrote:
> Question:
> 
>     In the case that the top_cpuset's sched_load_balance is -not- set,
>     is there code already present that sets the sched_relax_domain_level
>     in overlapping cpusets to the largest value in any of the overlapping
>     cpusets?
> 
>     If so, where is that code?
> 

My humble answer:

static void rebuild_sched_domains(void)
{
 :
	while (__kfifo_get(q, (void *)&cp, sizeof(cp))) {
	//  pick up cpusets with sched_load_balance = 1
	}
 :
restart:
	/* Find the best partition (set of sched domains) */
	for (i = 0; i < csn; i++) {
	// check overlap and set proper partition number
	}
 :
	for (nslot = 0, i = 0; i < csn; i++) {
 :
				if (apn == b->pn) {
					// make map and attr from all cpusets
					// having same partition number
					cpus_or(*dp, *dp, b->cpus_allowed);
					b->pn = -1;
					if (dattr)
						update_domain_attr(dattr
								   + nslot, b);
                                }
 :
        }
 :
rebuild:
 :
done:
 :
}

So the codes you searching is near by 'update_domain_attr' above, I guess.

Thanks,
H.Seto
