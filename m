Return-Path: <linux-kernel-owner+w=401wt.eu-S1762734AbZEOSP0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762734AbZEOSP0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 May 2009 14:15:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756268AbZEOSPO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 May 2009 14:15:14 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:43567 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755257AbZEOSPM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 May 2009 14:15:12 -0400
Subject: Re: Misleading OOM messages
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Christoph Lameter <cl@linux-foundation.org>
Cc: Pavel Machek <pavel@ucw.cz>, David Rientjes <rientjes@google.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Greg Kroah-Hartman <gregkh@suse.de>, Nick Piggin <npiggin@suse.de>,
       Mel Gorman <mel@csn.ul.ie>, Peter Ziljstra <a.p.ziljstra@chello.nl>,
       San Mehat <san@android.com>, Arve Hj?nnev?g <arve@android.com>,
       linux-kernel@vger.kernel.org, Balbir Singh <balbir@linux.vnet.ibm.com>
In-Reply-To: <alpine.DEB.1.10.0905151346550.26559@qirst.com>
References: <alpine.DEB.2.00.0905101458430.18804@chino.kir.corp.google.com>
	 <alpine.DEB.2.00.0905101503070.18804@chino.kir.corp.google.com>
	 <alpine.DEB.1.10.0905121708470.14226@qirst.com>
	 <20090514092909.GG1365@ucw.cz>
	 <alpine.DEB.1.10.0905141546040.1381@qirst.com>
	 <1242333519.15391.210.camel@nimitz>
	 <alpine.DEB.2.00.0905141346030.28074@chino.kir.corp.google.com>
	 <1242335120.15391.242.camel@nimitz>
	 <alpine.DEB.1.10.0905141729180.30187@qirst.com>
	 <20090514213403.GB14741@elf.ucw.cz>
	 <alpine.DEB.1.10.0905151346550.26559@qirst.com>
Content-Type: text/plain
Date: Fri, 15 May 2009 11:15:07 -0700
Message-Id: <1242411307.28257.25.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-05-15 at 13:57 -0400, Christoph Lameter wrote:
> > If you misconfigured cgroups, you give more memory to them.
> 
> If you do not have enough memory in a cgroup then your application should
> slow down (because of page evictions) but the system should not OOM.
> Are cgroups broken or why are you getting OOMs when using them?

See mm/oom_kill.c::mem_cgroup_out_of_memory().  A group itself can have
an OOM done on it.  It's not a system-wide oom.  We just need to ensure
that we continue to differentiate the cgroup-specific oom message from
the general one.  Maybe also include some more cgroup info in the debug
outbut.

-- Dave

