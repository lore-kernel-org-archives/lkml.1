Return-Path: <linux-kernel-owner+w=401wt.eu-S1752475AbZIXQpJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752475AbZIXQpJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Sep 2009 12:45:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751467AbZIXQpJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Sep 2009 12:45:09 -0400
Received: from taverner.CS.Berkeley.EDU ([128.32.168.222]:42166 "EHLO
	taverner.cs.berkeley.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751282AbZIXQpI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Sep 2009 12:45:08 -0400
X-Greylist: delayed 435 seconds by postgrey-1.27 at vger.kernel.org; Thu, 24 Sep 2009 12:45:08 EDT
To: linux-kernel@vger.kernel.org
Path: not-for-mail
From: daw@cs.berkeley.edu (David Wagner)
Newsgroups: isaac.lists.linux-kernel
Subject: Re: [RFC] Privilege dropping security module
Date: Thu, 24 Sep 2009 16:37:57 +0000 (UTC)
Organization: University of California, Berkeley
Message-ID: <h9g795$9om$1@taverner.cs.berkeley.edu>
References: <20090923005644.GA28244@c.hsd1.tn.comcast.net> <4ABA892A.9090804@schaufler-ca.com> <20090923223110.GA1449@c.hsd1.tn.comcast.net>
Reply-To: daw-news@cs.berkeley.edu (David Wagner)
NNTP-Posting-Host: taverner.cs.berkeley.edu
X-Trace: taverner.cs.berkeley.edu 1253810277 10006 128.32.168.222 (24 Sep 2009 16:37:57 GMT)
X-Complaints-To: news@taverner.cs.berkeley.edu
NNTP-Posting-Date: Thu, 24 Sep 2009 16:37:57 +0000 (UTC)
X-Newsreader: trn 4.0-test76 (Apr 2, 2001)
Originator: daw@taverner.cs.berkeley.edu (David Wagner)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andy Spencer  wrote:
>Being able to use dpriv as a non root user is pretty strait forward. For
>example, a user of a multi-user system may want to try some untrusted
>code without risking access to the rest of the system:
>
>  $ cd ~/my_project
>  $ echo rxRX   /                > /sys/kernel/security/dpriv/stage
>  $ echo X      $HOME            > /sys/kernel/security/dpriv/stage
>  $ echo rwxRWX $HOME/my_project > /sys/kernel/security/dpriv/stage
>  $ echo commit                  > /sys/kernel/security/dpriv/control
>  $ patch < untrusted.patch
>  $ make && ./src/some_exe

If I understand correctly, this isn't sufficient to run untrusted code,
because it only restricts access to the filesystem.  You gotta restrict
access to the network, interaction with other processes, and so on.
(For instance, does dpriv let the untrusted process take over another of
your processes using ptrace?)

There's a tremendous amount of research literature on building secure
sandboxes.  You should study it, if you're not familiar with it.

I suspect making all permissions recursive is going to lead to overly
permissive policies.  Suppose I want to allow read access to everything
under /lib and /usr/lib, read-execute access to everything under /bin
and /usr/bin, and read-write access to everything under /tmp.  (But I
do not want to allow any access to any other directories.)  How do I
do it?
