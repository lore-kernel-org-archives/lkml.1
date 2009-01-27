Return-Path: <linux-kernel-owner+w=401wt.eu-S1755262AbZA0VVG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755262AbZA0VVG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2009 16:21:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752676AbZA0VUy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Jan 2009 16:20:54 -0500
Received: from e32.co.us.ibm.com ([32.97.110.150]:33927 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752648AbZA0VUy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2009 16:20:54 -0500
Date: Tue, 27 Jan 2009 15:20:26 -0600
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, containers@lists.osdl.org
Subject: Re: [Patch 0/3] posix mqueue namespace (v14)
Message-ID: <20090127212025.GA11978@us.ibm.com>
References: <20090117020248.GA8615@us.ibm.com> <20090126152832.1918efed.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090126152832.1918efed.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Andrew Morton (akpm@linux-foundation.org):
> On Fri, 16 Jan 2009 20:02:48 -0600
> "Serge E. Hallyn" <serue@us.ibm.com> wrote:
> 
> > IPC namespaces are completely disjoint id->object mappings.
> > A task can pass CLONE_NEWIPC to unshare and clone to get
> > a new, empty, IPC namespace.  Until now this has supported
> > SYSV IPC.
> > 
> > Most Posix IPC is done in userspace.  The posix mqueue
> > support, however, is implemented on top of the mqueue fs.
> > 
> > This patchset implements multiple mqueue fs instances,
> > one per IPC namespace to be precise.
> > 
> > To create a new ipc namespace with posix mq support, you
> > should now:
> > 
> > 	unshare(CLONE_NEWIPC|CLONE_NEWNS);
> > 	umount /dev/mqueue
> > 	mount -t mqueue mqueue /dev/mqueue
> > 
> > It's perfectly valid to do vfs operations on files
> > in another ipc_namespace's /dev/mqueue, but any use
> > of mq_open(3) and friends will act in your own ipc_ns.
> > After the ipc namespace has exited, you can still
> > unlink but no longer create files in that fs (since
> > accounting is carried.
> > 
> > Changelog:
> > 	v14: (Jan 16 2009) port to linux-next
> > 	v13: (Dec 28 2009)
> > 	   1. addressed comments by Dave and Suka
> > 	   2. ported Cedric's patch to make posix mq sysctls
> > 	      per-namespace
> > 
> > When convenient, it would be great to see this tested
> > in -mm.
> 
> hm. Who is going to test it?

Everyone using posix mq with an -mm kernel :)

There are ltp testcases which I hope can be pushed once these
patches appear headed upstream.

thanks,
-serge
