Return-Path: <linux-kernel-owner+w=401wt.eu-S1758984AbYFWQ67@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758984AbYFWQ67 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2008 12:58:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755292AbYFWQ6w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jun 2008 12:58:52 -0400
Received: from relay2.sgi.com ([192.48.171.30]:42572 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753635AbYFWQ6v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2008 12:58:51 -0400
Message-ID: <485FD644.80208@sgi.com>
Date: Mon, 23 Jun 2008 09:58:44 -0700
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: Vegard Nossum <vegard.nossum@gmail.com>, Adrian Bunk <bunk@kernel.org>,
       Srivatsa Vaddagiri <vatsa@in.ibm.com>, linux-kernel@vger.kernel.org,
       Gautham R Shenoy <ego@in.ibm.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       "Zhang, Yanmin" <yanmin.zhang@intel.com>,
       Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: Re: v2.6.26-rc7: BUG: unable to handle kernel NULL pointer dereference
References: <20080622125633.GA8166@damson.getinternet.no> <20080622155627.GA20122@cs181140183.pp.htv.fi> <19f34abd0806220929y1ca9d0c4nbf480473b7ce018a@mail.gmail.com> <200806231326.11328.rusty@rustcorp.com.au>
In-Reply-To: <200806231326.11328.rusty@rustcorp.com.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rusty Russell wrote:
> On Monday 23 June 2008 02:29:07 Vegard Nossum wrote:
>> And the (cpu < nr_cpu_ids) fails because the CPU has just been
>> offlined (or failed to initialize, but it's the same thing), while
>> NR_CPUS is the value that was compiled in as CONFIG_NR_CPUS (so the
>> former check will always be true).
>>
>> I don't think it is valid to ask for a per_cpu() variable on a CPU
>> which does not exist, though
> 
> Yes it is.  As long as cpu_possible(cpu), per_cpu(cpu) is valid.
> 
> The number check should be removed: checking cpu_possible() is sufficient.
> 
> Hope that helps,
> Rusty.

I don't see a check for index being out of range in cpu_possible().

Thanks,
Mike
