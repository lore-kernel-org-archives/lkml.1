Return-Path: <linux-kernel-owner+w=401wt.eu-S1762190AbXF0QAU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762190AbXF0QAU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2007 12:00:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757043AbXF0QAF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jun 2007 12:00:05 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:3381 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752894AbXF0QAB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2007 12:00:01 -0400
X-AuthUser: davidel@xmailserver.org
Date: Wed, 27 Jun 2007 08:59:52 -0700 (PDT)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Hugh Dickins <hugh@veritas.com>
cc: Ulrich Drepper <drepper@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [patch 2/3] MAP_NOZERO - implement sys_brk2()
In-Reply-To: <Pine.LNX.4.64.0706271309500.26951@blonde.wat.veritas.com>
Message-ID: <Pine.LNX.4.64.0706270845460.32400@alien.or.mcafeemobile.com>
References: <send-serie.davidel@xmailserver.org.29496.1182912260.2> 
 <a36005b50706262048y5eb8ba80kb0d852d649d1ac10@mail.gmail.com> 
 <Pine.LNX.4.64.0706262052060.26540@alien.or.mcafeemobile.com>
 <a36005b50706262202w4aaa4494qc2322e49c71d8d7c@mail.gmail.com>
 <Pine.LNX.4.64.0706271309500.26951@blonde.wat.veritas.com>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 27 Jun 2007, Hugh Dickins wrote:

> On Tue, 26 Jun 2007, Ulrich Drepper wrote:
> > On 6/26/07, Davide Libenzi <davidel@xmailserver.org> wrote:
> > 
> > > OTOH glibc could implement __morecore using mmap(MAP_NOZERO), and hence
> > > brk2() would not be needed, no?
> > 
> > No.  mmap calls create individual VMAs which gets expensive.  There
> > are also some hardware drivers which get more expensive the more VMAs
> > there are.  I want to go away as much as possible from mmap for
> > malloc.
> 
> Not so: if an mmap can be done by extending either adjacent vma (prot
> and flags and file and offset all match up), that's what's done and no
> separate vma is created.  (And adjacent vmas get merged when mprotect
> removes the difference in protection.)
> 
> I don't think there's any such reason to prefer brk to mmap.  But you
> may have encountered something which we in the kernel are thinking of
> as an insignificant corner case, which is actually breaking things up
> badly in practice (I recall the kernel's internal VM_ACCOUNT flag,
> relating to non-overcommit accounting, which might get turned on at
> any time, sometimes preventing a vma merge you'd otherwise expect).
> Please let me know if you've a test case which shows more vmas than
> expected.

The only way I can see vma fragmentation happen in that case, is if 
userspace uses a mixture of mmaps and mallocs, and flags+prots of the two 
does not match. The glibc allocator seems to support it just fine. There's 
a macro where you specify if the heaps are contiguous or not.


- Davide


