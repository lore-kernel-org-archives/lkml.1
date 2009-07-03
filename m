Return-Path: <linux-kernel-owner+w=401wt.eu-S1754656AbZGCIlX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754656AbZGCIlX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jul 2009 04:41:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752475AbZGCIlP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Jul 2009 04:41:15 -0400
Received: from mail-ew0-f215.google.com ([209.85.219.215]:42027 "EHLO
	mail-ew0-f215.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751923AbZGCIlO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jul 2009 04:41:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=SY3JMmOI23vhhwuHJ3Nzit/2e7VVCy75OkIvomC8hiTr37vefahf2tt1dV5J0qk2Ie
         cSykBJ0AmtpuBFSuxjYHdRKhcNrFfPpbTeibtZ6NWQ9lMMK7fDZUxQf948wOsqpSwT2n
         7uJpbD1T4HN2MrKbsqaDyLPirCSCCB/oZZ3XI=
Date: Fri, 3 Jul 2009 10:41:11 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Mike Galbraith <efault@gmx.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Paul Mackerras <paulus@samba.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [patch 0/4] perf_counter tools: support annotation of live
	kernel modules
Message-ID: <20090703084109.GA4933@nowhere>
References: <1246514639.13293.40.camel@marge.simson.net> <20090702064712.GA26690@elte.hu> <1246519076.6384.22.camel@marge.simson.net> <1246536617.4752.15.camel@laptop> <1246605459.6092.189.camel@marge.simson.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1246605459.6092.189.camel@marge.simson.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 03, 2009 at 09:17:39AM +0200, Mike Galbraith wrote:
> On Thu, 2009-07-02 at 14:10 +0200, Peter Zijlstra wrote:
> > On Thu, 2009-07-02 at 09:17 +0200, Mike Galbraith wrote:
> > 
> > >  I've been pondering a perf archive tool
> > > that would package everything that's needed to do analysis on a
> > > different box.  One big problem though, is that while you can easily
> > > package vmlinux and modules, what about all the userland binaries?  A
> > > large perf.data and/or debug info binaries can easily make transport
> > > impractical enough.
> > 
> > I would simply extend the current file header with another section in
> > which we do a structured storage of the data structures we currently
> > build in perf-report. That is, the dso and symbol bits.
> > 
> > If we then run perf-report on a file containing such a section we read
> > that data instead of trying to locate them the regular way.
> 
> That's a good idea.
> 
> If uname doesn't match stored record time uname, you're not live, so
> tools require an exportable perf.data.  If you're not live and not on
> the same host, annotate requires binaries appended via an export tool
> with --sym-filter -k -u -% whatever capability.
> 
> 	-Mike


Also that would make easier the implementation of a perf compare thing.
A perf compare may have several uses, including:

(1) comparing different workloads with a same executable.
(2) comparing different executable versions for a same workload
(3) (1) + (2) ?


For the (2), having  self contained record files as operands would let
comparisons based on symbols, pretty useful when you have to compare
two different vmlinux (or whatever binary executable).

