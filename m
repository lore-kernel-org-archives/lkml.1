Return-Path: <linux-kernel-owner+w=401wt.eu-S934254AbZDBBzt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934254AbZDBBzt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Apr 2009 21:55:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756272AbZDBBzk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Apr 2009 21:55:40 -0400
Received: from hera.kernel.org ([140.211.167.34]:41331 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755764AbZDBBzj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Apr 2009 21:55:39 -0400
Message-ID: <49D41ABC.7070603@kernel.org>
Date: Thu, 02 Apr 2009 10:54:04 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Martin Schwidefsky <schwidefsky@de.ibm.com>
CC: David Miller <davem@davemloft.net>, mingo@elte.hu, rusty@rustcorp.com.au,
       tglx@linutronix.de, x86@kernel.org, linux-kernel@vger.kernel.org,
       hpa@zytor.com, lethal@linux-sh.org, rmk@arm.linux.org.uk,
       starvik@axis.com, ralf@linux-mips.org, cooloney@kernel.org,
       kyle@mcmartin.ca, matthew@wil.cx, grundler@parisc-linux.org,
       takata@linux-m32r.org, benh@kernel.crashing.org, rth@twiddle.net,
       ink@jurassic.park.msu.ru, heiko.carstens@de.ibm.com
Subject: Re: [GIT RFC] percpu: use dynamic percpu allocator as the default
 percpu allocator
References: <20090401101054.0a4b187d@skybase>	<49D3231D.2040403@kernel.org>	<20090401103257.12c2517e@skybase>	<20090401.013702.66171229.davem@davemloft.net>	<20090401104737.22c8c66c@skybase>	<49D32AE5.70709@kernel.org> <20090401110846.0536df11@skybase>
In-Reply-To: <20090401110846.0536df11@skybase>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 02 Apr 2009 01:53:26 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Martin Schwidefsky wrote:
>> Also, there is no guarantee that the offset from dynamic allocator
>> will fall in the same 4G.  There is reserve mechanism for static ones
>> for archs which need it but for dynamic ones, the offset can be any
>> value.
> 
> If we map the modules with a 4GB distance to the main kernel image then
> we don't have to worry about the offsets anymore. The compiler could
> just use LARL to get the address of the static per-cpu variables and
> SHIFT_PERCPU_PTR could be a RELOC_HIDE.

Ah... okay.  Great.  No more GOTENT trick for static ones and for
dynamic ones the compiler will generate indirection.

> It just that the remapping we need to do is sooo icky ..

Fingers and toes crossed.  It would improve general percpu access
performance too.

Thanks.

-- 
tejun
