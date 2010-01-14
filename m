Return-Path: <linux-kernel-owner+w=401wt.eu-S1753321Ab0ANLnW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753321Ab0ANLnW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jan 2010 06:43:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751822Ab0ANLnV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jan 2010 06:43:21 -0500
Received: from casper.infradead.org ([85.118.1.10]:39559 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751481Ab0ANLnV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jan 2010 06:43:21 -0500
Subject: Re: [RFC] [PATCH 7/7] Ftrace plugin for Uprobes
From: Peter Zijlstra <peterz@infradead.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       Arnaldo Carvalho de Melo <acme@infradead.org>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       utrace-devel <utrace-devel@redhat.com>,
       Jim Keniston <jkenisto@us.ibm.com>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Maneesh Soni <maneesh@in.ibm.com>, Mark Wielaard <mjw@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20100114113509.GB5033@nowhere>
References: <20100111122521.22050.3654.sendpatchset@srikar.in.ibm.com>
	 <20100111122608.22050.94088.sendpatchset@srikar.in.ibm.com>
	 <1263468191.4244.300.camel@laptop>  <20100114113509.GB5033@nowhere>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 14 Jan 2010 12:43:01 +0100
Message-ID: <1263469381.4244.308.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-01-14 at 12:35 +0100, Frederic Weisbecker wrote:
> On Thu, Jan 14, 2010 at 12:23:11PM +0100, Peter Zijlstra wrote:
> > On Mon, 2010-01-11 at 17:56 +0530, Srikar Dronamraju wrote:
> > > This patch implements ftrace plugin for uprobes.
> > 
> > Right, like others have said, trace events is a much saner interface.
> > 
> > So the easiest way I can see that working is to register uprobes against
> > a file (not a pid). Then on creation it uses rmap to find all current
> > maps of that file and install the probe if there is a consumer for that
> > map.
> > 
> > Then for each new mmap() of that file, we also need to check if there's
> > a consumer ready and install the probe.
> 
> 
> 
> That looks racy.
> 
> Say you first create a probe on /bin/ls:
> 
> perf probe p addr_in_ls /bin/ls
> 
> then something else launches /bin/ls behind you, probe
> is set on it
> 
> then you launch:
> 
> perf record -e "probe:...." /bin/ls
> 
> Then it goes recording the previous instance.

Uhm, why? Only the perf /bin/ls instance has a consumer and will thus
have a probe installed.

(Or if you want to use ftrace you need to always have all instances
probed anyway)

