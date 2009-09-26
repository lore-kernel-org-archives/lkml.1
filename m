Return-Path: <linux-kernel-owner+w=401wt.eu-S1751977AbZIZJz3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751977AbZIZJz3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Sep 2009 05:55:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751923AbZIZJz2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Sep 2009 05:55:28 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:35693 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751909AbZIZJzX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Sep 2009 05:55:23 -0400
Date: Sat, 26 Sep 2009 11:55:19 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Gautham R Shenoy <ego@in.ibm.com>, Joel Schopp <jschopp@austin.ibm.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Balbir Singh <balbir@in.ibm.com>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Dipankar Sarma <dipankar@in.ibm.com>,
       Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
       Arun R Bharadwaj <arun@linux.vnet.ibm.com>,
       linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
       "Darrick J. Wong" <djwong@us.ibm.com>
Subject: Re: [PATCH v3 0/3] cpu: pseries: Cpu offline states framework
Message-ID: <20090926095518.GE1331@ucw.cz>
References: <20090915120629.20523.79019.stgit@sofia.in.ibm.com> <1253016701.5506.73.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1253016701.5506.73.camel@laptop>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 2009-09-15 14:11:41, Peter Zijlstra wrote:
> On Tue, 2009-09-15 at 17:36 +0530, Gautham R Shenoy wrote:
> > This patchset contains the offline state driver implemented for
> > pSeries. For pSeries, we define three available_hotplug_states. They are:
> > 
> >         online: The processor is online.
> > 
> >         offline: This is the the default behaviour when the cpu is offlined
> >         even in the absense of this driver. The CPU would call make an
> >         rtas_stop_self() call and hand over the CPU back to the resource pool,
> >         thereby effectively deallocating that vCPU from the LPAR.
> >         NOTE: This would result in a configuration change to the LPAR
> >         which is visible to the outside world.
> > 
> >         inactive: This cedes the vCPU to the hypervisor with a cede latency
> >         specifier value 2.
> >         NOTE: This option does not result in a configuration change
> >         and the vCPU would be still entitled to the LPAR to which it earlier
> >         belong to.
> > 
> > Any feedback on the patchset will be immensely valuable.
> 
> I still think its a layering violation... its the hypervisor manager
> that should be bothered in what state an off-lined cpu is in. 

Agreed. Proposed interface is ugly.

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
