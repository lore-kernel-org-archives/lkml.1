Return-Path: <linux-kernel-owner+w=401wt.eu-S1030699AbXCCRpz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030699AbXCCRpz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Mar 2007 12:45:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030695AbXCCRpz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Mar 2007 12:45:55 -0500
Received: from MAIL.13thfloor.at ([213.145.232.33]:47044 "EHLO
	MAIL.13thfloor.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030699AbXCCRpy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Mar 2007 12:45:54 -0500
Date: Sat, 3 Mar 2007 18:45:53 +0100
From: Herbert Poetzl <herbert@13thfloor.at>
To: Kirill Korotaev <dev@openvz.org>
Cc: Paul Jackson <pj@sgi.com>, ckrm-tech@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, xemul@sw.ru, ebiederm@xmission.com,
       winget@google.com, containers@lists.osdl.org, menage@google.com,
       akpm@linux-foundation.org
Subject: Re: [PATCH 0/2] resource control file system - aka containers on top of nsproxy!
Message-ID: <20070303174553.GB16051@MAIL.13thfloor.at>
Mail-Followup-To: Kirill Korotaev <dev@openvz.org>,
	Paul Jackson <pj@sgi.com>, ckrm-tech@lists.sourceforge.net,
	linux-kernel@vger.kernel.org, xemul@sw.ru, ebiederm@xmission.com,
	winget@google.com, containers@lists.osdl.org, menage@google.com,
	akpm@linux-foundation.org
References: <20070301133543.GK15509@in.ibm.com> <20070301113900.a7dace47.pj@sgi.com> <45E84682.6040500@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45E84682.6040500@openvz.org>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 02, 2007 at 06:45:06PM +0300, Kirill Korotaev wrote:
> Paul,
> 
> >>I suspect we can make cpusets also work
> >>on top of this very easily.
> > 
> > 
> > I'm skeptical, and kinda worried.
> > 
> > ... can you show me the code that does this?
> don't worry. we are not planning to commit any code breaking 
> cpusets.. I will be the first one against it 
> 
> > Namespaces are not the same thing as actual resources
> > (memory, cpu cycles, ...).  Namespaces are fluid mappings;
> > Resources are scarce commodities.
> hm... interesing comparison.

> as for me, I can't see much difference between virtualization
> namespaces nd resource namespaces.

I agree here, there is not much difference for the
following aspects:

 - resource accounting, limits and namespaces apply
   to a group of processes
 - they isolate those processes in some way from
   other groups of processes
 - they apply a virtual view and/or limitation to
   those processes

> Both have some impact on what the task in the namespace can do and
> what can't. The only difference is that virtualization namespaces
> usually also make one user to be invisible to another. 

IMHO invisibility only applies to the pid space :)

but as I said, the processes are isolated in some
way, might it be pids, networking, ipc, uts or 
filesystem, similar can be said for resource limits
and resource accounting, where you are only focusing
on a certain group of processes, applying an artifial
limit and ideally virtualizing all kernel interfaces
in such a way, that it looks like the artifical limit
is a real physical limitation

> That's the only difference imho.
> 
> Also if you take a look at IPC namespace you'll note that IPC
> can also limit IPC resources in question.

yes, but they do it in a way a normal Linux system
would do, so no 'new' limits there, unless you
disallow changing those limits from inside a space

best,
Herbert

> So it is kinda of virtualization + resource namespace.
> 
> > I'm wagering you'll break either the semantics, and/or the
> > performance, of cpusets doing this.
> I like Paul's containers patch. It looks good and pretty well.
> After some of the context issues are resolved it's fine.
> Maybe it is even the best way of doing things.
> 
> Thanks,
> Kirill
> 
> _______________________________________________
> Containers mailing list
> Containers@lists.osdl.org
> https://lists.osdl.org/mailman/listinfo/containers
