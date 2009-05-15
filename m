Return-Path: <linux-kernel-owner+w=401wt.eu-S1754498AbZEOT1V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754498AbZEOT1V (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 May 2009 15:27:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752297AbZEOT1M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 May 2009 15:27:12 -0400
Received: from smtp3.ultrahosting.com ([74.213.175.254]:54933 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751740AbZEOT1M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 May 2009 15:27:12 -0400
Date: Fri, 15 May 2009 15:26:43 -0400 (EDT)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@qirst.com
To: Dave Hansen <dave@linux.vnet.ibm.com>
cc: Pavel Machek <pavel@ucw.cz>, David Rientjes <rientjes@google.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Greg Kroah-Hartman <gregkh@suse.de>, Nick Piggin <npiggin@suse.de>,
       Mel Gorman <mel@csn.ul.ie>, Peter Ziljstra <a.p.ziljstra@chello.nl>,
       San Mehat <san@android.com>, Arve Hj?nnev?g <arve@android.com>,
       linux-kernel@vger.kernel.org, Balbir Singh <balbir@linux.vnet.ibm.com>
Subject: Re: Misleading OOM messages
In-Reply-To: <1242411307.28257.25.camel@nimitz>
Message-ID: <alpine.DEB.1.10.0905151526170.13433@qirst.com>
References: <alpine.DEB.2.00.0905101458430.18804@chino.kir.corp.google.com>  <alpine.DEB.2.00.0905101503070.18804@chino.kir.corp.google.com>  <alpine.DEB.1.10.0905121708470.14226@qirst.com>  <20090514092909.GG1365@ucw.cz>  <alpine.DEB.1.10.0905141546040.1381@qirst.com>
  <1242333519.15391.210.camel@nimitz>  <alpine.DEB.2.00.0905141346030.28074@chino.kir.corp.google.com>  <1242335120.15391.242.camel@nimitz>  <alpine.DEB.1.10.0905141729180.30187@qirst.com>  <20090514213403.GB14741@elf.ucw.cz>  <alpine.DEB.1.10.0905151346550.26559@qirst.com>
 <1242411307.28257.25.camel@nimitz>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 15 May 2009, Dave Hansen wrote:

> On Fri, 2009-05-15 at 13:57 -0400, Christoph Lameter wrote:
> > > If you misconfigured cgroups, you give more memory to them.
> >
> > If you do not have enough memory in a cgroup then your application should
> > slow down (because of page evictions) but the system should not OOM.
> > Are cgroups broken or why are you getting OOMs when using them?
>
> See mm/oom_kill.c::mem_cgroup_out_of_memory().  A group itself can have
> an OOM done on it.  It's not a system-wide oom.  We just need to ensure
> that we continue to differentiate the cgroup-specific oom message from
> the general one.  Maybe also include some more cgroup info in the debug
> outbut.

But that is a resource control isssue. Should also not say out of memory
but state that the cgroup memory limit was reached.

