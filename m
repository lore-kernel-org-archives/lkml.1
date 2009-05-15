Return-Path: <linux-kernel-owner+w=401wt.eu-S1762796AbZEOSU1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762796AbZEOSU1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 May 2009 14:20:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761336AbZEOSUE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 May 2009 14:20:04 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:50281 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753715AbZEOSUD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 May 2009 14:20:03 -0400
Date: Fri, 15 May 2009 23:49:51 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: Dave Hansen <dave@linux.vnet.ibm.com>
Cc: Christoph Lameter <cl@linux-foundation.org>, Pavel Machek <pavel@ucw.cz>,
       David Rientjes <rientjes@google.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Greg Kroah-Hartman <gregkh@suse.de>, Nick Piggin <npiggin@suse.de>,
       Mel Gorman <mel@csn.ul.ie>, Peter Ziljstra <a.p.ziljstra@chello.nl>,
       San Mehat <san@android.com>, Arve Hj?nnev?g <arve@android.com>,
       linux-kernel@vger.kernel.org
Subject: Re: Misleading OOM messages
Message-ID: <20090515181951.GI4451@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
References: <alpine.DEB.1.10.0905121708470.14226@qirst.com> <20090514092909.GG1365@ucw.cz> <alpine.DEB.1.10.0905141546040.1381@qirst.com> <1242333519.15391.210.camel@nimitz> <alpine.DEB.2.00.0905141346030.28074@chino.kir.corp.google.com> <1242335120.15391.242.camel@nimitz> <alpine.DEB.1.10.0905141729180.30187@qirst.com> <20090514213403.GB14741@elf.ucw.cz> <alpine.DEB.1.10.0905151346550.26559@qirst.com> <1242411307.28257.25.camel@nimitz>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <1242411307.28257.25.camel@nimitz>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Dave Hansen <dave@linux.vnet.ibm.com> [2009-05-15 11:15:07]:

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
>

A long pending action item is to allow user space to handle cgroup
OOM. A cgroup can OOM, if the tasks in the group is way over their limit
and reclaim fails. I'll look to see if we enhance the output.

-- 
	Balbir
