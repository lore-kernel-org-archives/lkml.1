Return-Path: <linux-kernel-owner+w=401wt.eu-S1754526AbZIXAuw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754526AbZIXAuw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Sep 2009 20:50:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752803AbZIXAuv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Sep 2009 20:50:51 -0400
Received: from gate.crashing.org ([63.228.1.57]:44378 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752601AbZIXAuv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Sep 2009 20:50:51 -0400
Subject: Re: [PATCH v2 0/2] cpu: pseries: Offline state framework.
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Gautham R Shenoy <ego@in.ibm.com>, Joel Schopp <jschopp@austin.ibm.com>,
       Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
       Dipankar Sarma <dipankar@in.ibm.com>, Balbir Singh <balbir@in.ibm.com>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
       "Darrick J. Wong" <djwong@us.ibm.com>
In-Reply-To: <1251869611.7547.38.camel@twins>
References: <20090828095741.10641.32053.stgit@sofia.in.ibm.com>
	 <1251869611.7547.38.camel@twins>
Content-Type: text/plain
Date: Thu, 24 Sep 2009 10:48:27 +1000
Message-Id: <1253753307.7103.356.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-09-02 at 07:33 +0200, Peter Zijlstra wrote:
> 
> I'm still thinking this is a bad idea.
> 
> The OS should only know about online/offline.
> 
> Use the hypervisor interface to deal with the cpu once its offline.
> 
> That is, I think this interface you propose is a layering violation.
> 
I don't quite follow your logic here. This is useful for more than just
hypervisors. For example, take the HV out of the picture for a moment
and imagine that the HW has the ability to offline CPU in various power
levels, with varying latencies to bring them back.

For example, the HW can put them in some low power state where they can
be re-plugged quickly, or can shutdown entire power planes completely,
possibly allowing physical hotplug, but that takes much longer to bring
them back into the pool.

In any case, regarding the pseries case, this is how our hypervisor
works and I don't think we can change it, other than by always going
into the "cede" function and having some weird separate interface in the
arch to then whack them into some different state.

Ben.


