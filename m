Return-Path: <linux-kernel-owner+w=401wt.eu-S1754931Ab0ANLfU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754931Ab0ANLfU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jan 2010 06:35:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753271Ab0ANLfT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jan 2010 06:35:19 -0500
Received: from ey-out-2122.google.com ([74.125.78.27]:8190 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752823Ab0ANLfS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jan 2010 06:35:18 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=C1rvVmJa2lIR1kr9AcUYny+jscVznnNoVrFHGtJ48OG0b2Aiw+TYRM+qv16tln5nm4
         EruMLGq3Sw/Cj/xrWyMPXgJsRFG5ZjW3IfL1/B30HwqUhJknTtAjSaPRomVMUllO898+
         wIsU4Mf1EfMnzH9vvwC+TfIatXWRQX9IQ3WA0=
Date: Thu, 14 Jan 2010 12:35:12 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       Arnaldo Carvalho de Melo <acme@infradead.org>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       utrace-devel <utrace-devel@redhat.com>,
       Jim Keniston <jkenisto@us.ibm.com>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Maneesh Soni <maneesh@in.ibm.com>, Mark Wielaard <mjw@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] [PATCH 7/7] Ftrace plugin for Uprobes
Message-ID: <20100114113509.GB5033@nowhere>
References: <20100111122521.22050.3654.sendpatchset@srikar.in.ibm.com> <20100111122608.22050.94088.sendpatchset@srikar.in.ibm.com> <1263468191.4244.300.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1263468191.4244.300.camel@laptop>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 14, 2010 at 12:23:11PM +0100, Peter Zijlstra wrote:
> On Mon, 2010-01-11 at 17:56 +0530, Srikar Dronamraju wrote:
> > This patch implements ftrace plugin for uprobes.
> 
> Right, like others have said, trace events is a much saner interface.
> 
> So the easiest way I can see that working is to register uprobes against
> a file (not a pid). Then on creation it uses rmap to find all current
> maps of that file and install the probe if there is a consumer for that
> map.
> 
> Then for each new mmap() of that file, we also need to check if there's
> a consumer ready and install the probe.



That looks racy.

Say you first create a probe on /bin/ls:

perf probe p addr_in_ls /bin/ls

then something else launches /bin/ls behind you, probe
is set on it

then you launch:

perf record -e "probe:...." /bin/ls

Then it goes recording the previous instance.

