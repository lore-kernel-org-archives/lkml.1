Return-Path: <linux-kernel-owner+w=401wt.eu-S1752228AbYLSRUS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752228AbYLSRUS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2008 12:20:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753410AbYLSRT4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Dec 2008 12:19:56 -0500
Received: from e32.co.us.ibm.com ([32.97.110.150]:58116 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753269AbYLSRTy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2008 12:19:54 -0500
Date: Fri, 19 Dec 2008 11:19:30 -0600
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: Linux Containers <containers@lists.osdl.org>,
       Dave Hansen <haveblue@us.ibm.com>,
       Sukadev Bhattiprolu <sukadev@us.ibm.com>
Subject: [RFC patch 0/3] posix mqueue namespace (v13)
Message-ID: <20081219171930.GA17335@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

IPC namespaces are completely disjoint id->object mappings.
A task can pass CLONE_NEWIPC to unshare and clone to get
a new, empty, IPC namespace.  Until now this has supported
SYSV IPC.

Most Posix IPC is done in userspace.  The posix mqueue
support, however, is implemented on top of the mqueue fs.

This patchset implements multiple mqueue fs instances,
one per IPC namespace to be precise.

To create a new ipc namespace with posix mq support, you
should now:

	unshare(CLONE_NEWIPC|CLONE_NEWNS);
	umount /dev/mqueue
	mount -t mqueue mqueue /dev/mqueue

It's perfectly valid to do vfs operations on files
in another ipc_namespace's /dev/mqueue, but any use
of mq_open(3) and friends will act in your own ipc_ns.
After the ipc namespace has exited, you can still
unlink but no longer create files in that fs (since
accounting is carried.

Changelog:
	v13:
	   1. addressed comments by Dave and Suka
	   2. ported Cedric's patch to make posix mq sysctls
	      per-namespace

When convenient, it would be great to see this tested
in -mm.

thanks,
-serge
