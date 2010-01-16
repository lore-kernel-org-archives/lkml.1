Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753503Ab0APKET (ORCPT <rfc822;list-kernel77@spinics.net>);
	Sat, 16 Jan 2010 05:04:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752212Ab0APKET
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Jan 2010 05:04:19 -0500
Received: from casper.infradead.org ([85.118.1.10]:52040 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751822Ab0APKES (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jan 2010 05:04:18 -0500
Subject: Re: [RFC] [PATCH 4/7] Uprobes Implementation
From: Peter Zijlstra <peterz@infradead.org>
To: Jim Keniston <jkenisto@us.ibm.com>
Cc: maneesh@in.ibm.com, Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        utrace-devel <utrace-devel@redhat.com>, Mark Wielaard <mjw@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Masami Hiramatsu <mhiramat@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1263599085.5007.88.camel@localhost.localdomain>
References: <20100111122521.22050.3654.sendpatchset@srikar.in.ibm.com>
	 <20100111122553.22050.46895.sendpatchset@srikar.in.ibm.com>
	 <1263467394.4244.291.camel@laptop>
	 <1263509380.4875.35.camel@localhost.localdomain>
	 <1263546632.4244.352.camel@laptop>
	 <20100115102645.GA22640@linux.vnet.ibm.com>
	 <1263551607.4244.379.camel@laptop>  <20100115110547.GB3660@in.ibm.com>
	 <1263553955.4244.393.camel@laptop>
	 <1263599085.5007.88.camel@localhost.localdomain>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 16 Jan 2010 11:04:09 +0100
Message-ID: <1263636249.4244.525.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-01-15 at 15:44 -0800, Jim Keniston wrote:
> On Fri, 2010-01-15 at 12:12 +0100, Peter Zijlstra wrote:
> ....
> > 
> > Adding the probe uses the fact that (most) executable mappings are
> > MAP_PRIVATE and CoWs a private copy of the page with the modified ins,
> > right?
> > 
> > What does it do for MAP_SHARED|MAP_EXECUTABLE sections -- simply fail to
> > add the probe?
> 
> If the vma containing the instruction to be probed has the VM_EXEC flag
> set (and it's not in the XOL area) we go ahead and try to probe it.  I'm
> not familar with the implications of MAP_SHARED|MAP_EXECUTABLE -- how
> you would get such a combo, or what access_process_vm() would do with
> it.

I'm not sure how you'd get one, the user has to explicitly create one I
think, regular loaders don't create such things, but maybe JITs do.

The problem is that for MAP_SHARED you cannot CoW the page, you have to
modify the original page, which might get written back into a file if
its file based, not something you'd want to have happen I guess.

