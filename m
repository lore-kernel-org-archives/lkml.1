Return-Path: <linux-kernel-owner+w=401wt.eu-S1756132Ab0ANM3m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756132Ab0ANM3m (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jan 2010 07:29:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756090Ab0ANM3j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jan 2010 07:29:39 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:54642 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755854Ab0ANM3h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jan 2010 07:29:37 -0500
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
In-Reply-To: <20100114122329.GC5033@nowhere>
References: <20100111122521.22050.3654.sendpatchset@srikar.in.ibm.com>
	 <20100111122608.22050.94088.sendpatchset@srikar.in.ibm.com>
	 <1263468191.4244.300.camel@laptop> <20100114113509.GB5033@nowhere>
	 <1263469381.4244.308.camel@laptop>  <20100114122329.GC5033@nowhere>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 14 Jan 2010 13:29:09 +0100
Message-ID: <1263472149.4244.314.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-01-14 at 13:23 +0100, Frederic Weisbecker wrote:
> 
> I see, so what you suggest is to have the probe set up
> as generic first. Then the process that activates it
> becomes a consumer, right?

Right, so either we have it always on, for things like ftrace, 

  in which case the creation traverses rmap and installs the probes
  all existing mmap()s, and a mmap() hook will install it on all new
  ones.

Or they're strictly consumer driver, like perf, in which case the act of
enabling the event will install the probe (if its not there yet).

