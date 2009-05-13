Return-Path: <linux-kernel-owner+w=401wt.eu-S1761795AbZEMVbo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761795AbZEMVbo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 May 2009 17:31:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761495AbZEMVbZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 May 2009 17:31:25 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:53212 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761613AbZEMVbY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 May 2009 17:31:24 -0400
Message-ID: <4A0B3BF3.1050804@garzik.org>
Date: Wed, 13 May 2009 17:30:27 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Hitoshi Mitake <h.mitake@gmail.com>, Roland Dreier <rdreier@cisco.com>,
       Ingo Molnar <mingo@elte.hu>, David Miller <davem@davemloft.net>,
       Linus Torvalds <torvalds@linux-foundation.org>, tglx@linutronix.de,
       rpjday@crashcourse.ca, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: Remove readq()/writeq() on 32-bit
References: <49EE37AF.4020507@zytor.com>	 <20090421.173123.191021055.davem@davemloft.net>	 <adak55438gp.fsf_-_@cisco.com>	 <20090428.221228.217954247.davem@davemloft.net>	 <20090429115654.GC11586@elte.hu> <49F843BC.7020902@garzik.org>	 <adahc071ie4.fsf@cisco.com> <49F8B1A1.4010208@garzik.org> <a6b9f31a0905122232s2d23b4e3h6e447c3fa5c29ee6@mail.gmail.com> <4A0B30D0.4060806@garzik.org> <4A0B3605.8090007@zytor.com>
In-Reply-To: <4A0B3605.8090007@zytor.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.5 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin wrote:
> Jeff Garzik wrote:
>> Roland's patch was acked, apparently, _in spite of_ the commonly 
>> accepted readq() definition already being in use!
>>
>> Thusfar, I see two things:
>>
>> (1) years of history has shown that non-atomic readq/writeq on 32-bit 
>> platforms has been sufficient, based on testing and experience.  In 
>> fact, in niu's case, a common readq/writeq would have PREVENTED a bug.
>>
>> (2) unspecified fears continue to linger about non-atomicity
>>
>> We should not base decisions on fear, particularly when the weight of 
>> evidence and experience points in the other direction.
>>
> 
> I have personally dealt with at least one device who'd want to opt out
> of a standard readq/writeq (it's not in-tree because it never shipped,
> unfortunately.)  Doing the opt-in headers seems like a reasonable thing
> to do to me, but perhaps I'm just being overly paranoid.

Isn't that a variant of "punish all sane hardware, because bizarre 
unshipped hardware exists"?

IMO the best fix is to document existing readq assumptions, and 
standardize that definition on other platforms.

The burden of special casing for bizarre hardware should not fall on 
/sane/ drivers and hardware, who should be the ones opting _out_ of the 
standard regime.

	Jeff



