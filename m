Return-Path: <linux-kernel-owner+w=401wt.eu-S1754238Ab0ARHhn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754238Ab0ARHhn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jan 2010 02:37:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754153Ab0ARHhm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jan 2010 02:37:42 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:41296 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753573Ab0ARHhl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jan 2010 02:37:41 -0500
Subject: Re: [RFC] [PATCH 1/7] User Space Breakpoint Assistance Layer (UBP)
From: Peter Zijlstra <peterz@infradead.org>
To: Bryan Donlan <bdonlan@gmail.com>
Cc: Jim Keniston <jkenisto@us.ibm.com>,
       Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
       Ingo Molnar <mingo@elte.hu>,
       Arnaldo Carvalho de Melo <acme@infradead.org>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       utrace-devel <utrace-devel@redhat.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Maneesh Soni <maneesh@in.ibm.com>, Mark Wielaard <mjw@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <3e8340491001161612x11873abdi4b74e47309e5bdfd@mail.gmail.com>
References: <20100111122521.22050.3654.sendpatchset@srikar.in.ibm.com>
	 <20100111122529.22050.32596.sendpatchset@srikar.in.ibm.com>
	 <1263467289.4244.288.camel@laptop>
	 <1263498366.4875.25.camel@localhost.localdomain>
	 <1263546175.4244.342.camel@laptop>
	 <1263589634.5007.34.camel@localhost.localdomain>
	 <1263592192.4244.488.camel@laptop>
	 <1263603503.5007.134.camel@localhost.localdomain>
	 <3e8340491001161612x11873abdi4b74e47309e5bdfd@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 18 Jan 2010 08:37:15 +0100
Message-ID: <1263800235.4283.10.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2010-01-16 at 19:12 -0500, Bryan Donlan wrote:
> On Fri, Jan 15, 2010 at 7:58 PM, Jim Keniston <jkenisto@us.ibm.com> wrote:
> 
> > 4. Emulation removes the need for the XOL area, but requires pretty much
> > total knowledge of the instruction set.  It's also a performance win for
> > architectures that can't do #3.  I see kvm implemented on 4
> > architectures (ia64, powerpc, s390, x86).  Coincidentally, those are the
> > architectures to which uprobes (old uprobes, with ubp and xol bundled
> > in) has already been ported (though Intel hasn't been maintaining their
> > ia64 port).  So it sort of comes down to how objectionable the XOL vma
> > (or page) really is.
> 
> On x86 at least, wouldn't one option to be to run the instruction to
> be emulated in CPL ('ring') 2, from a XOL page above the user-kernel
> split, not accessible to userspace at CPL 3? Linux hasn't
> traditionally used anything other than CPL 0 and CPL 3 (plus CPL 1 on
> Xen), but it would seem to avoid many of the problems here - it's
> invisible to normal userspace code and so doesn't pollute userspace
> memory maps with kernel-private stuff, but since it's running at a
> higher CPL than the kernel, we can still protect kernel memory and
> protect against privileged instructions.

Another option is to go play games with the RPL of the user data
segments when we load them. But yeah, something like this seems to
nicely deal with the protection issues.

