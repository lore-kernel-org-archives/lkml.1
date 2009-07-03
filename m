Return-Path: <linux-kernel-owner+w=401wt.eu-S1752574AbZGCHRs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752574AbZGCHRs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jul 2009 03:17:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751418AbZGCHRl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Jul 2009 03:17:41 -0400
Received: from mail.gmx.net ([213.165.64.20]:52376 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751049AbZGCHRk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jul 2009 03:17:40 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX19g9vhxOG1g9u+zFwP5sP6zecLs0OJ1IXkmUG29xH
	KJV1UxXDXWS/iW
Subject: Re: [patch 0/4] perf_counter tools: support annotation of live
 kernel modules
From: Mike Galbraith <efault@gmx.de>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>, Arnaldo Carvalho de Melo <acme@redhat.com>,
       Paul Mackerras <paulus@samba.org>,
       =?ISO-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1246536617.4752.15.camel@laptop>
References: <1246514639.13293.40.camel@marge.simson.net>
	 <20090702064712.GA26690@elte.hu>
	 <1246519076.6384.22.camel@marge.simson.net>
	 <1246536617.4752.15.camel@laptop>
Content-Type: text/plain
Date: Fri, 03 Jul 2009 09:17:39 +0200
Message-Id: <1246605459.6092.189.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.67
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-07-02 at 14:10 +0200, Peter Zijlstra wrote:
> On Thu, 2009-07-02 at 09:17 +0200, Mike Galbraith wrote:
> 
> >  I've been pondering a perf archive tool
> > that would package everything that's needed to do analysis on a
> > different box.  One big problem though, is that while you can easily
> > package vmlinux and modules, what about all the userland binaries?  A
> > large perf.data and/or debug info binaries can easily make transport
> > impractical enough.
> 
> I would simply extend the current file header with another section in
> which we do a structured storage of the data structures we currently
> build in perf-report. That is, the dso and symbol bits.
> 
> If we then run perf-report on a file containing such a section we read
> that data instead of trying to locate them the regular way.

That's a good idea.

If uname doesn't match stored record time uname, you're not live, so
tools require an exportable perf.data.  If you're not live and not on
the same host, annotate requires binaries appended via an export tool
with --sym-filter -k -u -% whatever capability.

	-Mike

