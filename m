Return-Path: <linux-kernel-owner+w=401wt.eu-S932557AbYEFU1b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932557AbYEFU1b (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2008 16:27:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754545AbYEFU1V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 May 2008 16:27:21 -0400
Received: from outbound-sin.frontbridge.com ([207.46.51.80]:19626 "EHLO
	outbound2-sin-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755171AbYEFU1U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2008 16:27:20 -0400
X-BigFish: VP
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 139.95.251.11;Service: EHS
X-WSS-ID: 0K0GR8H-03-1GD-01
Date: Tue, 6 May 2008 22:22:01 +0200
From: Hans Rosenfeld <hans.rosenfeld@amd.com>
To: Hugh Dickins <hugh@veritas.com>
Cc: Ingo Molnar <mingo@elte.hu>, Jeff Chua <jeff.chua.linux@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Gabriel C <nix.or.die@googlemail.com>,
       Arjan van de Ven <arjan@linux.intel.com>,
       Nishanth Aravamudan <nacc@us.ibm.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: [PATCH] x86: fix PAE pmd_bad bootup warning
Message-ID: <20080506202201.GB12654@escobedo.amd.com>
References: <b6a2187b0805051806v25fa1272xb08e0b70b9c3408@mail.gmail.com> <20080506124946.GA2146@elte.hu> <Pine.LNX.4.64.0805061435510.32567@blonde.site> <alpine.LFD.1.10.0805061138580.32269@woody.linux-foundation.org> <Pine.LNX.4.64.0805062043580.11647@blonde.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0805062043580.11647@blonde.site>
User-Agent: Mutt/1.4.2.3i
X-OriginalArrivalTime: 06 May 2008 20:21:59.0548 (UTC) FILETIME=[D65E6BC0:01C8AFB6]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 06, 2008 at 08:49:23PM +0100, Hugh Dickins wrote:
> So Hans' original hugepage leak remains unexplained and unfixed.
> Hans, did you find that hugepage leak with a standard kernel, or were
> you perhaps trying out some hugepage-using patch of your own, without
> marking the vma VM_HUGETLB?  Or were you expecting the hugetlbfs file
> to truncate itself once all mmappers had gone?  If the standard kernel
> leaks hugepages, I'm surprised the hugetlb guys don't know about it.

I used a standard kernel (well, not quite, I had made some changes to
the /proc/pid/pagemap code, but nothing that would affect the hugepage
stuff) and some simple test program that would just mmap a hugepage.

I expected that any hugepage that a process had mmapped would
automatically be returned to the system when the process exits. That was
not the case, the process exited and the hugepage was lost (unless I
changed the program to explicitly munmap the hugepage before exiting).
Removing the hugetlbfs file containing the hugepage also didn't free the
page.


-- 
%SYSTEM-F-ANARCHISM, The operating system has been overthrown

