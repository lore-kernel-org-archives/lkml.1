Return-Path: <linux-kernel-owner+w=401wt.eu-S1757012AbXJBWMt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757012AbXJBWMt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2007 18:12:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752055AbXJBWMm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Oct 2007 18:12:42 -0400
Received: from tomts22.bellnexxia.net ([209.226.175.184]:59423 "EHLO
	tomts22-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753528AbXJBWMl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2007 18:12:41 -0400
X-Greylist: delayed 888 seconds by postgrey-1.27 at vger.kernel.org; Tue, 02 Oct 2007 18:12:41 EDT
Subject: Re: [RFC/PATCH] Add sysfs control to modify a user's cpu share
From: Eric St-Laurent <ericstl34@sympatico.ca>
To: Ingo Molnar <mingo@elte.hu>
Cc: Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       Mike Galbraith <efault@gmx.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>,
       lkml <linux-kernel@vger.kernel.org>, maneesh@linux.vnet.ibm.com,
       Andrew Morton <akpm@linux-foundation.org>,
       Sudhir Kumar <skumar@linux.vnet.ibm.com>
In-Reply-To: <20071001144402.GA3505@elte.hu>
References: <1190723327.7112.5.camel@Homer.simpson.net>
	 <1190724893.13716.8.camel@Homer.simpson.net>
	 <20070925131717.GM26289@linux.vnet.ibm.com>
	 <1190725693.13716.10.camel@Homer.simpson.net>
	 <20070925132528.GN26289@linux.vnet.ibm.com>
	 <1190726682.11260.1.camel@Homer.simpson.net>
	 <20070925140559.GB26310@linux.vnet.ibm.com>
	 <20070925143755.GA15594@elte.hu> <20070926210737.GA8663@elte.hu>
	 <20071001140454.GA19439@linux.vnet.ibm.com> <20071001144402.GA3505@elte.hu>
Content-Type: text/plain
Date: Tue, 02 Oct 2007 18:12:39 -0400
Message-Id: <1191363159.29539.15.camel@perkele>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 2007-10-01 at 16:44 +0200, Ingo Molnar wrote:
> > Adds tunables in sysfs to modify a user's cpu share.
> > 
> > A directory is created in sysfs for each new user in the system.
> > 
> > 	/sys/kernel/uids/<uid>/cpu_share
> > 
> > Reading this file returns the cpu shares granted for the user.
> > Writing into this file modifies the cpu share for the user. Only an 
> > administrator is allowed to modify a user's cpu share.
> > 
> > Ex: 
> > 	# cd /sys/kernel/uids/
> > 	# cat 512/cpu_share
> > 	1024
> > 	# echo 2048 > 512/cpu_share
> > 	# cat 512/cpu_share
> > 	2048
> > 	#
> 
> looks good to me! I think this API is pretty straightforward. I've put 
> this into my tree and have updated the sched-devel git tree:
> 

While a sysfs interface is OK and somewhat orthogonal to the interface
proposed the containers patches, I think maybe a new syscall should be
considered.

Since we now have a fair share cpu scheduler, maybe an interface to
specify the cpu share directly (alternatively to priority) make sense.

For processes, it may become more intuitive (and precise) to set the
processing share directly than setting a priority which is converted to
a share.

Maybe something similar to ioprio_set() and ioprio_get() syscalls:

- per user cpu share
- per user group cpu share
- per process cpu share
- per process group cpu share


Best regards,

- Eric


