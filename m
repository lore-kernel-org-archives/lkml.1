Return-Path: <linux-kernel-owner+w=401wt.eu-S1759934AbZIPUSA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759934AbZIPUSA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 16:18:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755912AbZIPUR5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 16:17:57 -0400
Received: from e28smtp04.in.ibm.com ([59.145.155.4]:54761 "EHLO
	e28smtp04.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754737AbZIPUR5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 16:17:57 -0400
Date: Thu, 17 Sep 2009 01:47:49 +0530
From: Dipankar Sarma <dipankar@in.ibm.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: svaidy@linux.vnet.ibm.com, Gautham R Shenoy <ego@in.ibm.com>,
       Joel Schopp <jschopp@austin.ibm.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Balbir Singh <balbir@in.ibm.com>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Arun R Bharadwaj <arun@linux.vnet.ibm.com>,
       linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
       "Darrick J. Wong" <djwong@us.ibm.com>
Subject: Re: [PATCH v3 0/3] cpu: pseries: Cpu offline states framework
Message-ID: <20090916201749.GA19107@in.ibm.com>
Reply-To: dipankar@in.ibm.com
References: <20090915120629.20523.79019.stgit@sofia.in.ibm.com> <1253016701.5506.73.camel@laptop> <20090916152820.GA12571@in.ibm.com> <1253115171.7180.1.camel@laptop> <20090916162459.GB12571@in.ibm.com> <1253118916.7180.6.camel@laptop> <20090916170314.GH15538@dirshya.in.ibm.com> <1253121755.7180.8.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1253121755.7180.8.camel@laptop>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 16, 2009 at 07:22:35PM +0200, Peter Zijlstra wrote:
> On Wed, 2009-09-16 at 22:33 +0530, Vaidyanathan Srinivasan wrote:
> > * Peter Zijlstra <a.p.zijlstra@chello.nl> [2009-09-16 18:35:16]:
> > 
> > > Now if you were to try and online the cpus in the guest, it'd fail
> > > because the cpus aren't backed anymore, and the hot-plug simply
> > > times-out and fails.
> > > 
> > > And we're still good, right?
> > 
> > The requirement differ here.  If we had offlined 2 vCPUs for the
> > purpose of system reconfiguration, the expected behavior with offline
> > interface will work right.  However the proposed cede interface is
> > needed when we want them to temporarily go away but still come back
> > when we do an online.  We want the online to always succeed since the
> > backing physical resources are not relinquished.  The proposed
> > interface facilitates offline without relinquishing the physical
> > resources assigned to LPARs.
> 
> Then make that the platform default and leave the lpar management to
> whatever pokes at the lpar?

That could have worked - however lpar management already uses
the same sysfs interface to poke. The current semantics make the lpar 
vcpu deconfig state the platform default assuming that it will be used for
lpar management. The only clean way to do this without breaking lpar
management stuff is to add another state - "inactive" and retain backward
compatibility.

Thanks
Dipankar
