Return-Path: <linux-kernel-owner+w=401wt.eu-S1767019AbXDEOpW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767019AbXDEOpW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2007 10:45:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767016AbXDEOpW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Apr 2007 10:45:22 -0400
Received: from outbound-fra.frontbridge.com ([62.209.45.174]:31708 "EHLO
	outbound1-fra-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1767024AbXDEOpU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2007 10:45:20 -0400
X-BigFish: VP
X-Server-Uuid: 5FC0E2DF-CD44-48CD-883A-0ED95B391E89
Date: Thu, 5 Apr 2007 16:44:42 +0200
From: "Andreas Herrmann" <andreas.herrmann3@amd.com>
To: "Andi Kleen" <ak@suse.de>
cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: limit mwait_idle to Intel CPUs
Message-ID: <20070405144442.GP6356@alberich.amd.com>
References: <20070405140045.GN6356@alberich.amd.com>
 <200704051624.45747.ak@suse.de>
MIME-Version: 1.0
In-Reply-To: <200704051624.45747.ak@suse.de>
User-Agent: mutt-ng/devel-r804 (Linux)
X-OriginalArrivalTime: 05 Apr 2007 14:44:37.0630 (UTC)
 FILETIME=[EF4019E0:01C77790]
X-WSS-ID: 6A0BD4D23283272322-01-01
Content-Type: text/plain;
 charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 05, 2007 at 04:24:45PM +0200, Andi Kleen wrote:
> On Thursday 05 April 2007 16:00:45 Andreas Herrmann wrote:
> > 
> > Commit 991528d7348667924176f3e29addea0675298944
> > introduced mwait_idle which is supposed to work
> > for Intel CPUs starting with Core Duo.
> > 
> > AMD Fam10 processors won't enter C1 on mwait.
> 
> Unfortunate. Will this be fixed?

No, it is not planned to change this behavior.

In fact mwait does certain power savings but the
core won't enter the C1 state. And power savings from
entering C1 are greater than power savings caused
by mwait (on AMD Fam10).

> 
> > This patch will enable default_idle for non-Intel
> > CPUs even if mwait is supported.
> 
> It would be better to clear MONITOR/MWAIT in the AMD specific
> CPU initialize code than add workarounds everywhere else.

Why is that?
MONITOR/MWAIT is usable. And I think this should
be indicated by cpuinfo.
It's just inappropriate to use it in pm_idle.


Regards,

Andreas

-- 
AMD Saxony, Dresden, Germany
Operating System Research Center



