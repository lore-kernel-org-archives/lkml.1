Return-Path: <linux-kernel-owner+w=401wt.eu-S1030241AbXDCPlT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030241AbXDCPlT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2007 11:41:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030351AbXDCPlS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Apr 2007 11:41:18 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:60148 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030241AbXDCPlS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2007 11:41:18 -0400
Date: Tue, 3 Apr 2007 10:41:13 -0500
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: vatsa@in.ibm.com, "Serge E. Hallyn" <serue@us.ibm.com>, menage@google.com,
       akpm@osdl.org, pj@sgi.com, sekharan@us.ibm.com, dev@sw.ru, xemul@sw.ru,
       ckrm-tech@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       containers@lists.osdl.org, mbligh@google.com, winget@google.com,
       rohitseth@google.com, devel@openvz.org
Subject: Re: [ckrm-tech] [PATCH 7/7] containers (V7): Container interface to nsproxy subsystem
Message-ID: <20070403154113.GA1069@sergelap.austin.ibm.com>
References: <20070212081521.808338000@menage.corp.google.com> <20070212085105.170265000@menage.corp.google.com> <20070331024722.GA808@in.ibm.com> <20070402140938.GF17710@sergelap.austin.ibm.com> <20070402142727.GF2456@in.ibm.com> <m1slbiejt0.fsf@ebiederm.dsl.xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1slbiejt0.fsf@ebiederm.dsl.xmission.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Eric W. Biederman (ebiederm@xmission.com):
> Srivatsa Vaddagiri <vatsa@in.ibm.com> writes:
> 
> > On Mon, Apr 02, 2007 at 09:09:39AM -0500, Serge E. Hallyn wrote:
> >> Losing the directory isn't a big deal though.  And both unsharing a
> >> namespace (which causes a ns_container_clone) and mounting the hierarchy
> >> are done by userspace, so if for some installation it is a big deal,
> >> the init scripts on initrd can mount the hierarchy before doing any
> >> unsharing.
> >
> > Yes I thought of that after posting this (that initrd can mount the
> > hierarchies), so this should not be an issue in practice ..
> >
> >> Can you think of a reason why losing a few directories matters?
> >
> > If we loose directories, then we don't have a way to manage the
> > task-group it represents thr' the filesystem interface, so I consider
> > that bad. As we agree, this will not be an issue if initrd
> > mounts the ns hierarchy atleast at bootup.
> 
> I suspect that could be a problem if we have recursive containers.
> Even by having a separate mount namespace for isolation you really
> don't want to share the mount.  If you can see all of the processes
> you do want to be able to see and control everything.

Are you asking about what happens if initrd in a vserver asks to
	mount -t container -o ns,cpusets /containers
?

I suppose in that case it would make sense to allow a separate mount
instance with it's own superblock, with s_root pointing to the dentry
for the container the vserver is in?

> I guess I want to ask before this gets to far.  Why are all of the
> namespaces lumped into one group?  I would think it would make much
> more sense to treat each namespace individually (at least for the
> user space interface).
> 
> Eric
