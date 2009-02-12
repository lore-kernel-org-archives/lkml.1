Return-Path: <linux-kernel-owner+w=401wt.eu-S1761225AbZBLWVa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761225AbZBLWVa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Feb 2009 17:21:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758471AbZBLWVV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Feb 2009 17:21:21 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39484 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753455AbZBLWVU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Feb 2009 17:21:20 -0500
Date: Thu, 12 Feb 2009 14:20:21 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: ebiederm@xmission.com (Eric W. Biederman)
Cc: fweisbec@gmail.com, mingo@elte.hu, linux-kernel@vger.kernel.org,
       oleg@redhat.com, travis@sgi.com, a.p.zijlstra@chello.nl,
       mm-commits@vger.kernel.org, rusty@rustcorp.com.au
Subject: Re: +
 work_on_cpu-rewrite-it-to-create-a-kernel-thread-on-demand.patch  added to
 -mm tree
Message-Id: <20090212142021.3978072c.akpm@linux-foundation.org>
In-Reply-To: <m1eiy3z4ty.fsf@fess.ebiederm.org>
References: <200902031058.n13AwOoK016719@imap1.linux-foundation.org>
	<20090203121147.GB19979@elte.hu>
	<c62985530902030858y28906b2dh511c5868afabfd17@mail.gmail.com>
	<20090203112529.26e6bf76.akpm@linux-foundation.org>
	<m18wobcrw3.fsf@fess.ebiederm.org>
	<20090212124835.2fc41620.akpm@linux-foundation.org>
	<m1eiy3z4ty.fsf@fess.ebiederm.org>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 12 Feb 2009 14:08:09 -0800
ebiederm@xmission.com (Eric W. Biederman) wrote:

> Andrew Morton <akpm@linux-foundation.org> writes:
> 
> > The problem with set_cpus_allowed() is that some other
> > suitably-privileged userspace process can come in from the side and
> > modify your cpus_allowed at any time.
> 
> According to the comments the only reason we care is so that
> we get the appropriate NUMA affinity by default.  I don't
> think it would be fatal if userspace messed around and we
> had a wrong value.

Right.  In this particular case, if you are fantastically unlucky and
hit the race window, all that will happen is that one particular device
will run a bit more slowly.

But at other codesites, the effects of a racing cpus_allowed rewrite
can be fatal.

> Does work_on_cpu prevent that?

Yup.

I think.

Nope.

I don't think there's actually anything which would prevent a
sufficiently stupid/malicious/unlucky administrator from moving the
work_on_cpu thread onto the wrong CPU at the wrong time.  hrm.

Another reason to use smp_call_function_single().
