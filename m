Return-Path: <linux-kernel-owner+w=401wt.eu-S1755969AbYA1IYK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755969AbYA1IYK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 03:24:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751552AbYA1IX5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 03:23:57 -0500
Received: from e28smtp03.in.ibm.com ([59.145.155.3]:51790 "EHLO
	e28esmtp03.in.ibm.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751149AbYA1IX4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 03:23:56 -0500
From: Sripathi Kodi <sripathik@in.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC] Per-thread getrusage
Date: Mon, 28 Jan 2008 13:54:12 +0530
User-Agent: KMail/1.9.4
Cc: Vinay Sridhar <vinay@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org,
       libc-alpha@sourceware.org, drepper@redhat.com, wli@holomorphy.com,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Pavel Emelyanov <xemul@openvz.org>
References: <1200558425.5992.17.camel@srivinay.in.ibm.com> <20080127215242.b873c341.akpm@linux-foundation.org>
In-Reply-To: <20080127215242.b873c341.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801281354.12387.sripathik@in.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,

On Monday 28 January 2008 11:22, Andrew Morton wrote:
> 	On Thu, 17 Jan 2008 13:57:05 +0530 Vinay Sridhar 
<vinay@linux.vnet.ibm.com> wrote:
> > Hi All,
> >
> > Last year, there was discussion about per-thread getrusage by
> > adding RUSAGE_THREAD flag to getrusage(). Please refer to the
> > thread http://lkml.org/lkml/2007/4/4/308. Ulrich had suggested that
> > we should design a better user-space API. Specifically, we need a
> > pthread_getrusage interface in the thread library, which accepts
> > pthread_t, converts pthread_t into the corresponding tid and passes
> > it down to the syscall.
> >
> > There are two ways to implement this in the kernel:
> > 1) Introduce an additional parameter 'tid' to sys_getrusage() and
> > put code in glibc to handle getrusage() and pthread_getrusage()
> > calls correctly.
> > 2) Introduce a new system call to handle pthread_getrusage() and
> > leave sys_getrusage() untouched.
> >
> > We implemented the second idea above, simply because it avoids
> > touching any existing code. We have implemented a new syscall,
> > thread_getrusage() and we have exposed pthread_getrusage() API to
> > applications.
> >
> > Could you please share your thoughts on this? Does the approach
> > look alright? The code is hardly complete. It is just a prototype
> > that works on IA32 at the moment.
> >
> > ...
> >
> > +asmlinkage long sys_thread_getrusage(int tid, struct rusage __user
> > *ru);
>
> What happens if `tid' refers to a thread in a different pid
> namespace?

The code was only meant to be a base for discussions. It surely needs 
work. Our idea for the final version was to be able to read a thread's 
rusage from another thread strictly within the same process. The idea 
came from applications that need a cost enforcement mechanism. Having a 
mechanism for a thread to read it's own usage is essential. If there is 
a way to read other threads' rusage, it is even better.

Does Roland's patch (http://lkml.org/lkml/2008/1/18/589) look good to go 
in, provided Ulrich's comment (http://lkml.org/lkml/2008/1/19/15) is 
addressed?

Thanks,
Sripathi.
