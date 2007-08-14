Return-Path: <linux-kernel-owner+w=401wt.eu-S1751974AbXHNWNF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751974AbXHNWNF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2007 18:13:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933554AbXHNVvV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Aug 2007 17:51:21 -0400
Received: from atlrel7.hp.com ([156.153.255.213]:40196 "EHLO atlrel7.hp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753440AbXHNVvM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2007 17:51:12 -0400
Subject: Re: Regression in 2.6.23-rc2-mm2, mounting cpusets causes a hang
From: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
To: Christoph Lameter <clameter@sgi.com>
Cc: "Serge E. Hallyn" <serge@hallyn.com>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>, bob.picco@hp.com,
       nacc@us.ibm.com, kamezawa.hiroyu@jp.fujitsu.com, mel@skynet.ie,
       akpm@linux-foundation.org, Balbir Singh <balbir@in.ibm.com>,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       lkml <linux-kernel@vger.kernel.org>,
       ckrm-tech <ckrm-tech@lists.sourceforge.net>
In-Reply-To: <Pine.LNX.4.64.0708141427150.31693@schroedinger.engr.sgi.com>
References: <20070812152126.GA26239@linux.vnet.ibm.com>
	 <20070813201215.GA16908@vino.hallyn.com>
	 <1187103831.6281.24.camel@localhost>
	 <20070814180339.GA32553@vino.hallyn.com>
	 <1187115224.6281.40.camel@localhost>
	 <20070814192306.GB32553@vino.hallyn.com>
	 <20070814204951.GA2065@vino.hallyn.com>
	 <Pine.LNX.4.64.0708141427150.31693@schroedinger.engr.sgi.com>
Content-Type: text/plain
Organization: HP/OSLO
Date: Tue, 14 Aug 2007 17:41:25 -0400
Message-Id: <1187127685.6281.139.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-08-14 at 14:28 -0700, Christoph Lameter wrote:
> On Tue, 14 Aug 2007, Serge E. Hallyn wrote:
> 
> > CONFIG_NODES_SHIFT was unset, so MAX_NUMNODES=1, so
> > node_state() and node_set_state() are dummies.
> 
> Ok then you did not have a NUMA system configured. So its okay for the 
> dummies to ignore the stuff. CONFIG_NODES_SHIFT is a constant and does not 
> change. The first bit is always set.

The first bit [node 0] is only set for the N_ONLINE [and N_POSSIBLE]
mask.  We could add the static init for the other masks, but since
non-numa platforms are going through the __build_all_zonelists, they
might as well set the MEMORY bits explicitly.  Or, maybe you'll
disagree ;-).

Lee


