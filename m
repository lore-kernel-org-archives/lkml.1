Return-Path: <linux-kernel-owner+w=401wt.eu-S1761901AbZDAIhc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761901AbZDAIhc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Apr 2009 04:37:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757703AbZDAIhQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Apr 2009 04:37:16 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:39024
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1756766AbZDAIhO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Apr 2009 04:37:14 -0400
Date: Wed, 01 Apr 2009 01:37:02 -0700 (PDT)
Message-Id: <20090401.013702.66171229.davem@davemloft.net>
To: schwidefsky@de.ibm.com
Cc: tj@kernel.org, mingo@elte.hu, rusty@rustcorp.com.au, tglx@linutronix.de,
       x86@kernel.org, linux-kernel@vger.kernel.org, hpa@zytor.com,
       lethal@linux-sh.org, rmk@arm.linux.org.uk, starvik@axis.com,
       ralf@linux-mips.org, cooloney@kernel.org, kyle@mcmartin.ca,
       matthew@wil.cx, grundler@parisc-linux.org, takata@linux-m32r.org,
       benh@kernel.crashing.org, rth@twiddle.net, ink@jurassic.park.msu.ru,
       heiko.carstens@de.ibm.com
Subject: Re: [GIT RFC] percpu: use dynamic percpu allocator as the default
 percpu allocator
From: David Miller <davem@davemloft.net>
In-Reply-To: <20090401103257.12c2517e@skybase>
References: <20090401101054.0a4b187d@skybase>
	<49D3231D.2040403@kernel.org>
	<20090401103257.12c2517e@skybase>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Martin Schwidefsky <schwidefsky@de.ibm.com>
Date: Wed, 1 Apr 2009 10:32:57 +0200

> The code sequence with @GOT:
> 
> 	larl	%r12,_GLOBAL_OFFSET_TABLE_
> 	lg	%r1,symbol@GOT(%r12)
> 
> is equivalent to:
> 
> 	larl	%r1,symbol@GOTENT
> 	lg	%r1,0(%r1)
> 
> The advantage of the second code sequence is that it need a single
> register and the size of the GOT is not limited to 4K as in the first
> example (the offset in an RX format instruction is limited to 12 bits -
> but that is probably something you don't want to know ;-).

If practical I think you guys should just force all of the module
address space below 4GB virtually, as we do on sparc64.  It's a good
way to avoid all of these problems.
