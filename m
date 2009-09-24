Return-Path: <linux-kernel-owner+w=401wt.eu-S1754562AbZIXAyS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754562AbZIXAyS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Sep 2009 20:54:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754537AbZIXAyK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Sep 2009 20:54:10 -0400
Received: from gate.crashing.org ([63.228.1.57]:45080 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752425AbZIXAx7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Sep 2009 20:53:59 -0400
Subject: Re: [PATCH v3 0/3] cpu: pseries: Cpu offline states framework
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Gautham R Shenoy <ego@in.ibm.com>, Joel Schopp <jschopp@austin.ibm.com>,
       Balbir Singh <balbir@in.ibm.com>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Dipankar Sarma <dipankar@in.ibm.com>,
       Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
       Arun R Bharadwaj <arun@linux.vnet.ibm.com>,
       linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
       "Darrick J. Wong" <djwong@us.ibm.com>
In-Reply-To: <1253016701.5506.73.camel@laptop>
References: <20090915120629.20523.79019.stgit@sofia.in.ibm.com>
	 <1253016701.5506.73.camel@laptop>
Content-Type: text/plain
Date: Thu, 24 Sep 2009 10:51:41 +1000
Message-Id: <1253753501.7103.358.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-09-15 at 14:11 +0200, Peter Zijlstra wrote:
> I still think its a layering violation... its the hypervisor manager
> that should be bothered in what state an off-lined cpu is in. 
> 
That's not how our hypervisor works.

If you ask through the management interface, to remove a CPU from a
partition, the HV will communicate with a daemon inside the partition
that will then unplug the CPU via the right call.

I don't really understand your objections to be honest. And I fail to
see why it would be a layering violation to have the ability for the OS
to indicate in what state it wishes to relinguish a CPU to the
hypervisor, which more or less defines what is the expected latency for
getting it back later on.

Ben.


