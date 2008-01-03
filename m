Return-Path: <linux-kernel-owner+w=401wt.eu-S1755390AbYACKWf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755390AbYACKWf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2008 05:22:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752468AbYACKWZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jan 2008 05:22:25 -0500
Received: from e34.co.us.ibm.com ([32.97.110.152]:35613 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752774AbYACKWY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2008 05:22:24 -0500
Date: Thu, 3 Jan 2008 15:52:33 +0530
From: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: akpm@linux-foundation.org, lkml <linux-kernel@vger.kernel.org>,
       Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>,
       davem@davemloft.net, mathieu.desnoyers@polymtl.ca,
       hskinnemoen@atmel.com, mhiramat@redhat.com, sam@ravnborg.org,
       randy.dunlap@oracle.com
Subject: Re: [PATCH 2/2] Kprobes: Move kprobes examples to samples/
Message-ID: <20080103102233.GB28934@in.ibm.com>
Reply-To: ananth@in.ibm.com
References: <20080103062425.GA22781@in.ibm.com> <20080103062825.GB22781@in.ibm.com> <20080103093303.GB16803@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080103093303.GB16803@elte.hu>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 03, 2008 at 10:33:03AM +0100, Ingo Molnar wrote:
> 
> * Ananth N Mavinakayanahalli <ananth@in.ibm.com> wrote:
> 
> > From: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
> > 
> > Move kprobes examples from Documentation/kprobes.txt to under 
> > samples/. Patch originally by Randy Dunlap.
> 
> nice!
> 
> > +config SAMPLE_KPROBES
> > +	tristate "Build kprobes examples -- loadable modules only"
> > +	depends on KPROBES && m
> > +	help
> > +	  This build several kprobes example modules.
> 
> feature request: please make this work in the !modular case as well - if 
> built-in then it should just run sometime during bootup and run the 
> tests and report success/failure. This way automated testing can pick up 
> any regressions much easier.

Will try cook up something along those lines. It'll be easy to verify if
the probes inserted and removed properly, but verifying handlers run
correctly will need some work.

We have a sort of regression test bucket that uses expect to parse the
dmesg to verify handlers did run correctly; that isn't a totally
in-kernel solution anyway. I have a couple of ideas in mind to make it
easier.

Ananth
