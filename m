Return-Path: <linux-kernel-owner+w=401wt.eu-S1161029AbXDJXCU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161029AbXDJXCU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2007 19:02:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161034AbXDJXCT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Apr 2007 19:02:19 -0400
Received: from smtp-outbound-1.vmware.com ([65.113.40.141]:33043 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1161029AbXDJXCS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2007 19:02:18 -0400
Message-ID: <461C16E0.6010702@vmware.com>
Date: Tue, 10 Apr 2007 15:59:44 -0700
From: Zachary Amsden <zach@vmware.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070221)
MIME-Version: 1.0
To: Chris Wright <chrisw@sous-sol.org>
CC: Andrew Morton <akpm@osdl.org>, Andi Kleen <ak@muc.de>,
       Thomas Gleixner <tglx@linutronix.de>,
       Virtualization Mailing List <virtualization@lists.osdl.org>,
       Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 9/10] Vmi timer update.patch
References: <200704100006.l3A06RUR020644@zach-dev.vmware.com> <20070410023702.GJ10574@sequoia.sous-sol.org> <461BC373.10306@vmware.com> <20070410172429.GN10574@sequoia.sous-sol.org> <461C084C.9020009@vmware.com> <20070410222844.GN19575@sequoia.sous-sol.org>
In-Reply-To: <20070410222844.GN19575@sequoia.sous-sol.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Chris Wright wrote:
> * Zachary Amsden (zach@vmware.com) wrote:
>   
>> Yes, but unfortunately that is a nop:
>>
>>         /*
>>          * Avoid unnecessary state transitions, as it confuses
>>          * Geode / Cyrix based boxen.
>>          */
>>         case CLOCK_EVT_MODE_SHUTDOWN:
>>                 if (evt->mode == CLOCK_EVT_MODE_UNUSED)
>>                         break;
>>         case CLOCK_EVT_MODE_UNUSED:
>>                 if (evt->mode == CLOCK_EVT_MODE_SHUTDOWN)
>>                         break;
>>     
>
> This one should be fallthrough case during exchange (mode == PERIODIC)
>   

Yes, seems PERIODIC->SHUTDOWN should do the right thing.


>>         case CLOCK_EVT_MODE_ONESHOT:
>>                 /* One shot setup */
>>                 outb_p(0x38, PIT_MODE);
>>
>> So switching from PIT to VMI does not disable PIT timer interrupts.  
>> Thus I have to keep this part of the patch.
>>     

Since I misread the code, I can drop this now.


>
> Oh, I was looking at this (x86_64 work I have here):
>
> 	case CLOCK_EVT_MODE_SHUTDOWN:
> 	case CLOCK_EVT_MODE_UNUSED:
> 		outb_p(0x30, PIT_MODE);
> 		outb_p(0, PIT_CH0);	/* LSB */
> 		outb_p(0, PIT_CH0);	/* MSB */
> 		break;
>
> That's mode 0, not mode 5, but I think the end result is the same.
>   

Yes, mode 0, 4, 5 all should behave similarly.

Zach
