Return-Path: <linux-kernel-owner+w=401wt.eu-S1754592AbZBWLjT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754592AbZBWLjT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Feb 2009 06:39:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753256AbZBWLjH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Feb 2009 06:39:07 -0500
Received: from bowden.ucwb.org.au ([203.122.237.119]:53929 "EHLO
	mail.ucwb.org.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753039AbZBWLjG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Feb 2009 06:39:06 -0500
Subject: Re: [Bug #12465] KVM guests stalling on 2.6.28 (bisected) [Bug
	12465]
From: Kevin Shanahan <kmshanah@ucwb.org.au>
To: Ingo Molnar <mingo@elte.hu>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Mike Galbraith <efault@gmx.de>, bugme-daemon@bugzilla.kernel.org,
       Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
In-Reply-To: <20090215100454.GA30314@elte.hu>
References: <sTyoMUwdm9B.A.QCH.U40lJB@chimera>
	 <ROx6X68CGJG.A.54H.w40lJB@chimera>
	 <1234691284.4967.23.camel@kulgan.wumi.org.au>
	 <20090215100454.GA30314@elte.hu>
Content-Type: text/plain; charset=UTF-8
Organization: UnitingCare Wesley Bowden
Date: Mon, 23 Feb 2009 22:08:55 +1030
Message-Id: <1235389135.7901.11.camel@kulgan.wumi.org.au>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2009-02-15 at 11:04 +0100, Ingo Molnar wrote:
> It would be nice to enhance this single-CPU trace some more - to more
> surgically see what is going on. Firstly, absolute timestamps would be
> nice:
> 
>   echo funcgraph-abstime  > trace_options
>   echo funcgraph-proc     > trace_options
> 
> as it's a bit hard to see the global timescale of events.

Okay, here's some more trace data. I grabbed a few samples at different
times during the ping test. I think the data in files trace6.txt and
trace8.txt coincided with some of the biggest delays.

  http://disenchant.net/tmp/bug-12465/trace-2/

This is captured on 2.6.29-rc5-tip-02057-gaad11ad. The kvm guest being
pinged is process 11211:

  flexo:~# pstree -p 11211
  qemu-system-x86(11211)─┬─{qemu-system-x86}(11212)
                         ├─{qemu-system-x86}(11213)
                         └─{qemu-system-x86}(11609)

Cheers,
Kevin.

> Secondly, not all events are included - in particular i dont really see
> the points when packets are passed. Would it be possible to add a tracing
> hypercall so that the guest kernel can inject trace events that can be seen
> on the native-side trace? Regarding ping latencies really just two things
> matter: the loopback network device's rx and tx path. We should trace the
> outgoing sequence number and the incoming sequence number of IP packets,
> and inject that to the host side. This way we can correlate the delays
> precisely.
> 
> 	Ingo


