Return-Path: <linux-kernel-owner+w=401wt.eu-S933493AbXHOQdT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933493AbXHOQdT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2007 12:33:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933450AbXHOQbx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Aug 2007 12:31:53 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:45734 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S933473AbXHOQbu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2007 12:31:50 -0400
Date: Wed, 15 Aug 2007 09:31:45 -0700
From: Paul Jackson <pj@sgi.com>
To: "Serge E. Hallyn" <serge@hallyn.com>
Cc: Lee.Schermerhorn@hp.com, clameter@sgi.com, serge@hallyn.com,
       dhaval@linux.vnet.ibm.com, bob.picco@hp.com, nacc@us.ibm.com,
       kamezawa.hiroyu@jp.fujitsu.com, mel@skynet.ie,
       akpm@linux-foundation.org, balbir@in.ibm.com, vatsa@linux.vnet.ibm.com,
       linux-kernel@vger.kernel.org, ckrm-tech@lists.sourceforge.net
Subject: Re: Regression in 2.6.23-rc2-mm2, mounting cpusets causes a hang
Message-Id: <20070815093145.0c0480bb.pj@sgi.com>
In-Reply-To: <20070815143125.GA11582@vino.hallyn.com>
References: <20070813201215.GA16908@vino.hallyn.com>
	<1187103831.6281.24.camel@localhost>
	<20070814180339.GA32553@vino.hallyn.com>
	<1187115224.6281.40.camel@localhost>
	<20070814192306.GB32553@vino.hallyn.com>
	<20070814204951.GA2065@vino.hallyn.com>
	<Pine.LNX.4.64.0708141427150.31693@schroedinger.engr.sgi.com>
	<1187127685.6281.139.camel@localhost>
	<Pine.LNX.4.64.0708141454110.32257@schroedinger.engr.sgi.com>
	<1187185392.5422.13.camel@localhost>
	<20070815143125.GA11582@vino.hallyn.com>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.3; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Serge wrote:
> Paul, is the mems stuff in cpusets only really useful for NUMA cases?

I haven't been following this closely, but offhand, my take is that:
 1) CONFIG_CPUSETS is primarily useful on SMP or NUMA systems.
 2) It can be configured on non-NUMA systems (it still seems to
	need CONFIG_SMP ... not sure why.)
 3) Kernels configured for CONFIG_CPUSETS can be (and often are)
	run on systems with just one CPU, or just one memory node.
 4) To the user, running a CONFIG_CPUSETS enabled kernel w/o
	CONFIG_NUMA, or on a system with just one memory node
	should allow all the usual CPUSET operations, as if
	one just had one memory node, number '0'.

If all systems in our universe only had one memory node, then
cpusets wouldn't do memory -- it would not be useful.

But for consistency of interface between various configured systems,
it is useful to have cpusets working the same across both NUMA and
non-NUMA systems.  Some systems just happen to have only one memory
node.

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.925.600.0401
