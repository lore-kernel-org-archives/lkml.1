Return-Path: <linux-kernel-owner+w=401wt.eu-S1751766AbZL0May@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751766AbZL0May (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Dec 2009 07:30:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751559AbZL0Max
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Dec 2009 07:30:53 -0500
Received: from crmm.lgl.lu ([158.64.72.228]:59223 "EHLO lll.lu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751515AbZL0Max (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Dec 2009 07:30:53 -0500
Message-ID: <4B3752F5.3080205@knaff.lu>
Date: Sun, 27 Dec 2009 13:28:37 +0100
From: Alain Knaff <alain@knaff.lu>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: Arjan van de Ven <arjan@infradead.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Mark Hounschell <markh@compro.net>,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       "dmarkh@cfl.rr.com" <dmarkh@cfl.rr.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "fdutils@fdutils.linux.lu" <fdutils@fdutils.linux.lu>,
       "Li, Shaohua" <shaohua.li@intel.com>, Ingo Molnar <mingo@elte.hu>,
       morgan@physics.ucla.edu, JONES@UINPLA.NPL.UIUC.EDU
Subject: Re: [Fdutils] DMA cache consistency bug introduced in 2.6.28
References: <4B3214EC.6020308@compro.net> <6598A4E21F1DB24D80BF72956484F59802EFD1C6@orsmsx001.amr.corp.intel.com> <4B32386B.2060509@compro.net> <alpine.LFD.2.00.0912230828230.6879@localhost.localdomain> <87bphpd4rt.fsf@basil.nowhere.org> <alpine.LFD.2.00.0912230845550.6879@localhost.localdomain> <20091223170832.GH20539@basil.fritz.box> <20091225132116.6c9089f2@infradead.org> <20091225203304.GA22306@basil.fritz.box> <20091226103835.68479100@infradead.org> <20091226164029.GA10256@basil.fritz.box>
In-Reply-To: <20091226164029.GA10256@basil.fritz.box>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
>>> Does pmqos work with apci=off etc.? 
>> yes
>>
>>> I didn't think it shut down
>>> the classic "HLT" idle, does it? 
>> it does if you specify a latency of 0; it will then go into the
>> spin-only state until you give up your latency requirement
> 
> I looked at it this evening, but it seems like pm_qos is not
> interrupt safe (e.g. calls blocking notifiers) and floppy currently does 
> enable/disable_hlt from interrupts and bottom halves.  
> 
> Would need some more infrastructure work or restructuring 
> of the floppy driver.
> 
> -Andi

disable_hlt/enable_hlt was only needed to work around a bug on TM4000
(Texas Instrument) Laptops which were popular around 1994 / 1995.
Basically, as soon as the CPU went into hlt() state, so did the DMA
controller, either causing a really slow transfer, or (worse) a buffer
over/underrun which failed the operation.

On hardware unaffected by this particular bug (which would be most
hardware around now, 14 years after the fact...), these calls can safely
be removed.

Regards,

Alain

