Return-Path: <linux-kernel-owner+w=401wt.eu-S1757336AbYEAF4N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757336AbYEAF4N (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2008 01:56:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753535AbYEAFzs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 May 2008 01:55:48 -0400
Received: from ms1.nttdata.co.jp ([163.135.193.232]:43351 "EHLO
	ms1.nttdata.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752733AbYEAFzq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2008 01:55:46 -0400
Message-Id: <20080501055405.024390000@nttdata.co.jp>
User-Agent: quilt/0.45-1
Date: Thu, 01 May 2008 14:54:05 +0900
From: Toshiharu Harada <haradats@nttdata.co.jp>
To: akpm@linux-foundation.org, chrisw@sous-sol.org, viro@ZenIV.linux.org.uk
Cc: linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [TOMOYO #8 (2.6.25-mm1) 0/7] TOMOYO Linux
X-OriginalArrivalTime: 01 May 2008 05:55:43.0073 (UTC) FILETIME=[FDE8FD10:01C8AB4F]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This submission of the TOMOYO Linux security module is based
against 2.6.25-mm1.

TOMOYO Linux is a pathname-based MAC extension (LSM module)
for the Linux kernel. The patch files consist of two parts:

1. New hooks for LSM
2. TOMOYO Linux itself

The first part is needed because the vfsmount parameter which is
required for TOMOYO Linux is not passed to (current version of) LSM.
For that reason, AppArmor and TOMOYO Linux have been posting
proposals to pass it via VFS code several times, but neither has been
merged. In this posting, we have chosen a new, straightforward
approach to add new hooks in the namespace code (that was suggested by
Stephen Smalley of NSA. We thank him). What is good with this approach
is it causes fewer impacts on VFS and filesystem code and no impacts
on in-tree modules (SELinux and Smack).

The heart of TOMOYO Linux patch is to store "process invocation
history" for each process. Under TOMOYO Linux every process knows
how it was executed, and TOMOYO Linux kernel automatically
manage selecting processes that has the same "process invocation history"
as same domains. Furthermore, administrators can gather
access requests information for each domain on the fly.
Our Ubuntu based LiveCD is the most convenient way to
experience the above explanation.

http://tomoyo.sourceforge.jp/wiki-e/?TomoyoLive

Though we have a variety of MAC functionalities with the latest
(local) version of TOMOYO Linux, we carefully extracted the MAC for
file access, the most fundamental functionality to reduce
the patches and reviewers' time.

There have been arguments on pathname-based MACs.
TOMOYO Linux patch mainly resides in the namespace (so it's called
pathname-based) while SELinux and current LSM reside in the inode
space. From information flow control point of view, it is obvious
that label based MAC is the way to go. So let me emphasize that
I'm not claiming TOMOYO Linux as a better MAC than SELinux.

Then you might ask why we are developing TOMOYO Linux.
Because,

- TOMOYO Linux gives human-friendly "context" information to
  the processes. "Context" example can be viewed at
    http://tomoyo.sourceforge.jp/cgi-bin/lxr/source/ubuntu-7.10-ccs-1.5.3/domain_policy.conf?v=policy-sample
- There are cases where pathname-based MAC is needed.
- At the very least, TOMOYO Linux is one of the most
  useful tool to learn the Linux operating system.

Some URLs.
- http://elinux.org/TomoyoLinux
- http://lwn.net/Articles/263179/ (our security goal)
- http://tomoyo.sourceforge.jp/wiki-e/?WhatIs#comparison
  (my version of Linux MAC comparison chart)
- http://lwn.net/Articles/277833/ (Jonathan's great article on
  history of pathname-based MAC)

That's it and we are now ready to hear from the community and
improve the code. Thanks in advance.  :) 

Toshiharu Harada
haradats@nttdata.co.jp
NTT DATA CORPORATION

--

