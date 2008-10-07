Return-Path: <linux-kernel-owner+w=401wt.eu-S1757176AbYJGXPA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757176AbYJGXPA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2008 19:15:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754668AbYJGXOw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Oct 2008 19:14:52 -0400
Received: from one.firstfloor.org ([213.235.205.2]:45465 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754618AbYJGXOv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2008 19:14:51 -0400
Date: Wed, 8 Oct 2008 01:20:59 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Andi Kleen <andi@firstfloor.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       "Kirill A. Shutemov" <kirill@shutemov.name>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       Ingo Molnar <mingo@redhat.com>, Arjan van de Ven <arjan@infradead.org>,
       Hugh Dickins <hugh@veritas.com>, Ulrich Drepper <drepper@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH, v3] shmat: introduce flag SHM_MAP_NOT_FIXED
Message-ID: <20081007232059.GU20740@one.firstfloor.org>
References: <1223396117-8118-1-git-send-email-kirill@shutemov.name> <2f11576a0810070931k79eb72dfr838a96650563b93a@mail.gmail.com> <20081007211038.GQ20740@one.firstfloor.org> <20081008000518.13f48462@lxorguk.ukuu.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081008000518.13f48462@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 08, 2008 at 12:05:18AM +0100, Alan Cox wrote:
> On Tue, 7 Oct 2008 23:10:38 +0200
> Andi Kleen <andi@firstfloor.org> wrote:
> 
> > > Sorry, no.
> > > This description still doesn't explain why this interface is needed.
> > > 
> > > The one of the points is this interface is used by another person or not.
> > > You should explain how large this interface benefit has.
> > > 
> > > Andi kleen explained this interface _can_  be used another one.
> > > but nobody explain who use it actually.
> > 
> > Anyone who doesn't want to use fixed addresses. 
> 
> Can use shm_open and mmap to get POSIX standard shm behaviour via a sane

I don't think shm_open can attach to SYSV shared segments. Or are you
proposing to add "sysvshmfs" to make that possible? 

> interface without adding more crap to the sys3 shm madness. 
> 
> Sorry this patch is completely bogus - introduce the user programs
> involved to 1990s technology. 

As already listed in an earlier email, but here again:

- There are legacy interfaces that cannot be really changed who use sysv shm
(e.g. X shm and others -- just do a ipcs on your system) 
- An system call emulation as in qemu obviously has to implement the
existing system call semantics.

-Andi

-- 
ak@linux.intel.com
