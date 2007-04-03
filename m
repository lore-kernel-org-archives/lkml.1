Return-Path: <linux-kernel-owner+w=401wt.eu-S1030201AbXDCOKe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030201AbXDCOKe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2007 10:10:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030238AbXDCOKe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Apr 2007 10:10:34 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:33976 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030201AbXDCOKd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2007 10:10:33 -0400
Date: Tue, 3 Apr 2007 19:46:39 +0530
From: Srivatsa Vaddagiri <vatsa@in.ibm.com>
To: ebiederm@xmission.com (Eric W. Biederman)
Cc: sekharan@us.ibm.com, ckrm-tech@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, xemul@sw.ru, dev@sw.ru,
       rohitseth@google.com, pj@sgi.com, mbligh@google.com, winget@google.com,
       containers@lists.osdl.org, "Serge E. Hallyn" <serue@us.ibm.com>,
       menage@google.com, devel@openvz.org
Subject: Re: [ckrm-tech] [PATCH 7/7] containers (V7): Container interface to nsproxy subsystem
Message-ID: <20070403141639.GA1363@in.ibm.com>
Reply-To: vatsa@in.ibm.com
References: <20070212081521.808338000@menage.corp.google.com> <20070212085105.170265000@menage.corp.google.com> <20070331024722.GA808@in.ibm.com> <20070402140938.GF17710@sergelap.austin.ibm.com> <20070402142727.GF2456@in.ibm.com> <m1slbiejt0.fsf@ebiederm.dsl.xmission.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1slbiejt0.fsf@ebiederm.dsl.xmission.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 02, 2007 at 12:02:35PM -0600, Eric W. Biederman wrote:
> > If we loose directories, then we don't have a way to manage the
> > task-group it represents thr' the filesystem interface, so I consider
> > that bad. As we agree, this will not be an issue if initrd
> > mounts the ns hierarchy atleast at bootup.
> 
> I suspect that could be a problem if we have recursive containers.
> Even by having a separate mount namespace for isolation you really
> don't want to share the mount.  If you can see all of the processes
> you do want to be able to see and control everything.

Won't there be some master (VFS) namespace which can see everything? The
idea would be then to list all containers in that namespace. I am
visualizing that a master namespace listing all containers like that 
will be like a management console, from which you can monitor/control
resource consumption of all containers.

I agree the individual containers themselves should not be able to
mount and view other containers in this container/resource-control
filesystem. I presume existing VFS namespace mechanism would enforce
that restriction.

> I guess I want to ask before this gets to far.  Why are all of the
> namespaces lumped into one group?  

I don't think they are. From Serge's patches, a new group (or a directory in
container filesystem) is created everytime a new nsproxy is created
(copy_namespaces/sys_unshare).

> I would think it would make much
> more sense to treat each namespace individually (at least for the
> user space interface).

-- 
Regards,
vatsa
