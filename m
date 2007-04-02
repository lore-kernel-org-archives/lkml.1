Return-Path: <linux-kernel-owner+w=401wt.eu-S965554AbXDBSFm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965554AbXDBSFm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2007 14:05:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965624AbXDBSFm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Apr 2007 14:05:42 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:44945 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965554AbXDBSFl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2007 14:05:41 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: vatsa@in.ibm.com
Cc: "Serge E. Hallyn" <serue@us.ibm.com>, menage@google.com, akpm@osdl.org,
       pj@sgi.com, sekharan@us.ibm.com, dev@sw.ru, xemul@sw.ru,
       ebiederm@xmission.com, ckrm-tech@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, containers@lists.osdl.org,
       mbligh@google.com, winget@google.com, rohitseth@google.com,
       devel@openvz.org
Subject: Re: [ckrm-tech] [PATCH 7/7] containers (V7): Container interface to nsproxy subsystem
References: <20070212081521.808338000@menage.corp.google.com>
	<20070212085105.170265000@menage.corp.google.com>
	<20070331024722.GA808@in.ibm.com>
	<20070402140938.GF17710@sergelap.austin.ibm.com>
	<20070402142727.GF2456@in.ibm.com>
Date: Mon, 02 Apr 2007 12:02:35 -0600
In-Reply-To: <20070402142727.GF2456@in.ibm.com> (Srivatsa Vaddagiri's message
	of "Mon, 2 Apr 2007 19:57:27 +0530")
Message-ID: <m1slbiejt0.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Srivatsa Vaddagiri <vatsa@in.ibm.com> writes:

> On Mon, Apr 02, 2007 at 09:09:39AM -0500, Serge E. Hallyn wrote:
>> Losing the directory isn't a big deal though.  And both unsharing a
>> namespace (which causes a ns_container_clone) and mounting the hierarchy
>> are done by userspace, so if for some installation it is a big deal,
>> the init scripts on initrd can mount the hierarchy before doing any
>> unsharing.
>
> Yes I thought of that after posting this (that initrd can mount the
> hierarchies), so this should not be an issue in practice ..
>
>> Can you think of a reason why losing a few directories matters?
>
> If we loose directories, then we don't have a way to manage the
> task-group it represents thr' the filesystem interface, so I consider
> that bad. As we agree, this will not be an issue if initrd
> mounts the ns hierarchy atleast at bootup.

I suspect that could be a problem if we have recursive containers.
Even by having a separate mount namespace for isolation you really
don't want to share the mount.  If you can see all of the processes
you do want to be able to see and control everything.

I guess I want to ask before this gets to far.  Why are all of the
namespaces lumped into one group?  I would think it would make much
more sense to treat each namespace individually (at least for the
user space interface).

Eric
