Return-Path: <linux-kernel-owner+w=401wt.eu-S1760695AbYA3NPg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760695AbYA3NPg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 08:15:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758437AbYA3NPX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 08:15:23 -0500
Received: from ms-smtp-03.nyroc.rr.com ([24.24.2.57]:50191 "EHLO
	ms-smtp-03.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758389AbYA3NPW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 08:15:22 -0500
Date: Wed, 30 Jan 2008 08:15:06 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Christoph Hellwig <hch@infradead.org>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Gregory Haskins <ghaskins@novell.com>,
       Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
       Thomas Gleixner <tglx@linutronix.de>, Tim Bird <tim.bird@am.sony.com>,
       Sam Ravnborg <sam@ravnborg.org>, "Frank Ch. Eigler" <fche@redhat.com>,
       Jan Kiszka <jan.kiszka@siemens.com>, John Stultz <johnstul@us.ibm.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Steven Rostedt <srostedt@redhat.com>
Subject: Re: [PATCH 05/22 -v7] add notrace annotations to vsyscall.
In-Reply-To: <1201682978.28547.165.camel@lappy>
Message-ID: <Pine.LNX.4.58.0801300809280.29020@gandalf.stny.rr.com>
References: <20080130031521.258552785@goodmis.org>  <20080130031840.829420571@goodmis.org>
 <1201682978.28547.165.camel@lappy>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 30 Jan 2008, Peter Zijlstra wrote:

>
> On Tue, 2008-01-29 at 22:15 -0500, Steven Rostedt wrote:
> > plain text document attachment
> > (mcount-add-x86-vdso-notrace-annotations.patch)
> > Add the notrace annotations to some of the vsyscall functions.
>
> Would the VDSO stuff crash a kernel without these annotations and
> CONFIG_MCOUNT=y ?
>
> If so, I think it would be best of you placed these annotations before
> adding the core code, this would improve bisectability.

The thing is that MCOUNT needs something to select it, it's not a visible
option:

config MCOUNT
        bool
        select FRAME_POINTER

Nothing selects MCOUNT before the annotations are in, which really makes
the mcount code a nop until the tracer code comes in. A bisect (as long as
make oldconfig is done) should not be harmed by this patch ordering.
Note: the mcount patch introduces the annotation of notrace, which means
switching the order as it is will break it.

-- Steve

