Return-Path: <linux-kernel-owner+w=401wt.eu-S965621AbXCLNyt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965621AbXCLNyt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2007 09:54:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965870AbXCLNyt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Mar 2007 09:54:49 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:41728 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965868AbXCLNys (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2007 09:54:48 -0400
Date: Mon, 12 Mar 2007 19:31:48 +0530
From: Srivatsa Vaddagiri <vatsa@in.ibm.com>
To: Paul Jackson <pj@sgi.com>
Cc: Herbert Poetzl <herbert@13thfloor.at>, ebiederm@xmission.com,
       menage@google.com, ckrm-tech@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, xemul@sw.ru, winget@google.com,
       containers@lists.osdl.org, akpm@linux-foundation.org
Subject: Re: [ckrm-tech] [PATCH 0/2] resource control file system - aka containers on top of nsproxy!
Message-ID: <20070312140148.GA10450@in.ibm.com>
Reply-To: vatsa@in.ibm.com
References: <6599ad830703071518y715ecdb2y33752a6e25b5ecdb@mail.gmail.com> <45EF5A62.8000103@vilain.net> <6599ad830703071642n69bbd801n6114fa6f9e60a168@mail.gmail.com> <45EF5E71.7090101@vilain.net> <6599ad830703071658q60466dd8hd18a1eab9bc17535@mail.gmail.com> <m1d53ka5b9.fsf@ebiederm.dsl.xmission.com> <20070309005357.GC4506@MAIL.13thfloor.at> <20070309181908.GC21661@in.ibm.com> <20070309215218.GA17592@MAIL.13thfloor.at> <20070309140603.b2b162c6.pj@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070309140603.b2b162c6.pj@sgi.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 09, 2007 at 02:06:03PM -0800, Paul Jackson wrote:
> >  if you create a 'resource container' to limit the
> >  usage of a set of resources for the processes
> >  belonging to this container, it would be kind of
> >  defeating the purpose, if you'd allow the processes
> >  to manipulate their limits, no?
> 
> Wrong - this is not the only way.
> 
> For instance in cpusets, -any- task in the system, regardless of what
> cpuset it is currently assigned to, might be able to manipulate -any-
> cpuset in the system.
> 
> Yes -- some sufficient mechanism is required to keep tasks from
> escalating their resources or capabilities beyond an allowed point.
> 
> But that mechanism might not be strictly based on position in some
> hierarchy.
> 
> In the case of cpusets, it is based on the permissions on files in
> the cpuset file system (normally mounted at /dev/cpuset), versus
> the current priviledges and capabilities of the task.
> 
> A root priviledged task in the smallest leaf node cpuset can manipulate
> every cpuset in the system.  This is an ordinary and common occurrence.

This assumes that you can see the global vfs namespace right?

What if you are inside a container/vserver which restricts your vfs
namespace? i.e /dev/cpusets seen from one container is not same as what
is seen from another container ..Is that a unrealistic scenario? IMHO
not so. This in-fact lets vservers and containers to work with each
other. So:

	/dev/cpuset
		|- C1	<- Container A bound to this
		|  |- C11
		|  |- C12
		|
	        |- C2	<- Container B bound to this
		   |- C21
		   |- C22


C1 and C2 are two exclusive cpusets and containers/vservers A and B are bound 
to C1/C2 respectively.

>From inside container/vserver A, if you were to look at /dev/cpuset, it will
-appear- as if you are in the top cpuset (with just C11 and C12 child
cpusets). It cannot modify C2 at all (since it has no visibility).

Similarly if you were to look at /dev/cpuset from inside B, it will list only 
C21/C22 with tasks in container B not being able to see C1 at all.

:)


-- 
Regards,
vatsa
