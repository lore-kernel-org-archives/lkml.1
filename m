Return-Path: <linux-kernel-owner+w=401wt.eu-S932152AbXCFVCp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932152AbXCFVCp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2007 16:02:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932167AbXCFVCp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Mar 2007 16:02:45 -0500
Received: from gw.goop.org ([64.81.55.164]:42792 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932152AbXCFVCp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2007 16:02:45 -0500
Message-ID: <45EDD6F1.7080100@goop.org>
Date: Tue, 06 Mar 2007 13:02:41 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.9 (X11/20070212)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: "Nakajima, Jun" <jun.nakajima@intel.com>,
       virtualization <virtualization@lists.osdl.org>,
       Roland McGrath <roland@redhat.com>,
       Anthony Liguori <anthony@codemonkey.ws>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Jan Beulich <jbeulich@novell.com>
Subject: Re: Xen & VMI?
References: <45ED82D9.6050204@codemonkey.ws>	<8FFF7E42E93CC646B632AB40643802A80229779B@scsmsx412.amr.corp.intel.com> <20070306203712.GC21736@elte.hu>
In-Reply-To: <20070306203712.GC21736@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> maybe we are talking past each other because i dont really disagree with 
> that: i mentioned it right at beginning that higher-level APIs would 
> have to be added to VMI. What i'd like to avoid is the ABI duplication 
> for the lowlevel stuff /and/ for the highlevel stuff. Since VMI is 
> mostly about lowlevel stuff right now it's obvious that it would have to 
> grow more highlevel ops. Doing an IO driver via IO emulation is 
> obviously pretty ... low-tech.
>
> maybe i shouldnt call it 'VMI' but 'the paravirt ABI'. I dont mind if 
> it's the Xen ABI or the VMWare ABI or a mesh of the two - everyone can 
> map their own internals to that /one/ ABI.

Well, that's the basic force shaping paravirt_ops; many of the calls are
generally used by all backends, and some are more specific.  The
entrypoints in paravirt_ops would be an approximate model for this
hypothetical ABI you're talking about.

But the key point you're missing is that this isn't a one-way
interface.  The hypervisor backend code makes calls into the kernel's
interfaces as well.  We use memory allocation, the interrupt
infrastructure, timers, per-cpu and as many other existing interfaces as
possible, so that we don't have to bloat paravirt_ops with duplicates of
all those other interfaces.

If you're seriously talking about an ABI, then you'd also have to
present stable ABIs for all subsystems the hypervisor backends want to
call into, either by actually freezing the internal linux interfaces
into ABIs, or by effectively duplicating them across the paravirt ABI
(or whatever).

    J
