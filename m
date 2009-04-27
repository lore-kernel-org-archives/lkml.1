Return-Path: <linux-kernel-owner+w=401wt.eu-S1757493AbZD0XH0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757493AbZD0XH0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Apr 2009 19:07:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755151AbZD0XHL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Apr 2009 19:07:11 -0400
Received: from smtp-outbound-2.vmware.com ([65.115.85.73]:47760 "EHLO
	smtp-outbound-2.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756334AbZD0XHK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Apr 2009 19:07:10 -0400
Subject: Default HZ value for X86
From: Alok Kataria <akataria@vmware.com>
Reply-To: akataria@vmware.com
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>
Cc: the arch/x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Organization: VMware INC.
Date: Mon, 27 Apr 2009 16:07:10 -0700
Message-Id: <1240873630.14713.25.camel@alok-dev1>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-8.el5_2.3) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, 

I was wondering why do we still have the default HZ value as 1000 for
the x86 kernels.

arch/x86/configs/i386_defconfig:CONFIG_HZ=1000
arch/x86/configs/x86_64_defconfig:CONFIG_HZ=1000

With the highres timer implementation it was planned to move away from
relying on high timer interrupt frequency for applications requiring
precise high resolution timer's. 

This quote in the timer/hrtimers.txt also mentions that we should be
able to decrease the frequency of the timeout subsystem, which I assume
would mean reducing HZ value.

---------------------------------------------------------------------
"Another potential benefit is that such a separation allows even more
special-purpose optimization of the existing timer wheel for the low
resolution and low precision use cases - once the precision-sensitive
APIs are separated from the timer wheel and are migrated over to
hrtimers. E.g. we could decrease the frequency of the timeout subsystem
from 250 Hz to 100 HZ (or even smaller)."
---------------------------------------------------------------------

So, are there still any concerns that keep us from lowering the default
HZ value down to 250/100 for mainline ? 

Thanks,
Alok

