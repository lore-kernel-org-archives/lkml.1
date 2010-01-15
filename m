Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932417Ab0AOXoz (ORCPT <rfc822;list-kernel77@spinics.net>);
	Fri, 15 Jan 2010 18:44:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932409Ab0AOXox
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jan 2010 18:44:53 -0500
Received: from e36.co.us.ibm.com ([32.97.110.154]:60306 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932381Ab0AOXow (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jan 2010 18:44:52 -0500
Subject: Re: [RFC] [PATCH 4/7] Uprobes Implementation
From: Jim Keniston <jkenisto@us.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: maneesh@in.ibm.com, Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        utrace-devel <utrace-devel@redhat.com>, Mark Wielaard <mjw@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Masami Hiramatsu <mhiramat@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1263553955.4244.393.camel@laptop>
References: <20100111122521.22050.3654.sendpatchset@srikar.in.ibm.com>
	 <20100111122553.22050.46895.sendpatchset@srikar.in.ibm.com>
	 <1263467394.4244.291.camel@laptop>
	 <1263509380.4875.35.camel@localhost.localdomain>
	 <1263546632.4244.352.camel@laptop>
	 <20100115102645.GA22640@linux.vnet.ibm.com>
	 <1263551607.4244.379.camel@laptop>  <20100115110547.GB3660@in.ibm.com>
	 <1263553955.4244.393.camel@laptop>
Content-Type: text/plain
Date: Fri, 15 Jan 2010 15:44:45 -0800
Message-Id: <1263599085.5007.88.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-8.el5_2.3) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-01-15 at 12:12 +0100, Peter Zijlstra wrote:
...
> 
> Adding the probe uses the fact that (most) executable mappings are
> MAP_PRIVATE and CoWs a private copy of the page with the modified ins,
> right?
> 
> What does it do for MAP_SHARED|MAP_EXECUTABLE sections -- simply fail to
> add the probe?

If the vma containing the instruction to be probed has the VM_EXEC flag
set (and it's not in the XOL area) we go ahead and try to probe it.  I'm
not familar with the implications of MAP_SHARED|MAP_EXECUTABLE -- how
you would get such a combo, or what access_process_vm() would do with
it.

Jim 

