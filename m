Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753505Ab0APPvL (ORCPT <rfc822;list-kernel77@spinics.net>);
	Sat, 16 Jan 2010 10:51:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753246Ab0APPvK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Jan 2010 10:51:10 -0500
Received: from mx1.redhat.com ([209.132.183.28]:53593 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753168Ab0APPvG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jan 2010 10:51:06 -0500
To: Jim Keniston <jkenisto@us.ibm.com>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, Mark Wielaard <mjw@redhat.com>,
        utrace-devel <utrace-devel@redhat.com>
Subject: Re: [RFC] [PATCH 4/7] Uprobes Implementation
References: <20100111122553.22050.46895.sendpatchset@srikar.in.ibm.com>
	<1263467394.4244.291.camel@laptop>
	<1263509380.4875.35.camel@localhost.localdomain>
	<1263546632.4244.352.camel@laptop> <y0mvdf3en1y.fsf@fche.csb>
	<1263548124.4244.358.camel@laptop> <20100115131037.GP4822@redhat.com>
	<1263561930.4244.417.camel@laptop> <20100115133825.GQ4822@redhat.com>
	<1263563276.4244.426.camel@laptop>
	<20100115142007.GA1628@linux.vnet.ibm.com>
	<1263597085.5007.82.camel@localhost.localdomain>
From: fche@redhat.com (Frank Ch. Eigler)
Date: Sat, 16 Jan 2010 10:50:48 -0500
In-Reply-To: <1263597085.5007.82.camel@localhost.localdomain> (Jim Keniston's message of "Fri, 15 Jan 2010 15:11:25 -0800")
Message-ID: <y0m63722gmf.fsf@fche.csb>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Jim Keniston <jkenisto@us.ibm.com> writes:

> [...]
> Years ago, we had pre-utrace versions of uprobes where the uprobes
> breakpoint-handler code was dispatched from the die_notifier, before the
> int3 turned into a SIGTRAP.  I believe that's what Peter is
> recommending.  On my old Pentium M...
> - a pre-utrace uprobe hit cost about 1 usec;
> - a utrace-based uprobe hit cost about 3 usec;
> [...]
> So yeah, learning about the int3 via utrace after the SIGTRAP gets
> created adds some overhead to uprobes.  [...]

Was this test comparing likewise fruit?  For example, did it account
for factors where other processes were gdb-int3-instrumented or with
lots of kprobes active?  Differently multithreaded?  Demultiplexing
probes amongst multiple processes?

(It's counterintuitive that the utrace/kernel int3->sigtrap
dispatching code alone should cause thousands of extra instructions.)

- FChE
