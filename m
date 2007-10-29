Return-Path: <linux-kernel-owner+w=401wt.eu-S1757201AbXJ2UCa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757201AbXJ2UCa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2007 16:02:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753379AbXJ2UCU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Oct 2007 16:02:20 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:44068 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752453AbXJ2UCT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2007 16:02:19 -0400
Date: Mon, 29 Oct 2007 13:02:17 -0700
From: Paul Jackson <pj@sgi.com>
To: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
Cc: rientjes@google.com, clameter@sgi.com, akpm@linux-foundation.org,
       ak@suse.de, linux-kernel@vger.kernel.org
Subject: Re: [patch 2/2] cpusets: add interleave_over_allowed option
Message-Id: <20071029130217.6dd46df0.pj@sgi.com>
In-Reply-To: <1193676854.5035.121.camel@localhost>
References: <alpine.DEB.0.9999.0710251540210.11929@chino.kir.corp.google.com>
	<Pine.LNX.4.64.0710251725440.10197@schroedinger.engr.sgi.com>
	<20071025185506.8c373aa8.pj@sgi.com>
	<alpine.DEB.0.9999.0710251900080.8024@chino.kir.corp.google.com>
	<1193412644.5032.13.camel@localhost>
	<alpine.DEB.0.9999.0710261145400.11674@chino.kir.corp.google.com>
	<20071026120037.7b95a136.pj@sgi.com>
	<alpine.DEB.0.9999.0710261344180.6249@chino.kir.corp.google.com>
	<1193433239.5032.95.camel@localhost>
	<alpine.DEB.0.9999.0710261416160.11594@chino.kir.corp.google.com>
	<1193434278.5032.106.camel@localhost>
	<alpine.DEB.0.9999.0710261436140.16966@chino.kir.corp.google.com>
	<20071026180713.aeedfac2.pj@sgi.com>
	<Pine.LNX.4.64.0710261823210.30012@schroedinger.engr.sgi.com>
	<20071026194144.6042316a.pj@sgi.com>
	<alpine.DEB.0.9999.0710262149090.26464@chino.kir.corp.google.com>
	<20071027161955.e9d4d2db.pj@sgi.com>
	<1193676854.5035.121.camel@localhost>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.3; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Lee wrote:
> In libnuma in numactl-1.0.2 that I recently grabbed off Andi's site,
> numa_available() indeed issues this call.  But, I don't see any internal
> calls to numa_available() [comments says all other calls undefined when
> numa_available() returns an error] nor any other calls to
> get_mempolicy() with all null/0 args.  So, you'd be depending on the
> application to call numa_available().

Aha - good point.  It happened to be the numactl command line utility
that I tested with that issued the get_mempolicy(0,0,0,0,0) call.

Yup - this proposed hack, to have the kernel revert to the original
memory policy nodemask numbering if it sees such a getmempolicy call
is now officially dead meat.

Thanks.

> However, you could define an
> additional MPOL_F_* flag to get_mempolicy() that is issued in library
> init code to enable new behavior--again, based on some indication that
> new behavior is desired or not.

Yes - I am intending to define such MPOL_F_* flags, to set and get
which behavior applies to the current task.

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.925.600.0401
