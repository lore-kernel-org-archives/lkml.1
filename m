Return-Path: <linux-kernel-owner+w=401wt.eu-S1755880AbXJaA3g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755880AbXJaA3g (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2007 20:29:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753302AbXJaA32
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Oct 2007 20:29:28 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:55041 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752608AbXJaA31 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2007 20:29:27 -0400
Date: Tue, 30 Oct 2007 17:29:23 -0700
From: Paul Jackson <pj@sgi.com>
To: David Rientjes <rientjes@google.com>
Cc: clameter@sgi.com, Lee.Schermerhorn@hp.com, akpm@linux-foundation.org,
       ak@suse.de, linux-kernel@vger.kernel.org
Subject: Re: [patch 2/2] cpusets: add interleave_over_allowed option
Message-Id: <20071030172923.d5d8dac3.pj@sgi.com>
In-Reply-To: <alpine.DEB.0.9999.0710301648540.28111@chino.kir.corp.google.com>
References: <alpine.DEB.0.9999.0710251540210.11929@chino.kir.corp.google.com>
	<alpine.DEB.0.9999.0710261416160.11594@chino.kir.corp.google.com>
	<1193434278.5032.106.camel@localhost>
	<alpine.DEB.0.9999.0710261436140.16966@chino.kir.corp.google.com>
	<20071026180713.aeedfac2.pj@sgi.com>
	<Pine.LNX.4.64.0710261823210.30012@schroedinger.engr.sgi.com>
	<20071026194144.6042316a.pj@sgi.com>
	<alpine.DEB.0.9999.0710262149090.26464@chino.kir.corp.google.com>
	<20071027161955.e9d4d2db.pj@sgi.com>
	<alpine.DEB.0.9999.0710272231170.23796@chino.kir.corp.google.com>
	<20071028164637.8d1b45b0.pj@sgi.com>
	<alpine.DEB.0.9999.0710281742090.26837@chino.kir.corp.google.com>
	<20071028212745.57a7db67.pj@sgi.com>
	<alpine.DEB.0.9999.0710282130320.32474@chino.kir.corp.google.com>
	<20071029001554.c12b6b6c.pj@sgi.com>
	<alpine.DEB.0.9999.0710301607430.19750@chino.kir.corp.google.com>
	<20071030164414.b353e41c.pj@sgi.com>
	<alpine.DEB.0.9999.0710301648540.28111@chino.kir.corp.google.com>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.3; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

David wrote:
> Of course they have specific affinity needs, that's why they used 
> mempolicies.

No.  Good grief.  If they are just looking for some set of memory
banks, not to other node-specific hardware, then they might not need
a specific node.

Consider for example a multi-threaded, compute bound, long running
scientific computation that has a substantial and fussy memory layout.
Remapping it from one cpuset to another having the same NUMA topology
may well work fine, once its memory caches recover.  Reverting it to
the lowest common denominator MPOL_DEFAULT policy because (Choice C) it
no longer has access to its initial nodes might devastate its
performance.

pj wrote:
> I sure wish I knew what real world, actual, not hypothetical, situations
> were motivating this.

I'm still wishing ...

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.925.600.0401
