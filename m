Return-Path: <linux-kernel-owner+w=401wt.eu-S1767359AbXCIQ1c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767359AbXCIQ1c (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2007 11:27:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767363AbXCIQ1b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Mar 2007 11:27:31 -0500
Received: from e36.co.us.ibm.com ([32.97.110.154]:40421 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1767359AbXCIQ1a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2007 11:27:30 -0500
Date: Fri, 9 Mar 2007 22:04:30 +0530
From: Srivatsa Vaddagiri <vatsa@in.ibm.com>
To: "Paul Menage" <menage@google.com>
Cc: "Serge E. Hallyn" <serue@us.ibm.com>, ebiederm@xmission.com,
       sam@vilain.net, akpm@linux-foundation.org, pj@sgi.com, dev@sw.ru,
       xemul@sw.ru, containers@lists.osdl.org, winget@google.com,
       ckrm-tech@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] resource control file system - aka containers on top of nsproxy!
Message-ID: <20070309163430.GN6504@in.ibm.com>
Reply-To: vatsa@in.ibm.com
References: <20070301133543.GK15509@in.ibm.com> <6599ad830703061832w49179e75q1dd975369ba8ef39@mail.gmail.com> <20070307173031.GC2336@in.ibm.com> <20070307174346.GA19521@sergelap.austin.ibm.com> <20070307180055.GC17151@in.ibm.com> <20070307205846.GB7010@sergelap.austin.ibm.com> <6599ad830703071320ib687019h34d2e66c4abc3794@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6599ad830703071320ib687019h34d2e66c4abc3794@mail.gmail.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 07, 2007 at 01:20:18PM -0800, Paul Menage wrote:
> On 3/7/07, Serge E. Hallyn <serue@us.ibm.com> wrote:
> >
> >All that being said, if it were going to save space without overly
> >complicating things I'm actually not opposed to using nsproxy, but it
> 
> If space-saving is the main issue, then the latest version of my
> containers patches uses just a single pointer in the task_struct, and
> all tasks in the same set of containers (across all hierarchies) will
> share a single container_group object, which holds the actual pointers
> to container state.

Paul,
	Some more thoughts, mostly coming from the point of view of
vservers/containers/"whaever is the set of tasks sharing a nsproxy is
called".

1. What is the fundamental unit over which resource-management is
applied? Individual tasks or individual containers?

	/me thinks latter. In which case, it makes sense to stick 
	resource control information in the container somewhere.
	Just like when controlling a user's resource consumption, 
	'struct user_struct' may be a natural place to put these resource 
 	limits.

2. Regarding space savings, if 100 tasks are in a container (I dont know
   what is a typical number) -and- lets say that all tasks are to share
   the same resource allocation (which seems to be natural), then having
   a 'struct container_group *' pointer in each task_struct seems to be not 
   very efficient (simply because we dont need that task-level granularity of
   managing resource allocation).

3. This next leads me to think that 'tasks' file in each directory doesnt make 
   sense for containers. In fact it can lend itself to error situations (by 
   administrator/script mistake) when some tasks of a container are in one 
   resource class while others are in a different class.

	Instead, from a containers pov, it may be usefull to write
	a 'container id' (if such a thing exists) into the tasks file
	which will move all the tasks of the container into 
	the new resource class. This is the same requirement we
	discussed long back of moving all threads of a process into new 
	resource class.


-- 
Regards,
vatsa
