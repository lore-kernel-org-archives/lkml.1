Return-Path: <linux-kernel-owner+w=401wt.eu-S1757854AbYCEEvx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757854AbYCEEvx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2008 23:51:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752615AbYCEEvo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Mar 2008 23:51:44 -0500
Received: from E23SMTP04.au.ibm.com ([202.81.18.173]:59815 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751717AbYCEEvn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2008 23:51:43 -0500
Message-ID: <47CE2632.20209@linux.vnet.ibm.com>
Date: Wed, 05 Mar 2008 10:18:50 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Xpl++ <xpl@amln.net>
CC: Dhaval Giani <dhaval@linux.vnet.ibm.com>, fedora-devel-list@redhat.com,
       opensuse-packaging@opensuse.org, lkml <linux-kernel@vger.kernel.org>,
       containers@lists.linux-foundation.org, Balbir Singh <balbir@in.ibm.com>,
       menage@google.com, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       Sudhir Kumar <skumar@linux.vnet.ibm.com>
Subject: Re: [RFC] libcg: design and plans
References: <20080304152341.GB5659@linux.vnet.ibm.com> <47CD83C7.4020206@amln.net>
In-Reply-To: <47CD83C7.4020206@amln.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Xpl++ wrote:
> Hi,
> 
> I was wonder if creating such library makes any sense at all,
> considering the nature of cgroups, the way they work and their possible
> application?
> It seems to me that any attempt to create a 'simple' API would actualy
> result in something that will be much harder to use that just making raw
> mkdir/open/read/write/close operations. Another thing is suggested
> config for this lib would be more appropriate for a daemon rather than a
> library.

The configuration file is important, since it allows us two levels of control.
At one level the system administrator and at the other level applications. Each
application can maintain it's own hierarchy across reboots.

We thought of a daemon, but there were several overheads and disadvantages. For
one, we needed an IPC mechanism to communicate every client request to the
daemon, the client being the application. The daemon also becomes the single
point of failure for all applications. Moreover, we want to provide the ability
to programmatically update the configuration. A daemon, if desired can be built
on top of the library we propose.


> In general - cgroup is a very flexible subsystem that can be used in a
> wide variety of ways and modes and trying to create a universal simple
> API would more likely result in something hard to manage and work with.

I agree that cgroups is flexible, but why do you think abstracting common tasks
amongst applications will be hard to manage and work with? We want to provide
API that will allow us to fill in parameters and say -- go create this group or
delete this group.

> The idea of having multiple container managers (applications that use
> libcg) creates a lots of questions and possible issues. Containers are
> supposed provide a flexible resource management and task grouping
> ability, which somewhat implies that there cannot be two different
> resource managers per node without one knowing well the
> desires/goals/methods of the other and vice versa.

We don't assume that there cannot be two different resource managers per node.
We don't enforce any policy, we just allow for easy creation and manipulation of
control groups hierarchially.

And should there be
> only one manager per node - probably it will be easier for it to use
> cgroup subsystem directly rather than using a wrapper library?
> 

Could you please elaborate, why is it probably easier?

-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
