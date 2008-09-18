Return-Path: <linux-kernel-owner+w=401wt.eu-S1755685AbYIRBOY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755685AbYIRBOY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2008 21:14:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753149AbYIRBOQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Sep 2008 21:14:16 -0400
Received: from terminus.zytor.com ([198.137.202.10]:49901 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753082AbYIRBOP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2008 21:14:15 -0400
Message-ID: <48D1AA62.6020601@zytor.com>
Date: Wed, 17 Sep 2008 18:09:54 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: Jack Steiner <steiner@sgi.com>, Dean Nelson <dcn@sgi.com>,
       Ingo Molnar <mingo@elte.hu>, Alan Mayer <ajm@sgi.com>, jeremy@goop.org,
       rusty@rustcorp.com.au, suresh.b.siddha@intel.com,
       torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, Yinghai Lu <Yinghai.lu@amd.com>
Subject: Re: [RFC 0/4] dynamically allocate arch specific system vectors
References: <489C6844.9050902@sgi.com> <20080811165930.GI4524@elte.hu>	<48A0737F.9010207@sgi.com> <m1y733mjdh.fsf@frodo.ebiederm.org>	<20080911152304.GA13655@sgi.com> <20080914153522.GJ29290@elte.hu>	<20080915215053.GA11657@sgi.com> <20080916082448.GA17287@elte.hu>	<20080916204654.GA3532@sgi.com> <48D1575E.1050306@zytor.com>	<20080917202102.GA166524@sgi.com> <m1zlm6zafo.fsf@frodo.ebiederm.org>
In-Reply-To: <m1zlm6zafo.fsf@frodo.ebiederm.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric W. Biederman wrote:
>> It is one vector for each cpu.
>>
>> It is more efficient for software if the vector # is the same for all cpus
> Why?  Especially in terms of irq counting that would seem to lead to cache
> line conflicts.
> 
>> but the software/hardware can support a unique vector for each cpu. This
>> assumes, of course, that the driver can determine the irq->vector mapping for
>> each cpu.
> 
> That sounds like you have a non-standard MSI-X vector.  You certainly have all of
> the same properties.  At which point create_irq() sounds like what you want.
> 
> One irq per cpu, per device.
> 
> It is the trend.  Don't worry all of the high performance drivers are doing it.
> That is the path that will be optimized.
> 

In particular, it's just another interrupt type.  We already have quite 
a few of those, from XT-PIC to the various IOAPIC ones, to MSI and MSI-X.

Just treating these as variants of MSI seems to me to make most sense, too.

	-hpa

