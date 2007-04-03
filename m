Return-Path: <linux-kernel-owner+w=401wt.eu-S1945894AbXDCUQg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1945894AbXDCUQg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2007 16:16:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422676AbXDCUQg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Apr 2007 16:16:36 -0400
Received: from smtp.osdl.org ([65.172.181.24]:41651 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422688AbXDCUQf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2007 16:16:35 -0400
Date: Tue, 3 Apr 2007 13:16:23 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Ulrich Drepper <drepper@redhat.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: getting processor numbers
Message-Id: <20070403131623.c6831607.akpm@linux-foundation.org>
In-Reply-To: <461286D6.2040407@redhat.com>
References: <461286D6.2040407@redhat.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 03 Apr 2007 09:54:46 -0700
Ulrich Drepper <drepper@redhat.com> wrote:

> More and more code depends on knowing the number of processors in the
> system to efficiently scale the code.  E.g., in OpenMP it is used by
> default to determine how many threads to create.  Creating more threads
> than there are processors/cores doesn't make sense.

but...  It would be a mistake for an application to assume that it is
allowed to _use_ all the present CPUs.  People can and do run applications
within cpusets, and under sched_setaffinity().

So I'd have thought that in general an application should be querying its
present affinity mask - something like sched_getaffinity()?  That fixes the
CPU hotplug issues too, of course.

But we discussed this all a couple years back and it was decided that
sched_getaffinity() was unsuitable.  I remember at the time not really
understanding why?

