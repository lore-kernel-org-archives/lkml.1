Return-Path: <linux-kernel-owner+w=401wt.eu-S1754524AbYFZES6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754524AbYFZES6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 00:18:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751467AbYFZESq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 00:18:46 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:38289
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751336AbYFZESq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 00:18:46 -0400
Date: Wed, 25 Jun 2008 21:18:46 -0700 (PDT)
Message-Id: <20080625.211846.227713352.davem@davemloft.net>
To: vda.linux@googlemail.com
Cc: mpatocka@redhat.com, linux-kernel@vger.kernel.org,
       sparclinux@vger.kernel.org
Subject: Re: [3/10 PATCH] inline wake_up_bit
From: David Miller <davem@davemloft.net>
In-Reply-To: <200806260535.59306.vda.linux@googlemail.com>
References: <200806252237.58046.vda.linux@googlemail.com>
	<20080625.172838.242554644.davem@davemloft.net>
	<200806260535.59306.vda.linux@googlemail.com>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Denys Vlasenko <vda.linux@googlemail.com>
Date: Thu, 26 Jun 2008 05:35:59 +0200

> On Thursday 26 June 2008 02:28, David Miller wrote:
> > From: Denys Vlasenko <vda.linux@googlemail.com>
> > Date: Wed, 25 Jun 2008 22:37:58 +0200
> > > > Sparc64 has register windows: it passes arguments in registers, but it 
> > > > must allocate space for that registers. If the call stack is too deep (8 
> > > > levels), the CPU runs out of registers and starts spilling the registers 
> > > > of the function 8-levels-deep to the stack.
> > > > 
> > > > The stack usage could be reduced to 176 bytes with little work from gcc 
> > > > developers and to 128 bytes with more work (ABI change). If you wanted to 
> > > 
> > > Wow, it's nearly x2 reduction.
> > > 
> > > ABI change in not a problem for kernel, since it is a "freestanding
> > > application". Exactly like i386 switched to regparm, which is a different ABI.
> > 
> > Except that nobody has written this code and therefore being about to
> > use this unimplemented compiler facility to get correctness is not
> > tenable.
> 
> Inlining everything is even less tenable.

I never suggested this.  Although I do support inlining the
cases which merely adjust the ordering of arguments being
passed to function calls, because such inlines are essentially
of zero cost and of gain to all platforms.

> I am all for fixing code where there are extra useless levels of calls,
> but in this example I pointed out that patch adds inlines too liberally.
> Do you agree that blowing up every wake_up_bit() into half a dozen
> or more C lines is not what we want?

I stated my suggested alternative to this in another posting, so of
course I do not support it as-is.
