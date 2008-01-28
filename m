Return-Path: <linux-kernel-owner+w=401wt.eu-S1755924AbYA1Jqs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755924AbYA1Jqs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 04:46:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755142AbYA1Jqf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 04:46:35 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:46433 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754790AbYA1Jqd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 04:46:33 -0500
Date: Mon, 28 Jan 2008 01:45:34 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Pavel Emelyanov <xemul@openvz.org>
Cc: Vinay Sridhar <vinay@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org,
       libc-alpha@sourceware.org, drepper@redhat.com, wli@holomorphy.com,
       sripathik@in.ibm.com, "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [RFC] Per-thread getrusage
Message-Id: <20080128014534.17630ddd.akpm@linux-foundation.org>
In-Reply-To: <479DA289.7090403@openvz.org>
References: <1200558425.5992.17.camel@srivinay.in.ibm.com>
	<20080127215242.b873c341.akpm@linux-foundation.org>
	<479D88C7.5030101@openvz.org>
	<20080128011010.d162d336.akpm@linux-foundation.org>
	<479DA289.7090403@openvz.org>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 28 Jan 2008 12:38:17 +0300 Pavel Emelyanov <xemul@openvz.org> wrote:

> > If the code was using find_task_by_vpid() then OK (I guess).  But it is
> 
> Yup, find_task_by_vpid() will find the proper (i.e. in your namespace) task.
> 
> > looking the tids up in the init_pid_ns.  Which I assume means that if it's
> > in a new namespace and is looking up a sibling thread it will simply fail?
> 
> If it looks in the init_pid_ns, then it can either fail or obtain a task 
> from different namespace. The find_task_by_pid_ns() was intended to be used
> in proc mainly, to get tasks from the namespace pointed by the super-block
> being explored.
> 
> Please excuse my lamentable ignorance, but which code does such things with
> init_pid_ns? I followed the 'per-thread rusage' thread and didn't find any.

From: Vinay Sridhar <vinay@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org, libc-alpha@sourceware.org
Cc: drepper@redhat.com, wli@holomorphy.com, akpm@linux-foundation.org, sripathik@in.ibm.com
Subject: [RFC] Per-thread getrusage
...
+asmlinkage long sys_thread_getrusage(int tid, struct rusage __user *ru)
+{
+	struct task_struct *tsk;
+	tsk = find_task_by_pid(tid);
+	return getrusage(tsk, RUSAGE_THREAD, ru);
+}


