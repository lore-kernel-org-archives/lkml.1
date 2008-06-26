Return-Path: <linux-kernel-owner+w=401wt.eu-S1756516AbYFZA2s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756516AbYFZA2s (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2008 20:28:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753790AbYFZA2j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jun 2008 20:28:39 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:47123
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752355AbYFZA2i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2008 20:28:38 -0400
Date: Wed, 25 Jun 2008 17:28:38 -0700 (PDT)
Message-Id: <20080625.172838.242554644.davem@davemloft.net>
To: vda.linux@googlemail.com
Cc: mpatocka@redhat.com, linux-kernel@vger.kernel.org,
       sparclinux@vger.kernel.org
Subject: Re: [3/10 PATCH] inline wake_up_bit
From: David Miller <davem@davemloft.net>
In-Reply-To: <200806252237.58046.vda.linux@googlemail.com>
References: <200806251724.57689.vda.linux@googlemail.com>
	<Pine.LNX.4.64.0806251148550.20484@engineering.redhat.com>
	<200806252237.58046.vda.linux@googlemail.com>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Denys Vlasenko <vda.linux@googlemail.com>
Date: Wed, 25 Jun 2008 22:37:58 +0200

> On Wednesday 25 June 2008 18:01, Mikulas Patocka wrote:
> > > Ingo's suggestion to talk to gcc people to remedy
> > > insane call convention sounds as a more workable solution.
> > >
> > > BTW, i386 uses regparm call convention, is similar trick
> > > possible for sparc64?
> > 
> > Sparc64 has register windows: it passes arguments in registers, but it 
> > must allocate space for that registers. If the call stack is too deep (8 
> > levels), the CPU runs out of registers and starts spilling the registers 
> > of the function 8-levels-deep to the stack.
> > 
> > The stack usage could be reduced to 176 bytes with little work from gcc 
> > developers and to 128 bytes with more work (ABI change). If you wanted to 
> 
> Wow, it's nearly x2 reduction.
> 
> ABI change in not a problem for kernel, since it is a "freestanding
> application". Exactly like i386 switched to regparm, which is a different ABI.

Except that nobody has written this code and therefore being about to
use this unimplemented compiler facility to get correctness is not
tenable.
