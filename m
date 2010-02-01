Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752885Ab0BAVwt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Feb 2010 16:52:49 -0500
Received: from terminus.zytor.com ([198.137.202.10]:45966 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751907Ab0BAVws (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Feb 2010 16:52:48 -0500
Message-ID: <4B674C82.9050703@zytor.com>
Date: Mon, 01 Feb 2010 13:49:54 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc12 Thunderbird/3.0.1
MIME-Version: 1.0
To: Suresh Siddha <suresh.b.siddha@intel.com>
CC: "Maciej W. Rozycki" <macro@linux-mips.org>,
       "ebiederm@xmission.com" <ebiederm@xmission.com>,
       "yinghai@kernel.org" <yinghai@kernel.org>,
       "mingo@elte.hu" <mingo@elte.hu>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [patch 2/2] x86, irq: use 0x20 for the IRQ_MOVE_CLEANUP_VECTOR
 instead of 0x1f
References: <20100114002118.436172066@sbs-t61.sc.intel.com>	 <20100114002118.521826763@sbs-t61.sc.intel.com>	 <alpine.LFD.2.00.1001240545180.13034@eddie.linux-mips.org>	 <4B5C00EB.3000208@zytor.com>	 <alpine.LFD.2.00.1001310705280.31764@eddie.linux-mips.org> <1265059497.2802.178.camel@sbs-t61.sc.intel.com>
In-Reply-To: <1265059497.2802.178.camel@sbs-t61.sc.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/01/2010 01:24 PM, Suresh Siddha wrote:
> 
> As we are using the code from 2.6.28 and no one noticed/complained about
> this issue for more than 1.5 years, probably the pentium APIC issue is
> not wide-spread.
> 

I *think* it's applicable to all CPUs Pentium III or earlier (but not
Pentium 4 -- I'm unsure about the Pentium M.)  I don't know about
non-Intel CPUs; I have a vague memory of the Transmeta Efficeon (the
only Transmeta chip with an APIC) *not* having this limitation.

The exact reference is SDM vol 3A 10.8.4, page 10-41 [rev 033US Dec 2009]:

For the P6 family and Pentium processors, the IRR and ISR registers can
queue no more than two interrupts per priority level, and will reject
other interrupts that are received within the same priority level.

However, section 10.8.2 bullet 3 on page 10-38 (and the flowchart on
page 10-37) indicate that such an interrupt is returned to the IOAPIC
for a later retry, i.e. it's not lost.  As such, it's not clear to me
from reading the SDM that there is actually a problem here...

	-hpa
