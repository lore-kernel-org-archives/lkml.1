Return-Path: <linux-kernel-owner+w=401wt.eu-S1755837AbXJCD6q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755837AbXJCD6q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2007 23:58:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751522AbXJCD6j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Oct 2007 23:58:39 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:58681 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751408AbXJCD6i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2007 23:58:38 -0400
Date: Wed, 3 Oct 2007 09:39:39 +0530
From: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
To: Eric St-Laurent <ericstl34@sympatico.ca>
Cc: Ingo Molnar <mingo@elte.hu>, Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       Mike Galbraith <efault@gmx.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>,
       lkml <linux-kernel@vger.kernel.org>, maneesh@linux.vnet.ibm.com,
       Andrew Morton <akpm@linux-foundation.org>,
       Sudhir Kumar <skumar@linux.vnet.ibm.com>
Subject: Re: [RFC/PATCH] Add sysfs control to modify a user's cpu share
Message-ID: <20071003040939.GI5724@linux.vnet.ibm.com>
Reply-To: vatsa@linux.vnet.ibm.com
References: <20070925131717.GM26289@linux.vnet.ibm.com> <1190725693.13716.10.camel@Homer.simpson.net> <20070925132528.GN26289@linux.vnet.ibm.com> <1190726682.11260.1.camel@Homer.simpson.net> <20070925140559.GB26310@linux.vnet.ibm.com> <20070925143755.GA15594@elte.hu> <20070926210737.GA8663@elte.hu> <20071001140454.GA19439@linux.vnet.ibm.com> <20071001144402.GA3505@elte.hu> <1191363159.29539.15.camel@perkele>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1191363159.29539.15.camel@perkele>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 02, 2007 at 06:12:39PM -0400, Eric St-Laurent wrote:
> While a sysfs interface is OK and somewhat orthogonal to the interface
> proposed the containers patches, I think maybe a new syscall should be
> considered.

We had discussed syscall vs filesystem based interface for resource
management [1] and there was a heavy bias favoring filesystem based interface,
based on which the container (now "cgroup") filesystem evolved.

Where we already have one interface defined, I would be against adding 
an equivalent syscall interface.

Note that this "fair-user" scheduling can in theory be accomplished
using the same cgroup based interface, but requires some extra setup in
userspace (either to run a daemon which moves tasks to appropriate
control groups/containers upon their uid change OR to modify initrd to mount 
cgroup filesystem at early bootup time). I expect most distros to enable
CONFIG_FAIR_CGROUP_SCHED (control group based fair group scheduler) and not 
CONFIG_FAIR_USER_SHCED (user id based fair group scheduler). The only
reason why we are providing CONFIG_FAIR_USER_SCHED and the associated
sysfs interface is to help test group scheduler w/o requiring knowledge
of cgroup filesystem.

Reference:

1. http://marc.info/?l=linux-kernel&m=116231242201300&w=2

-- 
Regards,
vatsa
