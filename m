Return-Path: <linux-kernel-owner+w=401wt.eu-S932936AbYEFUhy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932936AbYEFUhy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2008 16:37:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756561AbYEFUhn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 May 2008 16:37:43 -0400
Received: from extu-mxob-1.symantec.com ([216.10.194.28]:50332 "EHLO
	extu-mxob-1.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757384AbYEFUhl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2008 16:37:41 -0400
Date: Tue, 6 May 2008 21:36:59 +0100 (BST)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.site
To: Hans Rosenfeld <hans.rosenfeld@amd.com>
cc: Ingo Molnar <mingo@elte.hu>, Jeff Chua <jeff.chua.linux@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Gabriel C <nix.or.die@googlemail.com>,
       Arjan van de Ven <arjan@linux.intel.com>,
       Nishanth Aravamudan <nacc@us.ibm.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: [PATCH] x86: fix PAE pmd_bad bootup warning
In-Reply-To: <20080506202201.GB12654@escobedo.amd.com>
Message-ID: <Pine.LNX.4.64.0805062132140.17979@blonde.site>
References: <b6a2187b0805051806v25fa1272xb08e0b70b9c3408@mail.gmail.com>
 <20080506124946.GA2146@elte.hu> <Pine.LNX.4.64.0805061435510.32567@blonde.site>
 <alpine.LFD.1.10.0805061138580.32269@woody.linux-foundation.org>
 <Pine.LNX.4.64.0805062043580.11647@blonde.site> <20080506202201.GB12654@escobedo.amd.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 6 May 2008, Hans Rosenfeld wrote:
> On Tue, May 06, 2008 at 08:49:23PM +0100, Hugh Dickins wrote:
> > So Hans' original hugepage leak remains unexplained and unfixed.
> > Hans, did you find that hugepage leak with a standard kernel, or were
> > you perhaps trying out some hugepage-using patch of your own, without
> > marking the vma VM_HUGETLB?  Or were you expecting the hugetlbfs file
> > to truncate itself once all mmappers had gone?  If the standard kernel
> > leaks hugepages, I'm surprised the hugetlb guys don't know about it.
> 
> I used a standard kernel (well, not quite, I had made some changes to
> the /proc/pid/pagemap code, but nothing that would affect the hugepage
> stuff) and some simple test program that would just mmap a hugepage.
> 
> I expected that any hugepage that a process had mmapped would
> automatically be returned to the system when the process exits. That was
> not the case, the process exited and the hugepage was lost (unless I
> changed the program to explicitly munmap the hugepage before exiting).
> Removing the hugetlbfs file containing the hugepage also didn't free the
> page.

Hmm.  That doesn't fit with my experience: I've not found an explicit
munmap makes any difference (I wouldn't expect it to), but removing
the file once all openers gone does free everything up.  I guess I'm
overlooking something more experienced hugepagers will soon light upon.

Hugh
