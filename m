Return-Path: <linux-kernel-owner+w=401wt.eu-S1752892AbYI2Osw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752892AbYI2Osw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2008 10:48:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751483AbYI2Osp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Sep 2008 10:48:45 -0400
Received: from one.firstfloor.org ([213.235.205.2]:48155 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751411AbYI2Oso (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2008 10:48:44 -0400
Date: Mon, 29 Sep 2008 16:54:08 +0200
From: Andi Kleen <andi@firstfloor.org>
To: dean gaudet <odo@google.com>
Cc: Andi Kleen <andi@firstfloor.org>, Pardo <pardo@google.com>,
       linux-kernel@vger.kernel.org, mbligh@google.com, briangrant@google.com,
       nil@google.com, jyasskin@google.com
Subject: Re: Faster getcpu() and sched_getcpu()
Message-ID: <20080929145408.GQ25711@one.firstfloor.org>
References: <af8810200809111648n55e05ac9g286fcd498690432f@mail.gmail.com> <af8810200809231209w7428347neb88094e543a048f@mail.gmail.com> <87wsgwp6gh.fsf@basil.nowhere.org> <48E0834D.6010608@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48E0834D.6010608@google.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 29, 2008 at 12:27:09AM -0700, dean gaudet wrote:
> Andi Kleen wrote:
> > I'm still not sure why you say no redzone is that expensive? Do you
> > have numbers?  I know it's a few instructions, but it shouldn't 
> > be that expensive.
> >
> >   
> 
> it depends on the processor involved and the kernel config options --
> i.e. if frame pointers are enabled then the stack frame guarantees a
> store operation (push rbp) and on processors which do memops in-order
> this delays the other memops in the vsyscall (i.e. testing the cache or
> executing SIDT).  it was 2 or 3 cycles difference in most cases iirc.

Ok frame pointers are always a performance disasters on some CPUs.
Perhaps they should be just unconditionally disabled for vsyscall.c
and the vdso

-Andi
-- 
ak@linux.intel.com
