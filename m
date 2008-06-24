Return-Path: <linux-kernel-owner+w=401wt.eu-S1761925AbYFXOo5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761925AbYFXOo5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2008 10:44:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761225AbYFXOot
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jun 2008 10:44:49 -0400
Received: from relay2.sgi.com ([192.48.171.30]:57474 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1761144AbYFXOos (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2008 10:44:48 -0400
Message-ID: <4861085D.8020506@sgi.com>
Date: Tue, 24 Jun 2008 07:44:45 -0700
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
References: <20080622125633.GA8166@damson.getinternet.no> <200806241136.52430.rusty@rustcorp.com.au> <1214294783.25608.75.camel@ymzhang> <200806242314.51656.rusty@rustcorp.com.au>
In-Reply-To: <200806242314.51656.rusty@rustcorp.com.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rusty Russell wrote:
...
> Nice catch.  Basically, cpu_possible_map should only be cleared at boot, and 
> probably not even then.
> 

One thing that should be avoided, is clearing anything but the last bit in the
cpu_possible_map.  This is because num_possible_cpus != nr_cpu_ids when there
are holes in the map.  (nr_cpu_ids = highest possible cpu # + 1).

Thanks,
Mike
