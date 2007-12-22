Return-Path: <linux-kernel-owner+w=401wt.eu-S1754226AbXLVMqY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754226AbXLVMqY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Dec 2007 07:46:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751080AbXLVMqP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Dec 2007 07:46:15 -0500
Received: from one.firstfloor.org ([213.235.205.2]:43313 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750921AbXLVMqO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Dec 2007 07:46:14 -0500
Date: Sat, 22 Dec 2007 13:47:10 +0100
From: Andi Kleen <andi@firstfloor.org>
To: David Miller <davem@davemloft.net>
Cc: andi@firstfloor.org, mtk.manpages@googlemail.com,
       akpm@linux-foundation.org, lkml@davidb.org, paulus@samba.org,
       drepper@redhat.com, cfriesen@nortel.com, schwab@suse.de,
       linux-kernel@vger.kernel.org
Subject: Re: compat_sys_times() bogus until jiffies >= 0.
Message-ID: <20071222124710.GC14767@one.firstfloor.org>
References: <20071221.174124.208826257.davem@davemloft.net> <20071221.174547.136433173.davem@davemloft.net> <20071222015311.GB4477@one.firstfloor.org> <20071221.203640.46152937.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071221.203640.46152937.davem@davemloft.net>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 21, 2007 at 08:36:40PM -0800, David Miller wrote:
> From: Andi Kleen <andi@firstfloor.org>
> Date: Sat, 22 Dec 2007 02:53:11 +0100
> 
> > > And to handle potentially ambiguous cases we, for a long time, have
> > > the force_successful_syscall_return() arch hook. 
> > 
> > Ah I see what you mean now.
> > 
> > Thanks for the clarification.
> 
> Thanks for continuing to insist it's "impossible" :-)

It's still hard -- e.g. i'm not sure your condition flag setting would 
be even possible for i386 SYSEXIT which does not restore EFLAGS
from memory and has some other constraints too. And there is no
free other register to use for this either on i386 nor x86-64.

Ok you could always disable SYSEXIT on force_successfull_return(),
but then e.g. all lseek()s would use the slow path which might not
be a good idea.

-Andi

