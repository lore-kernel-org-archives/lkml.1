Return-Path: <linux-kernel-owner+w=401wt.eu-S1754067Ab0ARPns@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754067Ab0ARPns (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jan 2010 10:43:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754072Ab0ARPnp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jan 2010 10:43:45 -0500
Received: from e3.ny.us.ibm.com ([32.97.182.143]:45082 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754070Ab0ARPnn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jan 2010 10:43:43 -0500
Date: Mon, 18 Jan 2010 21:13:23 +0530
From: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Avi Kivity <avi@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
       Jim Keniston <jkenisto@us.ibm.com>,
       Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
       Ingo Molnar <mingo@elte.hu>,
       Arnaldo Carvalho de Melo <acme@infradead.org>,
       utrace-devel <utrace-devel@redhat.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Maneesh Soni <maneesh@in.ibm.com>, Mark Wielaard <mjw@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] [PATCH 1/7] User Space Breakpoint Assistance Layer (UBP)
Message-ID: <20100118154323.GA4424@in.ibm.com>
Reply-To: ananth@in.ibm.com
References: <4B5325CF.5000001@redhat.com> <1263740593.557.20967.camel@twins> <4B53661A.9090907@redhat.com> <1263800752.4283.19.camel@laptop> <4B543F93.3060509@redhat.com> <1263815072.4283.305.camel@laptop> <4B544D7C.2060708@redhat.com> <1263816396.4283.361.camel@laptop> <4B544F8E.1080603@redhat.com> <84144f021001180413w76a8ca2axb0b9f07ee4dea67e@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <84144f021001180413w76a8ca2axb0b9f07ee4dea67e@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 18, 2010 at 02:13:25PM +0200, Pekka Enberg wrote:
> Hi Avi,
> 
> On Mon, 2010-01-18 at 14:01 +0200, Avi Kivity wrote:
> >>> Maybe you place no value on uprobes.  But people who debug userspace
> >>> likely will see a reason.
> 
> On 01/18/2010 02:06 PM, Peter Zijlstra wrote:
> >> I do see value in uprobes, I just don't like it mucking about with the
> >> address space. Nor does it appear required.
> 
> On Mon, Jan 18, 2010 at 2:09 PM, Avi Kivity <avi@redhat.com> wrote:
> > Well, the alternatives are very unappealing.  Emulation and single-stepping
> > are going to be very slow compared to a couple of jumps.
> 
> So how big chunks of the address space are we talking here for uprobes?

As Srikar mentioned, the least we start with is 1 page. Though you can
have as many probes as you want, there are certain optimizations we can
do, depending on the most common usecases.

For eg., if you'd consider the start of a routine to be the most
commonly traced location, most routines in a binary would generally
start with the same instruction (say push %ebp), and we can refcount a
slot with that instruction to be used for all probes of the same
instruction.

Ananth
