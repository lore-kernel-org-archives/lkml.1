Return-Path: <linux-kernel-owner+w=401wt.eu-S965825AbXCJDMG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965825AbXCJDMG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2007 22:12:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965712AbXCJDMF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Mar 2007 22:12:05 -0500
Received: from e2.ny.us.ibm.com ([32.97.182.142]:60829 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965825AbXCJDME (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2007 22:12:04 -0500
Date: Sat, 10 Mar 2007 08:49:09 +0530
From: Srivatsa Vaddagiri <vatsa@in.ibm.com>
To: "Paul Menage" <menage@google.com>
Cc: ckrm-tech@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       sam@vilain.net, dev@sw.ru, xemul@sw.ru, pj@sgi.com,
       ebiederm@xmission.com, winget@google.com, containers@lists.osdl.org,
       "Serge E. Hallyn" <serue@us.ibm.com>, akpm@linux-foundation.org
Subject: Re: [ckrm-tech] [PATCH 0/2] resource control file system - aka containers on top of nsproxy!
Message-ID: <20070310031909.GA11330@in.ibm.com>
Reply-To: vatsa@in.ibm.com
References: <20070301133543.GK15509@in.ibm.com> <6599ad830703061832w49179e75q1dd975369ba8ef39@mail.gmail.com> <20070307173031.GC2336@in.ibm.com> <20070307174346.GA19521@sergelap.austin.ibm.com> <20070307180055.GC17151@in.ibm.com> <20070307205846.GB7010@sergelap.austin.ibm.com> <6599ad830703071320ib687019h34d2e66c4abc3794@mail.gmail.com> <20070309163430.GN6504@in.ibm.com> <6599ad830703091409s3d233829gb8f0afbfd2883b15@mail.gmail.com> <20070310020220.GE21661@in.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070310020220.GE21661@in.ibm.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 10, 2007 at 07:32:20AM +0530, Srivatsa Vaddagiri wrote:
> Ok, let me see if I can convey what I had in mind better:
> 
> 	    uts_ns pid_ns ipc_ns
> 		\    |    /
> 		---------------
> 	       | nsproxy  	|
> 	        ----------------
>                  /  |   \    \ <-- 'nsproxy' pointer
> 		T1  T2  T3 ...T1000
> 		|   |   |      | <-- 'containers' pointer (4/8 KB for 1000 task)
> 	       -------------------
> 	      | container_group	  |
> 	       ------------------	
> 		/
> 	     ----------
> 	    | container |
> 	     ----------
> 		|
> 	     ----------
> 	    | cpu_limit |
> 	     ---------- 

[snip]

> We save on 4/8 KB (for 1000 tasks) by avoiding the 'containers' pointer
> in each task_struct (just to get to the resource limit information).

Having the 'containers' pointer in each task-struct is great from a
non-container res mgmt perspective. It lets you dynamically decide what
is the fundamental unit of res mgmt. 

It could be {T1, T5} tasks/threads of a process, or {T1, T3, T8, T10} tasks of 
a session (for limiting login time per session), or {T1, T2 ..T10, T18, T27} 
tasks of a user etc.

But from a vserver/container pov, this level flexibility (at a -task- level) of 
deciding the unit of res mgmt is IMHO not needed. The
vserver/container/namespace (tsk->nsproxy->some_ns) to which a task 
belongs automatically defines that unit of res mgmt.


-- 
Regards,
vatsa
