Return-Path: <linux-kernel-owner+w=401wt.eu-S1755898AbZBVROS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755898AbZBVROS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Feb 2009 12:14:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752695AbZBVROG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Feb 2009 12:14:06 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:40425 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752407AbZBVROD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Feb 2009 12:14:03 -0500
Date: Sun, 22 Feb 2009 18:13:44 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "Frank Ch. Eigler" <fche@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Avi Kivity <avi@redhat.com>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
       linux-kbuild@vger.kernel.org
Subject: Re: [PATCH] tracing/markers: make markers select tracepoints
Message-ID: <20090222171344.GC6570@elte.hu>
References: <499edf47.1818d00a.060b.2b8d@mx.google.com> <499EE162.4050008@oracle.com> <20090220172241.GF24538@elte.hu> <20090220173107.GH5732@nowhere> <20090220174811.GL24538@elte.hu> <y0mtz6nqwe9.fsf@ton.toronto.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <y0mtz6nqwe9.fsf@ton.toronto.redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Frank Ch. Eigler <fche@redhat.com> wrote:

> Ingo Molnar <mingo@elte.hu> writes:
> 
> > [...]
> > there's i think the KVM usecase where markers are used 
> > essentially a printk()-alike flexible tracing facility.
> >
> > [...]
> > ./vmx.c:	KVMTRACE_3D(MSR_READ, vcpu, ecx, (u32)data, (u32)(data >> 32),
> > ./vmx.c:	KVMTRACE_3D(MSR_WRITE, vcpu, ecx, (u32)data, (u32)(data >> 32),
> > ./vmx.c:	KVMTRACE_0D(PEND_INTR, vcpu, handler);
> >
> > I think this could easily be converted to a wrapper around 
> > ftrace_printk() plus a "kvmtrace" ftrace plugin [...]
> 
> It would be even easier converted to the markers API directly,
> without the KVMTRACE* macro intermediary:
> 
> before:
>         KVMTRACE_3D(MSR_READ, &svm->vcpu, ecx, (u32)data,
>                     (u32)(data >> 32), handler);
> after:
> 	trace_mark(kvmtrace, "MSR_READ: %p, %08lx, %016Lx\n",
>                              &svm->vcpu, ecx, data);
> 
> All this already "just works".

except that we are removing markers.

	Ingo
