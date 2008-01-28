Return-Path: <linux-kernel-owner+w=401wt.eu-S1754175AbYA1V6m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754175AbYA1V6m (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 16:58:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752347AbYA1V6e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 16:58:34 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:33386 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752141AbYA1V6d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 16:58:33 -0500
Date: Mon, 28 Jan 2008 13:57:05 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: ebiederm@xmission.com (Eric W. Biederman)
Cc: xemul@openvz.org, vinay@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
       libc-alpha@sourceware.org, drepper@redhat.com, wli@holomorphy.com,
       sripathik@in.ibm.com
Subject: Re: [RFC] Per-thread getrusage
Message-Id: <20080128135705.29e85878.akpm@linux-foundation.org>
In-Reply-To: <m1ve5dheax.fsf@ebiederm.dsl.xmission.com>
References: <1200558425.5992.17.camel@srivinay.in.ibm.com>
	<20080127215242.b873c341.akpm@linux-foundation.org>
	<479D88C7.5030101@openvz.org>
	<20080128011010.d162d336.akpm@linux-foundation.org>
	<479DA289.7090403@openvz.org>
	<20080128014534.17630ddd.akpm@linux-foundation.org>
	<479DA711.3080301@openvz.org>
	<m1ve5dheax.fsf@ebiederm.dsl.xmission.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 28 Jan 2008 13:43:02 -0700
ebiederm@xmission.com (Eric W. Biederman) wrote:

> Pavel Emelyanov <xemul@openvz.org> writes:
> >> ...
> >> +asmlinkage long sys_thread_getrusage(int tid, struct rusage __user *ru)
> >> +{
> >> +	struct task_struct *tsk;
> >> +	tsk = find_task_by_pid(tid);
> >> +	return getrusage(tsk, RUSAGE_THREAD, ru);
> >> +}
> >
> > Well, the find_task_by_pid() is really wrong here.
> 
> And find_task_by_pid should probably just be removed.

That's what I was thinking.

> No need to provide function with the gun firmly pointed at our feet....

It still has a disturbingly large number of callers.
