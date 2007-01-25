Return-Path: <linux-kernel-owner+w=401wt.eu-S965405AbXAYPUg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965405AbXAYPUg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jan 2007 10:20:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965459AbXAYPUg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jan 2007 10:20:36 -0500
Received: from mtagate4.de.ibm.com ([195.212.29.153]:52497 "EHLO
	mtagate4.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965405AbXAYPUg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jan 2007 10:20:36 -0500
Message-ID: <45B8CAB7.9050402@fr.ibm.com>
Date: Thu, 25 Jan 2007 16:20:23 +0100
From: Cedric Le Goater <clg@fr.ibm.com>
User-Agent: Thunderbird 1.5.0.9 (X11/20061219)
MIME-Version: 1.0
To: "Serge E. Hallyn" <serue@us.ibm.com>
CC: linux-kernel@vger.kernel.org, "Eric W. Biederman" <ebiederm@xmission.com>,
       Oleg Nesterov <oleg@tv-sign.ru>,
       Daniel Hokka Zakrisson <daniel@hozac.com>, herbert@13thfloor.at,
       akpm@osdl.org, trond.myklebust@fys.uio.no,
       Linux Containers <containers@lists.osdl.org>
Subject: Re: [PATCH] namespaces: fix race at task exit
References: <20070125150542.GA27472@sergelap.austin.ibm.com>
In-Reply-To: <20070125150542.GA27472@sergelap.austin.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Serge E. Hallyn wrote:
> In do_exit(), the exit_task_namespaces() was placed after
> exit_notify() because exit_notify ends up using the pid
> namespace both to access the reaper, and for detaching the
> pid.  However, this placement allows an nfs server to reap
> the task before exit_task_namespaces() completes.
> 
> This patch moves the exit_task_namespaces() into release_task,
> below release_thread() which puts the pids(), and just above
> the call_rcu(delayed_put_task_struct).  I believe this should
> solve both problems.
> 
> Signed-off-by: Serge E. Hallyn <serue@us.ibm.com>

I've run some tests on x86 and x86_64: mounted a NFS share after 
having unshare(CLONE_NEWNS) and I didn't reproduce the bug Daniel 
had found. 

it looks safe.

C.
 

