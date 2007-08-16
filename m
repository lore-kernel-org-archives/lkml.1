Return-Path: <linux-kernel-owner+w=401wt.eu-S938090AbXHPChA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938090AbXHPChA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2007 22:37:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759864AbXHPCgt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Aug 2007 22:36:49 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:60037 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755593AbXHPCgr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2007 22:36:47 -0400
Date: Wed, 15 Aug 2007 19:36:41 -0700
From: Paul Jackson <pj@sgi.com>
To: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
Cc: clameter@sgi.com, ckrm-tech@lists.sourceforge.net, balbir@in.ibm.com,
       vatsa@linux.vnet.ibm.com, bob.picco@hp.com,
       linux-kernel@vger.kernel.org, mel@skynet.ie, nacc@us.ibm.com,
       akpm@linux-foundation.org, kamezawa.hiroyu@jp.fujitsu.com,
       serge@hallyn.com
Subject: Re: [ckrm-tech] Regression in 2.6.23-rc2-mm2, mounting cpusets
 causes a hang
Message-Id: <20070815193641.c1a20434.pj@sgi.com>
In-Reply-To: <1187210893.5422.60.camel@localhost>
References: <20070812152126.GA26239@linux.vnet.ibm.com>
	<20070813201215.GA16908@vino.hallyn.com>
	<1187103831.6281.24.camel@localhost>
	<20070814180339.GA32553@vino.hallyn.com>
	<1187115224.6281.40.camel@localhost>
	<20070814192306.GB32553@vino.hallyn.com>
	<20070814204951.GA2065@vino.hallyn.com>
	<Pine.LNX.4.64.0708141427150.31693@schroedinger.engr.sgi.com>
	<1187127685.6281.139.camel@localhost>
	<Pine.LNX.4.64.0708141454110.32257@schroedinger.engr.sgi.com>
	<1187185392.5422.13.camel@localhost>
	<Pine.LNX.4.64.0708151333230.7628@schroedinger.engr.sgi.com>
	<1187210893.5422.60.camel@localhost>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.3; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph wrote (and Lee quoted):
> Looks like we need to fix cpuset nodemasks for the !NUMA case then?
> It cannot expect to find valid nodemasks if !NUMA.

The code in kernel/cpuset.c should be written as if there are always
valid nodemasks.  In the case of !NUMA, it will happen that there is
only one node, but kernel/cpuset.c should not manifest that detail.

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.925.600.0401
