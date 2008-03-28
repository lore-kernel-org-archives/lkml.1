Return-Path: <linux-kernel-owner+w=401wt.eu-S1757246AbYC1Qnl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757246AbYC1Qnl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2008 12:43:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757071AbYC1Qn3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Mar 2008 12:43:29 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:41236 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753423AbYC1Qn2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2008 12:43:28 -0400
Subject: Re: [PATCH 3 of 4] sparsemem: reduce i386 PAE section size
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Christoph Lameter <clameter@sgi.com>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Yasunori Goto <y-goto@jp.fujitsu.com>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <47EC8DD0.4090401@goop.org>
References: <b7d0773c79887ca98d6c.1206664119@localhost>
	 <Pine.LNX.4.64.0803271734450.10635@schroedinger.engr.sgi.com>
	 <47EC574C.10006@goop.org>
	 <Pine.LNX.4.64.0803271926520.11576@schroedinger.engr.sgi.com>
	 <47EC8DD0.4090401@goop.org>
Content-Type: text/plain
Date: Fri, 28 Mar 2008 09:43:19 -0700
Message-Id: <1206722599.7883.119.camel@nimitz.home.sr71.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-03-27 at 23:18 -0700, Jeremy Fitzhardinge wrote:
> Christoph Lameter wrote:
> > Only works on i386 if you either use sparsemem / vmemmap or not sparsemem 
> > though. Is there any need for the other sparsemem memory models? Or could 
> > we disable them like on x86_64?
> 
> Probably, but I don't know what the tradeoffs are.  All I want is 
> hotplug memory.

Developers should probably learn the tradeoffs before they go start
poking around in code and sending patches. ;)

Maybe Christoph has a good idea what the tradeoffs are for the vmemmap
variant, but the table-based one is pretty simple.  Smaller sections
mean that it costs you larger sparsemem structures and more bits in
page->flags.  But, the smaller the section, the more mem_map[] you might
waste.

BTW, the current 1G sections were picked because all the hardware we
knew of at the time had 512MB dimms that had to be added in pairs.  So,
we didn't ever have physical hotplug of less than that.

-- Dave

