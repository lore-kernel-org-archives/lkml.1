Return-Path: <linux-kernel-owner+w=401wt.eu-S1753677AbYHGQGe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753677AbYHGQGe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2008 12:06:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754352AbYHGQGT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Aug 2008 12:06:19 -0400
Received: from one.firstfloor.org ([213.235.205.2]:49834 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754175AbYHGQGT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2008 12:06:19 -0400
Date: Thu, 7 Aug 2008 18:07:02 +0200
From: Andi Kleen <andi@firstfloor.org>
To: jmerkey@wolfmountaingroup.com
Cc: Andi Kleen <andi@firstfloor.org>,
       Jason Wessel <jason.wessel@windriver.com>,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       Geert Uytterhoeven <geert@linux-m68k.org>,
       Stefan Richter <stefanr@s5r6.in-berlin.de>,
       Josh Boyer <jwboyer@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [ANNOUNCE] Merkey's Kernel Debugger
Message-ID: <20080807160702.GF24801@one.firstfloor.org>
References: <17494.166.70.238.46.1217784156.squirrel@webmail.wolfmountaingroup.com> <Pine.LNX.4.64.0808051140150.6309@anakin> <33030.166.70.238.45.1217948565.squirrel@webmail.wolfmountaingroup.com> <200808060133.10457.nickpiggin@yahoo.com.au> <87r6926dsr.fsf@basil.nowhere.org> <4899DD9F.6020007@windriver.com> <20080806185719.GE24801@one.firstfloor.org> <37747.166.70.238.45.1218113134.squirrel@webmail.wolfmountaingroup.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <37747.166.70.238.45.1218113134.squirrel@webmail.wolfmountaingroup.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Also, whoever wrote "/Documentation/volatiles_are_evil" must not have
> worked with the busted-ass GNU compiler that optimizes away global
> variables and busts SMP dependent code.  I am not going to remove the

The Linux way to handle this is to use gcc memory barriers.
mb()/barrier()/wmb()/rmb()/smp_rmb()/smp_wmb() etc.
Normally everything that volatile can do can be expressed by them.

On x86 such a memory barrier tells gcc that memory might
have been clobbered and needs to be flushed and also prevents the compiler 
from reordering memory accesses. On other architectures it also forces ordering
on the CPU level, although that's not needed on x86 (except
in some special situations like using write-combining)

See Documentation/memory-barriers.txt

-Andi

