Return-Path: <linux-kernel-owner+w=401wt.eu-S1756185AbYIYUui@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756185AbYIYUui (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2008 16:50:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754631AbYIYUuX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Sep 2008 16:50:23 -0400
Received: from terminus.zytor.com ([198.137.202.10]:46134 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756089AbYIYUuW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2008 16:50:22 -0400
Message-ID: <48DBF964.7070106@zytor.com>
Date: Thu, 25 Sep 2008 13:49:40 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Vegard Nossum <vegard.nossum@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>, x86@kernel.org, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: v2.6.27-rc7: x86: #GP on panic?
References: <19f34abd0809241209l3a69d607v153549ee43e085e9@mail.gmail.com>	 <20080925080417.GB27048@elte.hu> <48DB5186.8060502@zytor.com>	 <19f34abd0809250707i18ded94aib177c884d4d6a3bd@mail.gmail.com>	 <19f34abd0809250820q2df15e93u43374b7317e2f7be@mail.gmail.com> <19f34abd0809251346r62cff1ck4730260f17e643b3@mail.gmail.com>
In-Reply-To: <19f34abd0809251346r62cff1ck4730260f17e643b3@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vegard Nossum wrote:
> 
> But I don't see how the divide error could occur here:
> 
> ffffffff8103918b:       fb                      sti
> ffffffff8103918c:       49 c7 c4 80 c0 6e 81    mov    $0xffffffff816ec080,%r12
> ffffffff81039193:       f6 c3 01                test   $0x1,%bl
> ffffffff81039196:       74 27                   je     ffffffff810391bf <__do_so
> ffffffff81039198:       4c 89 e7                mov    %r12,%rdi
> ffffffff8103919b:       41 ff 14 24             callq  *(%r12)
> 
> Seems like an external interrupt happened and was delivered after the sti?
> 
> Hm. I guess it smells like a qemu bug since it's rather easily
> reproducible here and sounds strange that nobody else saw it. Is qemu
> 0.9.1.
> 

Yes, but there shouldn't be any external interrupts that could turn into 
  a divide error.  It really smells like a Qemu problem -- possibly even 
a Qemu miscompile -- to me.

Does it reproduce in KVM?

	-hpa
