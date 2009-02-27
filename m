Return-Path: <linux-kernel-owner+w=401wt.eu-S1759546AbZB0Vdz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759546AbZB0Vdz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Feb 2009 16:33:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758499AbZB0Vdr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Feb 2009 16:33:47 -0500
Received: from e33.co.us.ibm.com ([32.97.110.151]:52868 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755763AbZB0Vdq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Feb 2009 16:33:46 -0500
Date: Fri, 27 Feb 2009 13:33:40 -0800
From: Gary Hade <garyhade@us.ibm.com>
To: roel kluin <roel.kluin@gmail.com>
Cc: Gary Hade <garyhade@us.ibm.com>, Andrew Morton <akpm@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, lkml <linux-kernel@vger.kernel.org>,
       linux-mm@kvack.org, y-goto@jp.fujitsu.com
Subject: Re: [PATCH] mm: get_nid_for_pfn() returns int
Message-ID: <20090227213340.GB7174@us.ibm.com>
References: <4973AEEC.70504@gmail.com> <20090119175919.GA7476@us.ibm.com> <20090126223350.610b0283.akpm@linux-foundation.org> <20090127210727.GA9592@us.ibm.com> <25e057c00902270656x1781d04er5703058e47df455f@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <25e057c00902270656x1781d04er5703058e47df455f@mail.gmail.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 27, 2009 at 03:56:40PM +0100, roel kluin wrote:
> >> > > get_nid_for_pfn() returns int
> 
> >> > My mistake.  Good catch.
> 
> >> Presumably the (nid < 0) case has never happened.
> >
> > We do know that it is happening on one system while creating
> > a symlink for a memory section so it should also happen on
> > the same system if unregister_mem_sect_under_nodes() were
> > called to remove the same symlink.
> >
> > The test was actually added in response to a problem with an
> > earlier version reported by Yasunori Goto where one or more
> > of the leading pages of a memory section on the 2nd node of
> > one of his systems was uninitialized because I believe they
> > coincided with a memory hole.  The earlier version did not
> > ignore uninitialized pages and determined the nid by considering
> > only the 1st page of each memory section.  This caused the
> > symlink to the 1st memory section on the 2nd node to be
> > incorrectly created in /sys/devices/system/node/node0 instead
> > of /sys/devices/system/node/node1.  The problem was fixed by
> > adding the test to skip over uninitialized pages.
> >
> > I suspect we have not seen any reports of the non-removal
> > of a symlink due to the incorrect declaration of the nid
> > variable in unregister_mem_sect_under_nodes() because
> >  - systems where a memory section could have an uninitialized
> >    range of leading pages are probably rare.
> >  - memory remove is probably not done very frequently on the
> >    systems that are capable of demonstrating the problem.
> >  - lingering symlink(s) that should have been removed may
> >    have simply gone unnoticed.
> >>
> >> Should we retain the test?
> >
> > Yes.
> >
> >>
> >> Is silently skipping the node in that case desirable behaviour?
> >
> > It actually silently skips pages (not nodes) in it's quest
> > for valid nids for all the nodes that the memory section scans.
> > This is definitely desirable.
> >
> > I hope this answers your questions.
> 
> This still isn't applied, was it lost?

It is still lingering in -mm:
http://userweb.kernel.org/~akpm/mmotm/broken-out/mm-get_nid_for_pfn-returns-int.patch

Gary

-- 
Gary Hade
System x Enablement
IBM Linux Technology Center
503-578-4503  IBM T/L: 775-4503
garyhade@us.ibm.com
http://www.ibm.com/linux/ltc

