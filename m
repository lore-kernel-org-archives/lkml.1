Return-Path: <linux-kernel-owner+w=401wt.eu-S1754679AbZAZX3S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754679AbZAZX3S (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2009 18:29:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752210AbZAZX3F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Jan 2009 18:29:05 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57717 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752483AbZAZX3F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2009 18:29:05 -0500
Date: Mon, 26 Jan 2009 15:28:32 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "Serge E. Hallyn" <serue@us.ibm.com>
Cc: linux-kernel@vger.kernel.org, containers@lists.osdl.org
Subject: Re: [Patch 0/3] posix mqueue namespace (v14)
Message-Id: <20090126152832.1918efed.akpm@linux-foundation.org>
In-Reply-To: <20090117020248.GA8615@us.ibm.com>
References: <20090117020248.GA8615@us.ibm.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 16 Jan 2009 20:02:48 -0600
"Serge E. Hallyn" <serue@us.ibm.com> wrote:

> IPC namespaces are completely disjoint id->object mappings.
> A task can pass CLONE_NEWIPC to unshare and clone to get
> a new, empty, IPC namespace.  Until now this has supported
> SYSV IPC.
> 
> Most Posix IPC is done in userspace.  The posix mqueue
> support, however, is implemented on top of the mqueue fs.
> 
> This patchset implements multiple mqueue fs instances,
> one per IPC namespace to be precise.
> 
> To create a new ipc namespace with posix mq support, you
> should now:
> 
> 	unshare(CLONE_NEWIPC|CLONE_NEWNS);
> 	umount /dev/mqueue
> 	mount -t mqueue mqueue /dev/mqueue
> 
> It's perfectly valid to do vfs operations on files
> in another ipc_namespace's /dev/mqueue, but any use
> of mq_open(3) and friends will act in your own ipc_ns.
> After the ipc namespace has exited, you can still
> unlink but no longer create files in that fs (since
> accounting is carried.
> 
> Changelog:
> 	v14: (Jan 16 2009) port to linux-next
> 	v13: (Dec 28 2009)
> 	   1. addressed comments by Dave and Suka
> 	   2. ported Cedric's patch to make posix mq sysctls
> 	      per-namespace
> 
> When convenient, it would be great to see this tested
> in -mm.

hm. Who is going to test it?
