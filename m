Return-Path: <linux-kernel-owner+w=401wt.eu-S932212AbZHND3Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932212AbZHND3Q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Aug 2009 23:29:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754455AbZHND3P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Aug 2009 23:29:15 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:38143
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754442AbZHND3P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Aug 2009 23:29:15 -0400
Date: Thu, 13 Aug 2009 20:29:25 -0700 (PDT)
Message-Id: <20090813.202925.84343745.davem@davemloft.net>
To: heyongli@gmail.com
Cc: linux-kernel@vger.kernel.org, sparclinux@vger.kernel.org
Subject: Re: Sparc miss chance to fix recoverable fault in copy_from_user
From: David Miller <davem@davemloft.net>
In-Reply-To: <505766fa0908132016v1e705525r92e42c142897bc82@mail.gmail.com>
References: <505766fa0908111853y7030399ewb07d4cec6829fd16@mail.gmail.com>
	<20090813.124838.210334778.davem@davemloft.net>
	<505766fa0908132016v1e705525r92e42c142897bc82@mail.gmail.com>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: hyl <heyongli@gmail.com>
Date: Fri, 14 Aug 2009 11:16:41 +0800

> console is: (access the address 0xffff fff0 )
>     SUN4V-DTLB: Error at TPC[5f2cc8], tl 1
>     SUN4V-DTLB: TPC<memcpy_user_stub+0x8/0x40>
>     SUN4V-DTLB: O7[4af23c]
>     SUN4V-DTLB: O7<probe_kernel_read+0x3c/0xa0>
>     SUN4V-DTLB: vaddr[ffffffffffffe000] ctx[0] pte[800007ffffffe743] error[2]
> 
> 
> the problem is :
> this DTLB fault can be fixed by search extable, by fall to the
> do_sparc64_fault, my draft proposal can verify this:  with this patch, this kind
> of fault is recovery, so enable copy_from_user  return error instead of halt.
> 
> in addition, it is triggered in kernel space, search the extable is mandatory .

No, that's not the problem.

The problem is that the virtual address validation done in the TLB
miss path accepts the address printed in:

>     SUN4V-DTLB: vaddr[ffffffffffffe000] ctx[0] pte[800007ffffffe743] error[2]

That's the real bug, not any of the other things you are talking
about.

Your "fix" would only paper over this problem.
