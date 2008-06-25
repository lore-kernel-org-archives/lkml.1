Return-Path: <linux-kernel-owner+w=401wt.eu-S1757019AbYFYPHP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757019AbYFYPHP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2008 11:07:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751293AbYFYPHE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jun 2008 11:07:04 -0400
Received: from relay2.sgi.com ([192.48.171.30]:54568 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751288AbYFYPHC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2008 11:07:02 -0400
Message-ID: <48625F0E.7000603@sgi.com>
Date: Wed, 25 Jun 2008 08:06:54 -0700
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Vegard Nossum <vegard.nossum@gmail.com>, Adrian Bunk <bunk@kernel.org>,
       Srivatsa Vaddagiri <vatsa@in.ibm.com>, linux-kernel@vger.kernel.org,
       Gautham R Shenoy <ego@in.ibm.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       "Zhang, Yanmin" <yanmin.zhang@intel.com>,
       Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: Re: v2.6.26-rc7: BUG: unable to handle kernel NULL pointer dereference
References: <20080622125633.GA8166@damson.getinternet.no> <200806242314.51656.rusty@rustcorp.com.au> <4861085D.8020506@sgi.com> <200806251538.45795.rusty@rustcorp.com.au>
In-Reply-To: <200806251538.45795.rusty@rustcorp.com.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rusty Russell wrote:
> On Wednesday 25 June 2008 00:44:45 Mike Travis wrote:
>> Rusty Russell wrote:
>> ...
>>
>>> Nice catch.  Basically, cpu_possible_map should only be cleared at boot,
>>> and probably not even then.
>> One thing that should be avoided, is clearing anything but the last bit in
>> the cpu_possible_map.  This is because num_possible_cpus != nr_cpu_ids when
>> there are holes in the map.  (nr_cpu_ids = highest possible cpu # + 1).
> 
> It's ok if nr_cpu_ids is an overestimate, isn't it?

Yes.  As I see it, nr_cpu_ids is the max index (+1) into anything dealing with
cpu's.  
> 
> But for this corner case, I think clearing cpu_possible_map is wrong.

Yes, I agree.  If for some reason, ACPI discovers a "possible" cpu but it faults
when brought online, then it simply stays offline.  It may never come online, or
with some trick hardware, it could be replaced on the running system and then
a new attempt can be made to bring it online.

Thanks,
Mike

